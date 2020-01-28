---
{
  "type": "blogg",
  "author": Lars Lillo Ulvestad,
  "title": Kom i gang med CSS-moduler i React,
  "description": Nå har det endelig blitt enkelt å bruke CSS-moduler i Create React App.,
  "image": "/images/article-covers/react-banner.jpg",
  "published": "2018-10-22",
}
---

**Merk:** _Dette er teknisk stoff rettet mot viderekomne utviklere og inneholder intern sjargong. Jeg skal på sikt merke tydeligere hva som er laget for utviklere og hva som er laget for ikke-tekniske nettside-redaktører._

**Forutsetninger:**

- _Du bør ha litt kjennskap med CSS, React og terminal-grensesnitt, men du trenger ikke ha brukt React mye._
- _Du må ha [node.js og npm ferdig installert](https://nodejs.org) på maskina di._

CSS modules, heretter kalt "CSS-moduler", er nå bygget inn i versjon 2 av [Create React App](https://reactjs.org/docs/create-a-new-react-app.html).

Create React App er et nyttig verktøy for React-utviklere, spesielt for nybegynnere i React. Det gir deg en ferdigpakke med React, Webpack og moderne JavaScript så du slipper å konfigurere alt dette fra scratch.

CSS-moduler har vært en populær måte å håndtere CSS i React på, men Create React App har ikke hatt CSS-moduler inkludert før nå. En har derfor måttet kjøre ["eject"-kommandoen](https://github.com/facebook/create-react-app/blob/master/packages/react-scripts/template/README.md#npm-run-eject) for å kunne legge inn denne funksjonaliteten manuelt.

Eject åpner opp for mer valgfrihet, men ulempen er at en må vedlikeholde prosjektet videre på egen hånd, uten oppdateringer fra Create React App-teamet.

[kode24.no](https://www.kode24.no/kodenytt/dette-er-nytt-i-create-react-app-2/70282993) har en oversikt på norsk over øvrige nyheter i Create React App 2.

## Hvorfor CSS-moduler?

Normalt har nettsider såkalte "globale" CSS-stilark. Har en ikke tunga rett i munnen, kan en css-klasse føre til utilsiktede konsekvenser for andre elementer. Dette merker man først når stilarket etterhvert vokser seg stort og komplekst. Knapper i et mailskjema kan for eksempel komme i konflikt med en deleknapp for sosiale medier. En vanlig måte å løse dette på er litt tungvindte navnekonvensjoner på CSS-klasser som [BEM](https://css-tricks.com/bem-101/).

CSS-moduler lar deg opprette **lokale CSS-regler** som kun angår den konkrete komponenten og lar alt annet på siden være i fred. Du trenger ikke bekymre deg over å lage unike navn i henhold til en navnekonvensjoner med CSS-moduler. Innstikket vil automatisk generere en unik klasse til komponenten.

Du kan fortsatt drive gjenbruk av samme kode flere steder, for eksempel med "composes".

## Et minimum-eksempel

Jeg foretrekker å vise kun det absolutte minimum som trengs for å komme i gang med CSS-moduler. Når du behersker dette, kan du fordype deg i mer avanserte konsepter selv.

Alt vi gjør i dette eksempelet er å endre den blå "Learn-react"-lenken til kodeFant-oransje (egentlig bare standard "orange") med en CSS-modul.

![Skjermdump](/images/blog-img/react-demo.gif)

_Målet med oppgaven er så enkel som å endre farge på en spesifikk lenke._

### 1. Opprett ny Create React-App

Først starter vi et nytt prosjekt via Create React App for å teste CSS-moduler i trygge omgivelser.

Naviger deg inn i mappen du vil opprette prosjektet via terminalen. Opprett deretter et ny React-app:

```bash
npx create-react-app css-modules-playground
cd css-modules-playground
npm start
```

Du skal kunne se alle endringene du gjør uten å oppdatere via [http://localhost:3000/](http://localhost:3000/).

### 2. Opprett CSS-modul

Du kan nå åpne prosjektmappen i din foretrukne kode-editor.

Vi oppretter en css-modul til App.js ved å opprette en fil som heter **App.module.css** i mappen som heter **src** i prosjektmappen.

Denne bash-kommandoen gjør jobben for deg:

```bash
touch src/App.module.css
```

Fyll **App.module.css** med ønsket CSS:

```css
// App.module.css

.kodefant_link {
  color: orange;
  text-decoration: underline dotted orange;
}

.kodefant_link:hover {
  color: #dd9000;
  text-decoration: underline solid #dd9000;
}
```

### 3. Knytt CSS-modulen til React-komponent

Når du har lagret endringene i **App.module.css**, kan du nå åpne **App.js** og legge til følgende import-forespørsel.

```js
import styles from "./App.module.css";
```

Nå kan du hente inn en lokal stilark-klasse fra **styles**. `kodefant_link` henter du dermed inn ved å skrive `styles.kodefant_link`

Finn deretter **Learn React**-lenken som nå har en CSS-klasse som heter "App-link"

Erstatt

```jsx
className = "App-link";
```

med følgende:

```jsx
className={styles.kodefant_link}
```

Det skal da se slik ut:

```jsx
import React, { Component } from "react";
import logo from "./logo.svg";
import "./App.css";
import styles from "./App.module.css";

class App extends Component {
  render() {
    return (
      <div className="App">
        <header className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <p>
            Edit <code>src/App.js</code> and save to reload.
          </p>
          <a
            className={styles.kodefant_link}
            href="https://reactjs.org"
            target="_blank"
            rel="noopener noreferrer"
          >
            Learn React
          </a>
        </header>
      </div>
    );
  }
}

export default App;
```

Sjekker du nå [http://localhost:3000/](http://localhost:3000/), skal Learn React-knappen være endret fra blå til oransje.

Går du inn i Developer Tools og inspiserer lenken, ser du at den har fått en autogenerert CSS-klasse basert på klassen du definerte.

![Skjermbilde av Developer Tools](/images/blog-img/skjermdump-developer-tools.png)

## Øvingsoppgave

**Her er en kjapp øvingsoppgave du kan bruke til å venne deg til CSS-moduler i React:**

- Klipp ut alle css-klassene fra **App.css** og lim inn i **App.module.css**. Fjern deretter linjen **import "./App.css";** fra **App.js**.
- Få deretter appen til å se normal ut igjen ved å erstatte de vanlige klassene med dynamiske css-modul-klasser.
- Inspiser elementene for å bekrefte at de har blitt tildelt automatisk genererte klasser.

Når du føler deg fortrolig med dette, kan du prøve å implementere det i noen av dine egne prosjekter. Du kan også sette deg inn i [øvrige funksjoner i CSS Modules](https://github.com/css-modules/css-modules).
