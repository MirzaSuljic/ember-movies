import Component from '@glimmer/component';
import { service } from '@ember/service';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { LinkTo } from '@ember/routing';

export default class AppHeader extends Component {
  @service session;

  get email() {
    return this.session.data?.authenticated?.user_email;
  }

  @action
  logout() {
    // ember-simple-auth reloads the app after logout, which then shows the login
    this.session.invalidate();
  }

  <template>
    <header class="rr-page-header">
      <LinkTo @route="index" class="rr-header-link">
        <h1 class="rr-app-title">Movie List</h1>
      </LinkTo>
      {{#if this.session.isAuthenticated}}
        <div class="rr-user-panel">
          <span data-test-rr="user-email">{{this.email}}</span>
          <button type="button" class="rr-link-button" data-test-rr="logout" {{on "click" this.logout}}>
            Logout
          </button>
        </div>
      {{/if}}
    </header>
  </template>
}
