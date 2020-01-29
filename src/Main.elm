module Main exposing (main)

import BlogIndex
import Data.Author as Author
import Element exposing (Element, centerX, column, el, fill, height, width)
import Element.Font as Font
import Element.Region
import Head
import Html exposing (Html)
import MarkdownRenderer
import Metadata exposing (Metadata)
import PageHead exposing (head)
import Pages
import Pages.Document
import Pages.PagePath exposing (PagePath)
import Pages.Platform
import Pages.StaticHttp as StaticHttp
import Palette
import View.Article
import View.Header
import View.Page
import Webmanifest exposing (manifest)



-- the intellij-elm plugin doesn't support type aliases for Programs so we need to use this line
-- main : Platform.Program Pages.Platform.Flags (Pages.Platform.Model Model Msg Metadata Rendered) (Pages.Platform.Msg Msg Metadata Rendered)


type alias Rendered =
    ( Int, List (Element Msg) )


canonicalSiteUrl : String
canonicalSiteUrl =
    "https://kodefant.no/"


main : Pages.Platform.Program Model Msg Metadata Rendered
main =
    Pages.Platform.application
        { init = \_ -> init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , documents = [ markdownDocument ]
        , manifest = manifest
        , canonicalSiteUrl = canonicalSiteUrl
        , onPageChange = \_ -> ()
        , internals = Pages.internals
        }


markdownDocument : ( String, Pages.Document.DocumentHandler Metadata Rendered )
markdownDocument =
    Pages.Document.parser
        { extension = "md"
        , metadata = Metadata.decoder
        , body =
            \markdownBody ->
                MarkdownRenderer.markdownView markdownBody
        }


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( Model, Cmd.none )


type alias Msg =
    ()


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        () ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view :
    List ( PagePath Pages.PathKey, Metadata )
    ->
        { path : PagePath Pages.PathKey
        , frontmatter : Metadata
        }
    ->
        StaticHttp.Request
            { view : Model -> Rendered -> { title : String, body : Html Msg }
            , head : List (Head.Tag Pages.PathKey)
            }
view siteMetadata page =
    StaticHttp.succeed
        { view =
            \model viewForPage ->
                let
                    { title, body } =
                        pageView model siteMetadata page viewForPage
                in
                { title = title
                , body =
                    body
                        |> Element.layout
                            [ Element.width Element.fill
                            , height fill
                            , Font.size 20
                            , Font.family [ Font.typeface "Open Sans", Font.sansSerif ]
                            , Font.color (Element.rgba255 0 0 0 0.8)
                            ]
                }
        , head = head page.frontmatter
        }


pageView : Model -> List ( PagePath Pages.PathKey, Metadata ) -> { path : PagePath Pages.PathKey, frontmatter : Metadata } -> Rendered -> { title : String, body : Element Msg }
pageView model siteMetadata page ( _, viewForPage ) =
    case page.frontmatter of
        Metadata.Page metadata ->
            { title = metadata.title
            , body =
                View.Page.view metadata.title viewForPage page
            }

        Metadata.FrontPage metadata ->
            { title = metadata.title
            , body =
                column [ Element.width Element.fill, height fill ]
                    [ View.Header.view page.path
                    , el [ width fill, height fill ]
                        (column
                            [ Element.padding 50
                            , Element.spacing 40
                            , centerX
                            , Element.Region.mainContent
                            , Element.centerY
                            , Element.moveUp 60
                            ]
                            viewForPage
                        )
                    ]
            }

        Metadata.Article metadata ->
            { title = metadata.title
            , body = View.Article.view model metadata page viewForPage
            }

        Metadata.Author author ->
            { title = author.name
            , body =
                Element.column
                    [ Element.width Element.fill
                    ]
                    [ View.Header.view page.path
                    , Element.column
                        [ Element.padding 30
                        , Element.spacing 20
                        , Element.Region.mainContent
                        , Element.width (Element.fill |> Element.maximum 800)
                        , Element.centerX
                        ]
                        [ Palette.blogHeading author.name
                        , Author.view [] author
                        , Element.paragraph [ Element.centerX, Font.center ] [ Element.text "viewForPage" ]
                        ]
                    ]
            }

        Metadata.BlogIndex ->
            { title = "kodeFant.no - Blogg"
            , body =
                Element.column [ Element.width Element.fill ]
                    [ View.Header.view page.path
                    , Element.column
                        [ Element.padding 20
                        , Element.centerX
                        ]
                        [ BlogIndex.view siteMetadata ]
                    ]
            }
