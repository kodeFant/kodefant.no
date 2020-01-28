module Main exposing (main)

import BlogIndex
import Color
import Data.Author as Author
import Date
import Element exposing (Element, centerX, column, el, fill, width)
import Element.Font as Font
import Element.Region
import Head
import Head.Seo as Seo
import Html exposing (Html)
import MarkdownRenderer
import Metadata exposing (Metadata)
import Pages exposing (images, pages)
import Pages.Document
import Pages.Manifest as Manifest
import Pages.Manifest.Category
import Pages.PagePath exposing (PagePath)
import Pages.Platform
import Pages.StaticHttp as StaticHttp
import Palette
import View.Article
import View.Header
import View.Page


manifest : Manifest.Config Pages.PathKey
manifest =
    { backgroundColor = Just Color.white
    , categories = [ Pages.Manifest.Category.education ]
    , displayMode = Manifest.Standalone
    , orientation = Manifest.Portrait
    , description = "kodefant.no - Utvikler og historieforteller."
    , iarcRatingId = Nothing
    , name = "kodefant"
    , themeColor = Just Color.white
    , startUrl = pages.index
    , shortName = Just "kodefant"
    , sourceIcon = images.iconPng
    }



-- the intellij-elm plugin doesn't support type aliases for Programs so we need to use this line
-- main : Platform.Program Pages.Platform.Flags (Pages.Platform.Model Model Msg Metadata Rendered) (Pages.Platform.Msg Msg Metadata Rendered)


type alias Rendered =
    ( Int, List (Element Msg) )


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
                column [ Element.width Element.fill ]
                    [ View.Header.view page.path
                    , el [ width fill ]
                        (column
                            [ Element.padding 50
                            , Element.spacing 40
                            , centerX
                            , Element.Region.mainContent
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


{-| <https://developer.twitter.com/en/docs/tweets/optimize-with-cards/overview/abouts-cards>
<https://htmlhead.dev>
<https://html.spec.whatwg.org/multipage/semantics.html#standard-metadata-names>
<https://ogp.me/>
-}
head : Metadata -> List (Head.Tag Pages.PathKey)
head metadata =
    case metadata of
        Metadata.Page meta ->
            Seo.summaryLarge
                { canonicalUrlOverride = Nothing
                , siteName = siteName
                , image =
                    { url = images.iconPng
                    , alt = "elm-pages logo"
                    , dimensions = Nothing
                    , mimeType = Nothing
                    }
                , description = siteTagline
                , locale = Nothing
                , title = meta.title
                }
                |> Seo.website

        Metadata.FrontPage meta ->
            Seo.summaryLarge
                { canonicalUrlOverride = Nothing
                , siteName = siteName
                , image =
                    { url = images.iconPng
                    , alt = "kodefant logo"
                    , dimensions = Nothing
                    , mimeType = Nothing
                    }
                , description = siteTagline
                , locale = Nothing
                , title = meta.title
                }
                |> Seo.website

        Metadata.Article meta ->
            Seo.summaryLarge
                { canonicalUrlOverride = Nothing
                , siteName = siteName
                , image =
                    { url = meta.image
                    , alt = meta.description
                    , dimensions = Nothing
                    , mimeType = Nothing
                    }
                , description = meta.description
                , locale = Nothing
                , title = meta.title
                }
                |> Seo.article
                    { tags = []
                    , section = Nothing
                    , publishedTime = Just (Date.toIsoString meta.published)
                    , modifiedTime = Nothing
                    , expirationTime = Nothing
                    }

        Metadata.Author meta ->
            let
                ( firstName, lastName ) =
                    case meta.name |> String.split " " of
                        [ first, last ] ->
                            ( first, last )

                        [ first, middle, last ] ->
                            ( first ++ " " ++ middle, last )

                        [] ->
                            ( "", "" )

                        _ ->
                            ( meta.name, "" )
            in
            Seo.summary
                { canonicalUrlOverride = Nothing
                , siteName = siteName
                , image =
                    { url = meta.avatar
                    , alt = meta.name
                    , dimensions = Nothing
                    , mimeType = Nothing
                    }
                , description = meta.bio
                , locale = Nothing
                , title = meta.name
                }
                |> Seo.profile
                    { firstName = firstName
                    , lastName = lastName
                    , username = Nothing
                    }

        Metadata.BlogIndex ->
            Seo.summaryLarge
                { canonicalUrlOverride = Nothing
                , siteName = siteName
                , image =
                    { url = images.iconPng
                    , alt = "elm-pages logo"
                    , dimensions = Nothing
                    , mimeType = Nothing
                    }
                , description = siteTagline
                , locale = Nothing
                , title = "elm-pages blog"
                }
                |> Seo.website


siteName : String
siteName =
    "kodeFant"


canonicalSiteUrl : String
canonicalSiteUrl =
    "https://kodefant.no/"


siteTagline : String
siteTagline =
    "Utvikler og historieforteller"
