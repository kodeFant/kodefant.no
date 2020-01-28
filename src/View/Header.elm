module View.Header exposing (view)

import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Region
import Html.Attributes exposing (class)
import Pages
import Pages.Directory as Directory exposing (Directory)
import Pages.ImagePath as ImagePath
import Pages.PagePath as PagePath exposing (PagePath)
import Palette


view : PagePath Pages.PathKey -> Element msg
view currentPath =
    Element.column [ Element.width Element.fill ]
        [ Element.row
            [ Element.paddingXY 25 4
            , Element.spaceEvenly
            , Element.width Element.fill
            , Element.Region.navigation
            , Border.widthEach { bottom = 1, left = 0, right = 0, top = 0 }
            , Border.color (Element.rgba255 40 80 40 0.4)
            , Background.color Palette.color.darkestGray
            , Font.color Palette.color.white
            , Element.paddingXY 48 16
            ]
            [ Element.link
                [ Font.color Palette.color.primary
                , Element.mouseOver [ Font.color Palette.color.white ]
                ]
                { url = "/"
                , label =
                    Element.row [ Font.size 30, Element.spacing 16 ]
                        [ Element.image [ Element.htmlAttribute (class "logo") ] { src = "/images/logo.svg", description = "" }
                        ]
                }
            , Element.row [ Element.spacing 32, Element.mouseOver [] ]
                [ twitterLink
                , highlightableLink currentPath Pages.pages.about.directory "Om"
                , highlightableLink currentPath Pages.pages.blogg.directory "Blogg"
                ]
            ]
        , Element.el
            [ Element.height (Element.px 4)
            , Element.width Element.fill
            , Background.gradient
                { angle = 0.2
                , steps =
                    [ Palette.color.darkestGray
                    , Palette.color.primary
                    ]
                }
            ]
            Element.none
        ]


highlightableLink :
    PagePath Pages.PathKey
    -> Directory Pages.PathKey Directory.WithIndex
    -> String
    -> Element msg
highlightableLink currentPath linkDirectory displayName =
    let
        isHighlighted =
            currentPath |> Directory.includes linkDirectory
    in
    Element.link
        (if isHighlighted then
            [ Font.color Palette.color.primary
            , Element.mouseOver [ Font.color Palette.color.lightGray ]
            ]

         else
            [ Element.mouseOver [ Font.color Palette.color.lightGray ] ]
        )
        { url = linkDirectory |> Directory.indexPath |> PagePath.toString
        , label = Element.text displayName
        }


twitterLink : Element msg
twitterLink =
    Element.newTabLink []
        { url = "https://twitter.com/larsparsfromage"
        , label =
            Element.image
                [ Element.width (Element.px 22)
                ]
                { src = ImagePath.toString Pages.images.twitter, description = "@larsparsfromage på twitter" }
        }
