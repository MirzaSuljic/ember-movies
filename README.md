# Movie List (ember-movies)

A small **Ember.js 7** app: log in, browse movie **genres**, read and edit a genre's description, and see its **movies** with search, sorting and **star ratings**. You can add genres and movies.
There is no backend – **Mirage** answers the API calls in the browser, so the app also works as a static site.

Rewritten from the older Ember 3.15 project `MovieEmber`.

**Demo login:** `test@test.com` / `test123` (already filled in on the login page)

## Tech

| Part | Technology |
|---|---|
| Framework | Ember.js 7.3 (Octane, `.gjs` template-tag components, Vite + Embroider) |
| Login | Ember Simple Auth 8 (OAuth2 password grant, protected routes) |
| Fake API | Mirage JS (`app/mirage/server.js`) with demo genres and movies |
| Tests | QUnit + Testem |

## Run

Requires Node.js 20.19 or newer.

```bash
npm install
npm start          # http://localhost:4200
```

On Windows, turn on **Developer Mode** (Settings → System → For developers) – Embroider creates symlinks.

## How it works

| URL | What you see |
|---|---|
| `/login` | login form (`LoginForm`) |
| `/genres` | genre list (`GenreSidebar`) – login required |
| `/genres/:id` | opens Details if the genre has a description, otherwise Movies |
| `/genres/:id/details` | description with Edit / Save (`GenreDetails`, asks before leaving unsaved changes) |
| `/genres/:id/movies?sort=titleAsc&s=star` | movies with search and sorting in the URL (`MovieList`, `StarRating`) |

- `app/router.js` – the URLs
- `app/routes/` – load data and protect routes (`session.requireAuthentication`)
- `app/controllers/genres/genre/movies.js` – `sort` and `s` query params
- `app/services/catalog.js` – genres and movies from `/api/...`, kept in tracked state
- `app/templates/**/*.gjs` – route templates, loading and error screens
- `app/components/` – `AppHeader`, `GenreSidebar`, `GenreDetails`, `MovieList`, `StarRating`, `LoginForm`, `Icon`
- `app/authenticators/oauth2.js`, `app/services/session.js`, `app/session-stores/application.js` – Ember Simple Auth
- `app/initializers/mirage.js` + `app/mirage/server.js` – the fake API

## Build, lint, test

```bash
npm run build      # production build in dist/
npm run lint
npm test
```
