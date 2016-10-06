module Routing exposing (parser, routeFromResult, Route(..))

import Navigation
import UrlParser exposing (..)
import String


type Route
    = AllPostsRoute
    | PostsRoute String
    | PostRoute Int
    | RouteNotFound
    | NewPostRoute


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ format AllPostsRoute (s "")
        , format PostRoute (s "post" </> int)
        , format AllPostsRoute (s "all")
        , format NewPostRoute (s "new")
        , format PostsRoute string
          -- , format (PostsRoute "nfl") (s "nfl")
          -- , format (PostsRoute "food") (s "food")
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

        Err _ ->
            RouteNotFound
