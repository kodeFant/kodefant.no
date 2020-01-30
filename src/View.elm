module View exposing (view)

import BlogIndex
import Data.Author as Author
import Element exposing (Element, centerX, column, el, fill, height, text, width)
import Element.Font as Font
import Element.Region
import Head
import Html exposing (Html)
import MarkdownRenderer exposing (Rendered)
import Metadata exposing (Metadata)
import PageHead exposing (head)
import Pages
import Pages.PagePath exposing (PagePath)
import Pages.StaticHttp as StaticHttp
import Palette
import Types exposing (Model, Msg)
import View.Article
import View.Header
import View.Nav exposing (mobileMenu)
import View.Page


view :
    List ( PagePath Pages.PathKey, Metadata )
    ->
        { path : PagePath Pages.PathKey
        , frontmatter : Metadata
        }
    ->
        StaticHttp.Request
            { view : Model -> Rendered Msg -> { title : String, body : Html Msg }
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
                            , Element.inFront (mobileMenu model.mobileMenuVisible page.path)
                            ]
                }
        , head = head page.frontmatter
        }


pageView :
    Model
    -> List ( PagePath Pages.PathKey, Metadata )
    -> { path : PagePath Pages.PathKey, frontmatter : Metadata }
    -> Rendered Msg
    -> { title : String, body : Element Msg }
pageView model siteMetadata page ( _, viewForPage ) =
    case page.frontmatter of
        Metadata.Page metadata ->
            { title = metadata.title
            , body =
                View.Page.view metadata.title viewForPage page model
            }

        Metadata.FrontPage metadata ->
            { title = metadata.title
            , body =
                column [ Element.width Element.fill, height fill ]
                    [ View.Header.view page.path model
                    , el [ width fill, height fill ]
                        (column
                            [ Element.padding 50
                            , Element.spacing 40
                            , centerX
                            , Element.Region.mainContent
                            , Element.centerY
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
                    [ View.Header.view page.path model
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
                    [ View.Header.view page.path model
                    , Element.column
                        [ Element.padding 20
                        , Element.centerX
                        ]
                        [ BlogIndex.view siteMetadata ]
                    ]
            }
