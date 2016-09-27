module Main exposing (..)

import Html exposing (Html, div, text, h1, h2, a)
import Html.Attributes exposing (class, href)
import Date exposing (Date, fromString, now)
import Navigation
import Routing exposing (Route(..))


-- import Html.Events exposing (onClick)


main : Program Never
main =
    Navigation.program Routing.parser
        { init = init
        , update = update
        , view = viewPage
        , subscriptions = (\_ -> Sub.none)
        , urlUpdate = urlUpdate
        }


getDate : String -> Date
getDate dateString =
    dateString |> Date.fromString |> Result.withDefault (Date.fromTime 0)



-- MODEL


init : Result String Routing.Route -> ( Model, Cmd Msg )
init result =
    let
        currentRoute =
            Routing.routeFromResult result
    in
        ( model currentRoute, Cmd.none )


type alias Model =
    { pageTitle : String
    , posts : List Post
    , route : Routing.Route
    }


type alias Post =
    { id : Int
    , title : String
    , message : String
    , date : Date
    , comments : Responses
    }


type alias Comment =
    { message : String
    , date : Date
    , responses : Responses
    }


type Responses
    = Responses (List Comment)


model : Routing.Route -> Model
model initialRoute =
    { pageTitle = "National Football League"
    , posts =
        [ Post 0 "Is Jameis a bust?" "I think he is dog whatchu think?" (getDate "07/06/16") (Responses [])
        , Post 1 "Tom Brady likes balls!!!" "...title says it all" (getDate "08/12/16") (Responses [])
        , Post 2 "SEAAA---?" "hawks :*(" (getDate "01/31/16") (Responses [ Comment "Sick dude" (getDate "08/09/16") (Responses []) ])
        , Post 3 "Hey guys crazy right?" "U seen dat??" (getDate "09/23/16") (Responses [])
        , Post 4 "Drew Brees seen doing hot yoga" "U seen dat??" (getDate "09/23/16") (Responses [])
        ]
    , route = initialRoute
    }



-- VIEW


viewPage : Model -> Html Msg
viewPage model =
    case model.route of
        Posts ->
            viewPosts model

        Post id ->
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

        RouteNotFound ->
            viewRouteNotFound


viewRouteNotFound : Html Msg
viewRouteNotFound =
    div [] [ h1 [] [ text "ERROR: PAGE NOT FOUND" ] ]


viewPostNotFound : Html Msg
viewPostNotFound =
    div [] [ text "Post not found!" ]


viewComments : Responses -> Html Msg
viewComments responses =
    case responses of
        Responses comments ->
            div []
                [ h2 [] [ text "Comments" ]
                , div [] (List.map (\comment -> div [ class "post-container" ] [ text comment.message ]) comments)
                ]


viewPost : Post -> Html Msg
viewPost post =
    div []
        [ div [ class "post-container" ]
            [ h1 [] [ text post.title ]
            , div [] [ post.date |> toString |> text ]
            , div [] [ text post.message ]
            ]
        , viewComments post.comments
        ]


viewPostLink : Post -> Html Msg
viewPostLink post =
    div [ class "post-container" ] [ a [ href ("#/post/" ++ toString post.id) ] [ text post.title ] ]


viewPosts : Model -> Html Msg
viewPosts model =
    div []
        [ h1 [] [ text model.pageTitle ]
        , div [] (List.map viewPostLink model.posts)
        ]



-- UPDATE


type Msg
    = NoOp
    | Upvote String
    | Downvote String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Upvote postId ->
            ( model, Cmd.none )

        Downvote postId ->
            ( model, Cmd.none )



-- ROUTING


urlUpdate : Result String Routing.Route -> Model -> ( Model, Cmd Msg )
urlUpdate result model =
    let
        currentRoute =
            Routing.routeFromResult result
    in
        ( { model | route = currentRoute }, Cmd.none )
