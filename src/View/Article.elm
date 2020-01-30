module View.Article exposing (view)

import Data.Author as Author
import Element exposing (Element, el, paragraph, text)
import Element.Font as Font
import Element.Region
import Metadata exposing (ArticleMetadata, Metadata)
import Norwegian exposing (norwegianDate)
import Pages
import Pages.ImagePath as ImagePath exposing (ImagePath)
import Pages.PagePath exposing (PagePath)
import Palette
import Types exposing (Model, Msg)
import View.Header


view : Model -> Int -> ArticleMetadata -> { path : PagePath Pages.PathKey, frontmatter : Metadata } -> List (Element Msg) -> Element Msg
view model count metadata page viewForPage =
    Element.column [ Element.width Element.fill ]
        [ View.Header.view page.path model
        , Element.column
            [ Element.padding 30
            , Element.spacing 40
            , Element.Region.mainContent
            , Element.width (Element.fill |> Element.maximum 700)
            , Element.centerX
            ]
            [ Element.textColumn [ Element.spacing 24, Element.width Element.fill ]
                ([ Element.row [ Element.spacing 20 ]
                    [ Author.view [] metadata.author
                    , Element.column [ Element.spacing 10, Element.width Element.fill ]
                        [ Element.paragraph [ Font.bold, Font.size 24 ]
                            [ Element.text metadata.author.name
                            ]
                        , Element.paragraph [ Font.size 16 ]
                            [ Element.text metadata.author.bio ]
                        ]
                    ]
                 , publishedDateView metadata
                    |> Element.el
                        [ Font.size 16
                        , Font.color (Element.rgba255 0 0 0 0.6)
                        ]
                 , Palette.blogHeading metadata.title
                 , el [ Font.center ] (text (displayReadingLength count))
                 , articleImageView metadata.image
                 , paragraph [ Font.family [ Font.typeface "Merriweather", Font.sansSerif ], Font.size 24 ] [ text metadata.description ]
                 ]
                    ++ viewForPage
                )
            ]
        ]


publishedDateView : Metadata.ArticleMetadata -> Element msg
publishedDateView metadata =
    Element.text
        (norwegianDate
            metadata.published
        )


articleImageView : ImagePath Pages.PathKey -> Element msg
articleImageView articleImage =
    Element.image [ Element.width Element.fill ]
        { src = ImagePath.toString articleImage
        , description = "Article cover photo"
        }


displayReadingLength : Int -> String
displayReadingLength wordCount =
    let
        readingLength : Float
        readingLength =
            toFloat
                wordCount
                / 265.0
    in
    if readingLength < 1 then
        "Mindre enn ett minutt"

    else
        "Lesetid: ca. " ++ String.fromInt (round readingLength) ++ " minutter"
