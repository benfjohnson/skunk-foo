module Main exposing (..)

import Html exposing (Html, div, text, h1, h2, h3, a, input, button)
import Html.Attributes exposing (class, href)


-- import Html.Events exposing (onClick)

import Date exposing (Date, fromString, now)
import Navigation
import Routing exposing (Route(..))
import Http
import Task
import Json.Decode exposing (..)
import Json.Decode.Extra as DecodeExtra


-- MAIN


main : Program Never
main =
    Navigation.program Routing.parser
        { init = init
        , update = update
        , view = viewPage
        , subscriptions = (\_ -> Sub.none)
        , urlUpdate = urlUpdate
        }


init : Result String Routing.Route -> ( Model, Cmd Msg )
init result =
    let
        currentRoute =
            Routing.routeFromResult result
    in
        urlUpdate result (model currentRoute)



-- MODEL


type alias Model =
    { pageTitle : String
    , posts : List Post
    , route : Routing.Route
    , isLoading : Bool
    }


type alias Post =
    { id : Int
    , title : String
    , message : String
    , date : Date
    , comments : List Comment
    }



-- createComment necessary because comment is a type and not type alias (due to recursiveness)


createComment : String -> Date -> List Comment -> Comment
createComment m d c =
    Comment { message = m, date = d, comments = c }


type Comment
    = Comment
        { message : String
        , date : Date
        , comments : List Comment
        }


model : Routing.Route -> Model
model initialRoute =
    { pageTitle = "National Football League"
    , posts = []
    , route = initialRoute
    , isLoading = False
    }



-- VIEW


viewPage : Model -> Html Msg
viewPage model =
    case model.route of
        AllPostsRoute ->
            viewPosts model

        PostsRoute _ ->
            viewPosts model

        PostRoute id ->
            let
                maybePost =
                    model.posts
                        |> List.filter (\p -> p.id == id)
                        |> List.head
            in
                case maybePost of
                    Just post ->
                        viewPost post

                    Nothing ->
                        viewPostNotFound

        NewPostRoute ->
            h1 [] [ text "NEW POST" ]

        RouteNotFound ->
            viewRouteNotFound


viewRouteNotFound : Html Msg
viewRouteNotFound =
    div [] [ h1 [] [ text "ERROR: PAGE NOT FOUND" ] ]


viewPostNotFound : Html Msg
viewPostNotFound =
    div [] [ text "Post not found!" ]


viewComments : List Comment -> Html Msg
viewComments comments =
    div []
        [ div [] (List.map viewComment comments)
        ]


viewComment : Comment -> Html Msg
viewComment comment =
    case comment of
        Comment cmt ->
            div [ class "post-container" ]
                [ div [] [ text cmt.message ]
                , (viewComments cmt.comments)
                ]


viewPost : Post -> Html Msg
viewPost post =
    div []
        [ div [ class "post-container" ]
            [ h1 [] [ text post.title ]
            , div [] [ post.date |> toString |> text ]
            , div [] [ text post.message ]
            ]
        , h2 [] [ text "Comments" ]
        , viewComments post.comments
        ]


viewPostLink : Post -> Html Msg
viewPostLink post =
    div [ class "post-container" ] [ a [ href ("#/post/" ++ toString post.id) ] [ text post.title ] ]


viewPosts : Model -> Html Msg
viewPosts model =
    div [ class "row" ]
        [ div [ class "col-sm-9" ]
            [ h1 [] [ text model.pageTitle ]
            , div [] (List.map viewPostLink model.posts)
            ]
        , viewSidebar
        ]


viewSidebar : Html Msg
viewSidebar =
    div [ class "col-sm-3" ]
        [ a [ href "/#/new" ] [ text "Submit new post!" ]
        ]



-- UPDATE


type Msg
    = NoOp
    | Upvote String
    | Downvote String
    | FetchPosts
    | FetchPostsSuccess (List Post)
    | FetchPostsError Http.Error


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Upvote postId ->
            ( model, Cmd.none )

        Downvote postId ->
            ( model, Cmd.none )

        FetchPosts ->
            ( { model | isLoading = True }, Cmd.none )

        FetchPostsSuccess posts ->
            ( { model | posts = posts }, Cmd.none )

        _ ->
            ( model, Cmd.none )



-- ROUTING


urlUpdate : Result String Routing.Route -> Model -> ( Model, Cmd Msg )
urlUpdate result model =
    let
        currentRoute =
            Routing.routeFromResult result

        getCmd route =
            case route of
                AllPostsRoute ->
                    getAllPosts

                PostsRoute subName ->
                    getPostsBySubreddit subName

                _ ->
                    Cmd.none
    in
        ( { model | route = currentRoute }, getCmd currentRoute )


getDate : String -> Date
getDate dateString =
    dateString |> Date.fromString |> Result.withDefault (Date.fromTime 0)


postsDecoder : Decoder (List Post)
postsDecoder =
    Json.Decode.list postDecoder


postDecoder : Decoder (Post)
postDecoder =
    Json.Decode.object5 Post
        ("id" := int)
        ("title" := string)
        ("message" := string)
        ("date" := DecodeExtra.date)
        ("comments" := commentsDecoder)


commentsDecoder : Decoder (List Comment)
commentsDecoder =
    Json.Decode.list commentDecoder


commentDecoder : Decoder Comment
commentDecoder =
    Json.Decode.object3 createComment
        ("message" := string)
        ("date" := DecodeExtra.date)
        ("comments" := Json.Decode.list (DecodeExtra.lazy (\_ -> commentDecoder)))



-- HTTP CALLS


getPosts : String -> Cmd Msg
getPosts subReddit =
    Task.perform FetchPostsError FetchPostsSuccess (Http.get postsDecoder subReddit)


getAllPosts : Cmd Msg
getAllPosts =
    getPosts "/test-data/all-posts.json"



-- NOTE: This wouldn't normally hardcode a path, just pass a subReddit name to getPosts. Need to refactor once better architecture


getPostsBySubreddit : String -> Cmd Msg
getPostsBySubreddit subRedditName =
    case subRedditName of
        "nfl" ->
            getPosts "/test-data/nfl-posts.json"

        "food" ->
            getPosts "/test-data/food-posts.json"

        _ ->
            Cmd.none
