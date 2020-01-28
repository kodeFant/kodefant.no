module Norwegian exposing (norwegianDate)

import Date exposing (Date, Language, Month, Weekday, formatWithLanguage)
import Time exposing (Month(..), Weekday(..))


norwegianDate : Date -> String
norwegianDate date =
    formatWithLanguage norwegian "ddd MMMM y" date


norwegian : Language
norwegian =
    { monthName = monthName
    , monthNameShort = monthNameShort
    , weekdayName = weekdayName
    , weekdayNameShort = weekdayNameShort
    , dayWithSuffix = dayWithSuffix
    }


monthName : Month -> String
monthName month =
    case month of
        Jan ->
            "januar"

        Feb ->
            "februar"

        Mar ->
            "mars"

        Apr ->
            "april"

        May ->
            "mai"

        Jun ->
            "juni"

        Jul ->
            "juli"

        Aug ->
            "august"

        Sep ->
            "september"

        Oct ->
            "oktober"

        Nov ->
            "november"

        Dec ->
            "desember"


monthNameShort : Month -> String
monthNameShort month =
    case month of
        Jan ->
            "jan"

        Feb ->
            "feb"

        Mar ->
            "mar"

        Apr ->
            "apr"

        May ->
            "mai"

        Jun ->
            "jun"

        Jul ->
            "jul"

        Aug ->
            "aug"

        Sep ->
            "sep"

        Oct ->
            "okt"

        Nov ->
            "nov"

        Dec ->
            "des"


weekdayName : Weekday -> String
weekdayName weekday =
    case weekday of
        Mon ->
            "mandag"

        Tue ->
            "tirsdag"

        Wed ->
            "onsdag"

        Thu ->
            "torsdag"

        Fri ->
            "fredag"

        Sat ->
            "lørdag"

        Sun ->
            "søndag"


weekdayNameShort : Weekday -> String
weekdayNameShort weekday =
    case weekday of
        Mon ->
            "man"

        Tue ->
            "tir"

        Wed ->
            "ons"

        Thu ->
            "tor"

        Fri ->
            "fre"

        Sat ->
            "lør"

        Sun ->
            "søn"


dayWithSuffix : Int -> String
dayWithSuffix day =
    String.fromInt day ++ "."
