import Route from '@ember/routing/route';
import { service } from '@ember/service';

export default class GenreRoute extends Route {
  @service catalog;

  model({ id }) {
    return this.catalog.findGenre(id);
  }
}
