module Main exposing (main)

import MarkdownRenderer exposing (Rendered)
import Metadata exposing (Metadata)
import Pages
import Pages.Document
import Pages.Platform
import Types exposing (Model, Msg(..))
import Update exposing (update)
import View exposing (view)
import Webmanifest exposing (manifest)



-- the intellij-elm plugin doesn't support type aliases for Programs so we need to use this line
-- main : Platform.Program Pages.Platform.Flags (Pages.Platform.Model Model Msg Metadata Rendered) (Pages.Platform.Msg Msg Metadata Rendered)


canonicalSiteUrl : String
canonicalSiteUrl =
    "https://kodefant.no/"


main : Pages.Platform.Program Model Msg Metadata (Rendered Msg)
main =
    Pages.Platform.application
        { init = \_ -> init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , documents = [ markdownDocument ]
        , manifest = manifest
        , canonicalSiteUrl = canonicalSiteUrl
        , onPageChange = \_ -> ChangedPage
        , internals = Pages.internals
        }


markdownDocument : ( String, Pages.Document.DocumentHandler Metadata (Rendered Msg) )
markdownDocument =
    Pages.Document.parser
        { extension = "md"
        , metadata = Metadata.decoder
        , body =
            \markdownBody ->
                MarkdownRenderer.markdownView markdownBody
        }


init : ( Model, Cmd Msg )
init =
    ( { mobileMenuVisible = False }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
