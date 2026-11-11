import Route from '@ember/routing/route';
import { service } from '@ember/service';

// /genres/1 opens Details when the genre has a description, otherwise Movies
export default class GenreIndexRoute extends Route {
  @service router;

  beforeModel() {
    const genre = this.modelFor('genres.genre');
    this.router.transitionTo(genre.description ? 'genres.genre.details' : 'genres.genre.movies');
  }
}
