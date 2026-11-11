import Route from '@ember/routing/route';
import { service } from '@ember/service';

export default class GenresRoute extends Route {
  @service session;
  @service catalog;

  beforeModel(transition) {
    // not logged in -> /login
    this.session.requireAuthentication(transition, 'login');
  }

  model() {
    return this.catalog.loadGenres();
  }
}
