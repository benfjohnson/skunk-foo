module Routing exposing (parser, routeFromResult, Route(..))

import Navigation
import UrlParser exposing (..)
import String


type Route
    = Posts
    | Post Int
    | RouteNotFound


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ format Posts (s "")
        , format Post (s "post" </> int)
        , format Posts (s "posts")
        ]


hashParser : Navigation.Location -> Result String Route
hashParser location =
    location.hash
        |> String.dropLeft 2
        |> parse identity matchers


parser : Navigation.Parser (Result String Route)
parser =
    Navigation.makeParser hashParser


routeFromResult : Result String Route -> Route
routeFromResult result =
    case result of
        Ok route ->
            route

        Err string ->
            RouteNotFound
