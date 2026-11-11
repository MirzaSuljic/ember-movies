import Route from '@ember/routing/route';
import { service } from '@ember/service';

export default class GenreMoviesRoute extends Route {
  @service catalog;

  async model() {
    const genre = this.modelFor('genres.genre');
    await this.catalog.loadMovies(genre.id);
    return genre;
  }
}
