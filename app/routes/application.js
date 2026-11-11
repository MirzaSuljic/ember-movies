import Route from '@ember/routing/route';
import { service } from '@ember/service';

export default class ApplicationRoute extends Route {
  @service session;

  async beforeModel() {
    // restores a saved login (required by ember-simple-auth)
    await this.session.setup();
  }
}
