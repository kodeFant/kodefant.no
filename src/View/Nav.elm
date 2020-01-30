module View.Nav exposing (logo, mobileMenu, navMenu)

import Design.Responsive exposing (responsiveFillScreen, responsiveView)
import Element
    exposing
        ( Element
        , alignRight
        , centerX
        , centerY
        , column
        , fill
        , height
        , link
        , moveDown
        , none
        , padding
        , paragraph
        , row
        , spacing
        , text
        , width
        )
import Element.Background as Background
import Element.Font as Font
import Element.Input exposing (button)
import Html.Attributes exposing (class)
import Pages
import Pages.Directory as Directory exposing (Directory)
import Pages.PagePath as PagePath exposing (PagePath)
import Palette
import Types exposing (Msg(..))


logo : Element msg
logo =
    Element.image [ Element.htmlAttribute (class "logo") ] { src = "/images/logo.svg", description = "" }


mobileMenu : Bool -> PagePath Pages.PathKey -> Element Msg
mobileMenu mobileMenuVisible currentPath =
    if mobileMenuVisible == True then
        responsiveFillScreen
            (column
                [ alignRight
                , Background.color Palette.color.darkestGray
                , padding 25
                , moveDown 5
                , width fill
                , height fill
                , Font.color Palette.color.white
                ]
                [ link [ centerX ] { label = logo, url = Pages.pages.index |> PagePath.toString }
                , column
                    [ centerX
                    , centerY
                    , spacing 40
                    , Font.size 48
                    ]
                    (navLinks currentPath)
                ]
            )

    else
        none


navLinks : PagePath Pages.PathKey -> List (Element msg)
navLinks currentPath =
    [ highlightableLink currentPath Pages.pages.about.directory "Om"
    , highlightableLink currentPath Pages.pages.blogg.directory "Blogg"
    ]


navMenu : PagePath Pages.PathKey -> Bool -> Element Msg
navMenu currentPath mobileMenuVisible =
    responsiveView
        { mobile = button [] { label = text "Meny", onPress = Just ToggleMobileMenu }
        , medium =
            row [ Element.spacing 32, Element.mouseOver [] ]
                (currentPath |> navLinks)
        , large =
            Element.row [ Element.spacing 32, Element.mouseOver [] ]
                (currentPath |> navLinks)
        }


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
            , centerX
            ]

         else
            [ Element.mouseOver [ Font.color Palette.color.lightGray ], centerX ]
        )
        { url = linkDirectory |> Directory.indexPath |> PagePath.toString
        , label = Element.text displayName
        }
