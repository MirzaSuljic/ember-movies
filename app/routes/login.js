import Route from '@ember/routing/route';
import { service } from '@ember/service';

// a logged in user who opens /login goes to the genres
export default class LoginRoute extends Route {
  @service session;

  beforeModel() {
    this.session.prohibitAuthentication('genres');
  }
}
