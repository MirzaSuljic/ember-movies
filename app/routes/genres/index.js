import Route from '@ember/routing/route';

export default class GenresIndexRoute extends Route {
  model() {
    return this.modelFor('genres');
  }
}
