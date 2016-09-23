module Main exposing (..)

import Html exposing (Html, div, text, h1)


-- import Html.Events exposing (onClick)

import Html.App exposing (beginnerProgram)


main : Program Never
main =
    beginnerProgram { model = model, update = update, view = view }



-- MODEL


type alias Model =
    { posts : List Post
    , title : String
    }


type alias Post =
    { message : String
    , date : String
    , comments : Responses
    }


type alias Comment =
    { message : String
    , date : String
    , responses : Responses
    }


type Responses
    = Responses (List Comment)


model : Model
model =
    { posts =
        [ Post "What's up with airplane food???" "1/2/15" (Responses [])
        , Post "YOLO YOLO YOLO" "3/19/16" (Responses [])
        , Post "I'm jc u??" "1/2/15" (Responses [])
        , Post "Hey guys crazy right?" "abcdefg" (Responses [])
        ]
    , title = "Really Cool Page Numba 123"
    }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text model.title ]
        , div [] (List.map (\post -> div [] [ text post.message ]) model.posts)
        ]



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model
