---
{
  "type": "blogg",
  "author": Lars Lillo Ulvestad,
  "title": Slik laster du ned Internet Explorer på Mac,
  "description": Microsoft har lenge anbefalt å bytte ut Internet Explorer. Én av ti norske nettbrukere bruker den likevel.,
  "image": "/images/article-covers/ie.jpg",
  "published": "2018-10-15",
}
---

Har du opplevd at noe ikke har fungert i Internet Explorer, men funket fint i en nettleser som Chrome?

Nettleseren Internet Explorer er en hodepine for både utviklere og brukere av nettleseren. Flere nettsteder velger å ikke støtte selv den siste versjonen nettleseren.

Selv om nettsida di ser fin ut i Chrome kan den se ødelagt ut i Internet Explorer. Det er fordi denne utdaterte nettleseren ikke støtter de mer moderne funksjonene internett ny byr på.

[Microsoft selv anbefaler](https://support.microsoft.com/en-us/help/17454/lifecycle-faq-internet-explorer) å slutte med Internet Explorer og heller bruke deres nye nettleser Edge.

Hvis du bruker Internet Explorer når du leser dette, er det en fin anledning for å laste ned [Google Chrome](https://www.google.com/chrome/) eller [Firefox](https://www.mozilla.org/nb-NO/firefox/new/) med én gang.

## Hver tiende norske nettbruker bruker Microsofts utdaterte nettleser

Cirka [ti prosent av norske nettlesere](http://gs.statcounter.com/browser-market-share/all/norway) (per september 2018) bruker fortsatt Internet Explorer. Det er langt over verdensgjennomsnittet. På [verdensbasis](http://gs.statcounter.com/) er andelen bare på 2,87 prosent.

**TODO: Putt Graf Inn Her**

Oppgradering av programvare i store organisasjoner koster. Det kan være lett å holde ved det gamle som fungerer. Et gammelt intranett kan for eksempel være en grunn til å beholde Internet Explorer.

Det må likevel være en stor uting å tviholde på denne nettleseren som ikke støtter de moderne nettleserfunksjoner og gjør det dyrere å lage nettsider.

## Ikke hold Internet Explorer kunstig i live

**Internet Explorer er best egnet til er å laste ned andre nettlesere, slik at du ikke trenger å bruke Internet Explorer mer.**

Jo færre nettsteder som støtter Internet Explorer, jo flere vil forstå at det er på tide å forlate denne utdaterte programvaren, som for eksempel [denne Medium-artikkelen](https://medium.com/@burger.neal/the-end-of-life-of-internet-explorer-11-12736f9ff75f) påpeker.

Likevel må man være realistisk og innse at en ikke alltid har innflytelse over slike valg der en jobber. Da må en bruke tida det tar for å teste for Internet Explorer.

## Hvordan teste uten Windows-maskin

Administrerer du en nettside via Mac eller Linux, er det ikke alltid gitt at Internet Explorer viser det samme som den moderne nettleseren du bruker nå. Men det finnes noen alternative måter for å teste nettsida di opp mot Internet Explorer på Mac eller Linux.

### Microsoft Edge via Chrome eller Firefox

Om du bare trenger å teste nettsiden din opp mot Edge, finnes det en gratisløsning som bare krever en Chrome-utvidelse.

Microsoft tilbyr deg å teste nettsiden din opp mot Edge i skyen gjennom tjenesten [BrowserStack](https://www.browserstack.com/test-on-microsoft-edge-browser). Dette er egentlig en betalt tjeneste som lar deg teste siden din opp mot alle mulige nettlesere, men for Edge er det gratis.

BrowserStack tester også Internet Explorer, men mot at du betaler dem for deres tjenester. Disse betalte tjenestene gir kanskje mest mening for større digitale byråer som vil teste opp mot de fleste tilgjengelige nettlesere. Merk at det også finnes alternativer til BrowserStack som du finner med et kjapt google-søk.

![Skjermdump av kodefant.no som blir testet med Microsofts nye nettleser Edge.](/images/blog-img/ie-screenshot.png)
"kodefant.no blir her testet for Microsoft Edge med BrowserStack via Google Chrome. Dette blir testet mot en virkelig Windows-maskin og må derfor kunne sies å være veldig presis."

### Test Internet Explorer gratis på Mac eller Linux

Microsoft har også en gratisløsning for å teste Internet Explorer.

Dette alternativet krever at du laster ned programvare for virtuelle maskiner, for eksempel VirtualBox. Du setter da opp virtuell maskin inni Mac- eller Linux-systemet ditt som kan kjøre Windows og Internet Explorer.

Du trenger ikke være et teknisk geni for å få det til, men det er en stor fordel om du er litt teknisk kyndig. Du bør i det minste være villig til å gjøre deg litt kjent med VirtualBox, og søke litt på nett for eventuell feilsøking.

Fremgangsmåten er forholdsvis enkel:

- **Last først ned og installer siste versjon av [VirtualBox](https://www.virtualbox.org/) **
- **Last deretter ned [en virtuell maskin for Internet Explorer](https://developer.microsoft.com/en-us/microsoft-edge/tools/vms/) via Microsoft (stor fil!).**
- **Du skal kunne dobbeltklikke på fila som inneholder den virtuelle maskinen. Følg deretter instruksjonene. Har du lite minne, kan du redusere tillat bruk av "Base Memory" til 1024 så det ikke sakker ned maskina di for mye. Ellers kan du klikke deg videre.**

![Skjermdump av menyen til det grafiske brukergrensesnittet til VirtualBox.](/images/blog-img/ie-screenshot2.png)

Med Virtualbox kan du trykke på start for å starte en virtuell Windows-maskin som kjører inne i din Mac eller Linux-maskin.

Som regel trenger du aldri bry deg med å teste eldre nettlesere enn Internet Explorer 11. De er utdaterte og har ingen sikkerhetsstøtte fra Microsoft. Du kan derfor trygt regne dem som døde nettlesere.

Lykke til!
