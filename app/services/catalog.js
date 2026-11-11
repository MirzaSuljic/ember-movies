import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';

/** A genre whose fields re-render the screen when they change. */
export class Genre {
  @tracked name;
  @tracked description;

  constructor({ id, name, description }) {
    this.id = String(id);
    this.name = name ?? '';
    this.description = description ?? '';
  }
}

/** A movie whose rating re-renders the stars when it changes. */
export class Movie {
  @tracked title;
  @tracked rating;

  constructor({ id, title, rating, genreId }) {
    this.id = String(id);
    this.title = title ?? '';
    this.rating = rating ?? 0;
    this.genreId = String(genreId);
  }
}

/**
 * Genres and movies from the API (/api/..., answered by Mirage).
 * Keeps them in tracked state, so lists update by themselves after adding or rating.
 */
export default class CatalogService extends Service {
  @tracked genres = [];
  @tracked moviesByGenre = {};

  async loadGenres() {
    const { genres } = await request('/genres');
    this.genres = genres.map((g) => new Genre(g));
    return this.genres;
  }

  async findGenre(id) {
    const known = this.genres.find((g) => g.id === String(id));
    if (known) return known;
    const { genre } = await request(`/genres/${id}`);
    return new Genre(genre);
  }

  async createGenre(name) {
    const { genre } = await request('/genres', { method: 'POST', body: { genre: { name, description: '' } } });
    const created = new Genre(genre);
    this.genres = [...this.genres, created];
    return created;
  }

  async saveDescription(genre, description) {
    await request(`/genres/${genre.id}`, { method: 'PATCH', body: { genre: { description } } });
    genre.description = description;
  }

  moviesFor(genreId) {
    return this.moviesByGenre[String(genreId)] ?? [];
  }

  async loadMovies(genreId) {
    const { movies } = await request(`/genres/${genreId}/movies`);
    this.moviesByGenre = { ...this.moviesByGenre, [String(genreId)]: movies.map((m) => new Movie(m)) };
  }

  async createMovie(genreId, title) {
    const { movie } = await request('/movies', {
      method: 'POST',
      body: { movie: { title, rating: 0, genreId: String(genreId) } },
    });
    const key = String(genreId);
    this.moviesByGenre = { ...this.moviesByGenre, [key]: [...this.moviesFor(key), new Movie(movie)] };
  }

  /** Clicking the current rating again lowers it by one (so 1 star can go back to 0). */
  async rateMovie(movie, rating) {
    const previous = movie.rating;
    movie.rating = previous === rating ? rating - 1 : rating;
    try {
      await request(`/movies/${movie.id}`, { method: 'PATCH', body: { movie: { rating: movie.rating } } });
    } catch (e) {
      movie.rating = previous;
      throw e;
    }
  }
}

async function request(path, { method = 'GET', body } = {}) {
  const response = await fetch(`/api${path}`, {
    method,
    headers: { Accept: 'application/json', 'Content-Type': 'application/json' },
    body: body ? JSON.stringify(body) : undefined,
  });
  if (!response.ok) {
    throw new Error(`${method} /api${path} failed (${response.status})`);
  }
  return response.status === 204 ? {} : response.json();
}
