module BlogIndex exposing (view)

import Data.Author
import Date
import Element exposing (Element, moveUp)
import Element.Border
import Element.Font
import Metadata exposing (Metadata(..))
import Norwegian exposing (norwegianDate)
import Pages
import Pages.PagePath as PagePath exposing (PagePath)


view :
    List ( PagePath Pages.PathKey, Metadata )
    -> Element msg
view posts =
    let
        filteredPosts : List (Element msg)
        filteredPosts =
            posts
                |> List.filterMap
                    (\( path, metadata ) ->
                        case metadata of
                            Metadata.Page _ ->
                                Nothing

                            Metadata.FrontPage _ ->
                                Nothing

                            Metadata.Author _ ->
                                Nothing

                            Metadata.Article meta ->
                                if meta.draft then
                                    Nothing

                                else
                                    Just ( path, meta )

                            Metadata.BlogIndex ->
                                Nothing
                    )
                |> List.sortWith
                    (\( _, metaA ) ( _, metaB ) -> Date.compare metaA.published metaB.published)
                |> List.reverse
                |> List.map postSummary
    in
    Element.column [ Element.spacing 20 ]
        filteredPosts


postSummary :
    ( PagePath Pages.PathKey, Metadata.ArticleMetadata )
    -> Element msg
postSummary ( postPath, post ) =
    articleIndex post
        |> linkToPost postPath


linkToPost : PagePath Pages.PathKey -> Element msg -> Element msg
linkToPost postPath content =
    Element.link [ Element.width Element.fill ]
        { url = PagePath.toString postPath, label = content }


title : String -> Element msg
title text =
    [ Element.text text ]
        |> Element.paragraph
            [ Element.Font.size 36
            , Element.Font.center
            , Element.Font.family [ Element.Font.typeface "Raleway" ]
            , Element.Font.semiBold
            , Element.padding 16
            ]


articleIndex : Metadata.ArticleMetadata -> Element msg
articleIndex metadata =
    Element.el
        [ Element.centerX
        , Element.width (Element.maximum 800 Element.fill)
        , Element.padding 40
        , Element.spacing 10
        , Element.Border.width 1
        , Element.Border.color (Element.rgba255 0 0 0 0.1)
        , Element.mouseOver
            [ Element.Border.color (Element.rgba255 0 0 0 1)
            , moveUp 10
            ]
        ]
        (postPreview metadata)


readMoreLink : Element msg
readMoreLink =
    Element.text "Les mer >>"
        |> Element.el
            [ Element.centerX
            , Element.Font.size 18
            , Element.alpha 0.6
            , Element.mouseOver [ Element.alpha 1 ]
            , Element.Font.underline
            , Element.Font.center
            ]


postPreview : Metadata.ArticleMetadata -> Element msg
postPreview post =
    Element.textColumn
        [ Element.centerX
        , Element.width Element.fill
        , Element.spacing 30
        , Element.Font.size 18
        ]
        [ title post.title
        , Element.row [ Element.spacing 10, Element.centerX ]
            [ Data.Author.view [ Element.width (Element.px 40) ] post.author
            , Element.text post.author.name
            , Element.text "•"
            , Element.text (post.published |> norwegianDate)
            ]
        , post.description
            |> Element.text
            |> List.singleton
            |> Element.paragraph
                [ Element.Font.size 22
                , Element.Font.center
                , Element.Font.family [ Element.Font.typeface "Raleway" ]
                ]
        , readMoreLink
        ]
