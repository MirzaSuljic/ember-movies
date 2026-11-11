import { createServer, Model, belongsTo, hasMany, Response } from 'miragejs';

const USERS = [{ email: 'test@test.com', password: 'test123' }];

const GENRES = [
  {
    name: 'science fiction',
    description: 'Space, time and the future – films that ask "what if?".',
    movies: [
      ['Interstellar', 5],
      ['Blade Runner 2049', 5],
      ['Arrival', 4],
      ['The Martian', 4],
      ['Dune', 4],
    ],
  },
  {
    name: 'comedy',
    description: '',
    movies: [
      ['The Grand Budapest Hotel', 5],
      ['Superbad', 3],
      ['Groundhog Day', 4],
    ],
  },
  {
    name: 'drama',
    description: 'Stories about people, choices and consequences.',
    movies: [
      ['The Shawshank Redemption', 5],
      ['Whiplash', 4],
      ['Parasite', 5],
      ['Manchester by the Sea', 3],
    ],
  },
  {
    name: 'animation',
    description: '',
    movies: [
      ['Spirited Away', 5],
      ['Up', 4],
    ],
  },
];

/**
 * Fake API in the browser (no backend needed):
 *   POST  /token                     login (OAuth2 password grant) – test@test.com / test123
 *   GET   /api/genres                all genres
 *   POST  /api/genres                { genre: { name } }
 *   GET   /api/genres/:id            one genre
 *   PATCH /api/genres/:id            { genre: { description } }
 *   GET   /api/genres/:id/movies     movies of a genre
 *   POST  /api/movies                { movie: { title, rating, genreId } }
 *   PATCH /api/movies/:id            { movie: { rating } }
 * Data lives in memory: a reload starts again with the demo genres.
 */
export function makeServer({ environment = 'development' } = {}) {
  return createServer({
    environment,
    timing: 250,

    models: {
      genre: Model.extend({ movies: hasMany() }),
      movie: Model.extend({ genre: belongsTo() }),
    },

    seeds(server) {
      for (const { name, description, movies } of GENRES) {
        const genre = server.create('genre', { name, description });
        for (const [title, rating] of movies) {
          server.create('movie', { title, rating, genre });
        }
      }
    },

    routes() {
      this.post('/token', (schema, request) => {
        const params = new URLSearchParams(request.requestBody);
        const user = USERS.find(
          (u) => u.email === params.get('username') && u.password === params.get('password'),
        );
        if (user) {
          return { access_token: 'demo-token', token_type: 'bearer', user_email: user.email };
        }
        return new Response(
          400,
          {},
          { error: 'invalid_grant', error_description: 'Email or password is invalid' },
        );
      });

      this.namespace = 'api';
      this.get('/genres');
      this.post('/genres');
      this.get('/genres/:id');
      this.patch('/genres/:id');
      this.get('/genres/:id/movies', (schema, request) =>
        schema.movies.where({ genreId: request.params.id }),
      );
      this.post('/movies');
      this.patch('/movies/:id');

      // everything else (Vite, assets) goes to the real server
      this.namespace = '';
      this.passthrough();
    },
  });
}
