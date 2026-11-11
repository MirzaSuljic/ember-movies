import EmberRouter from '@embroider/router';
import config from 'ember-movies/config/environment';

export default class Router extends EmberRouter {
  location = config.locationType;
  rootURL = config.rootURL;
}

Router.map(function () {
  this.route('login');
  // everything under /genres needs a login (see routes/genres.js)
  this.route('genres', function () {
    this.route('genre', { path: ':id' }, function () {
      this.route('details');
      this.route('movies');
    });
  });
});
