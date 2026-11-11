import Route from '@ember/routing/route';

export default class GenreDetailsRoute extends Route {
  model() {
    return this.modelFor('genres.genre');
  }
}
