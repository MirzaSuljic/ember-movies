import config from 'ember-movies/config/environment';
import { makeServer } from '../mirage/server';

// No real backend: Mirage answers /token and /api/* in every environment
// (also in production, so the built app works as a static site).
export function initialize() {
  if (!window.__mirage) {
    window.__mirage = makeServer({
      environment: config.environment === 'test' ? 'test' : 'development',
    });
  }
}

export default { initialize };
