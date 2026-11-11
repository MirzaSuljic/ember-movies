import Route from '@ember/routing/route';
import { service } from '@ember/service';

// "/" opens the genres (or the login, if not logged in)
export default class IndexRoute extends Route {
  @service router;

  beforeModel() {
    this.router.transitionTo('genres');
  }
}
