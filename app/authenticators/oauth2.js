import OAuth2PasswordGrant from 'ember-simple-auth/authenticators/oauth2-password-grant';

// 'authenticator:oauth2': sends username + password to POST /token (answered by Mirage)
export default class OAuth2Authenticator extends OAuth2PasswordGrant {
  serverTokenEndpoint = '/token';
}
