import AdaptiveStore from 'ember-simple-auth/session-stores/adaptive';

// keeps the login in localStorage (falls back to a cookie)
export default class SessionStore extends AdaptiveStore {}
