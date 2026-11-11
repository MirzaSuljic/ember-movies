import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { service } from '@ember/service';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';

export default class LoginForm extends Component {
  @service session;
  @service router;

  // demo account, filled in for convenience
  @tracked email = 'test@test.com';
  @tracked password = 'test123';
  @tracked errorMessage = null;

  @action
  update(field, event) {
    this[field] = event.target.value;
  }

  @action
  async signIn(event) {
    event.preventDefault();
    this.errorMessage = null;
    try {
      // app/authenticators/oauth2.js -> POST /token
      await this.session.authenticate('authenticator:oauth2', this.email, this.password);
      this.router.transitionTo('genres');
    } catch (error) {
      const body = error?.responseJSON ?? {};
      this.errorMessage = body.error_description ?? 'Email or password is invalid';
    }
  }

  <template>
    <div class="rr-form-container">
      <h2 class="rr-form-title" data-test-rr="form-header">Log in to Movie List</h2>

      {{#if this.errorMessage}}
        <p class="rr-error-message" role="alert">{{this.errorMessage}}</p>
      {{/if}}

      <form {{on "submit" this.signIn}}>
        <div class="rr-form-inline-row">
          <label for="email">Email</label>
          <input id="email" type="email" class="rr-input" autocomplete="username" value={{this.email}} {{on "input" (fn this.update "email")}} />
        </div>
        <div class="rr-form-inline-row">
          <label for="password">Password</label>
          <input id="password" type="password" class="rr-input" autocomplete="current-password" value={{this.password}} {{on "input" (fn this.update "password")}} />
        </div>
        <div class="rr-button-panel">
          <button type="submit" class="rr-action-button" data-test-rr="login-button">Sign in</button>
        </div>
      </form>
      <p class="rr-muted rr-center">Demo account: test@test.com / test123</p>
    </div>
  </template>
}
