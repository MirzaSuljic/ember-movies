import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { service } from '@ember/service';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { LinkTo } from '@ember/routing';
import Icon from './icon';
import { capitalize } from '../utils/capitalize';

export default class GenreSidebar extends Component {
  @service catalog;
  @service router;

  @tracked isAddingGenre = false;
  @tracked newGenreName = '';

  get isAddButtonDisabled() {
    return this.newGenreName.trim() === '';
  }

  @action startAdding() {
    this.isAddingGenre = true;
  }

  @action cancelAdding() {
    this.isAddingGenre = false;
    this.newGenreName = '';
  }

  @action updateName(event) {
    this.newGenreName = event.target.value;
  }

  @action
  async saveGenre(event) {
    event.preventDefault();
    const genre = await this.catalog.createGenre(this.newGenreName.trim());
    this.cancelAdding();
    this.router.transitionTo('genres.genre.movies', genre.id);
  }

  <template>
    <aside class="rr-sidebar">
      <ul class="rr-list">
        {{#each this.catalog.genres as |genre|}}
          <li class="rr-list-item" data-test-rr="genre-list-item">
            <LinkTo @route="genres.genre" @model={{genre.id}} class="rr-genre-link" data-test-rr="genre-link">
              {{capitalize genre.name}}
              <span class="rr-pointer"><Icon @name="angle-right" /></span>
            </LinkTo>
          </li>
        {{/each}}
      </ul>

      <div class="rr-new-label">
        {{#if this.isAddingGenre}}
          <form class="rr-inline-form" {{on "submit" this.saveGenre}}>
            <input
              type="text"
              class="rr-input"
              placeholder="New genre"
              aria-label="New genre"
              data-test-rr="new-genre-input"
              value={{this.newGenreName}}
              {{on "input" this.updateName}}
            />
            <button type="submit" class="rr-action-button" disabled={{this.isAddButtonDisabled}} data-test-rr="new-genre-button">Add</button>
            <button type="button" class="rr-cancel-icon" aria-label="Cancel" {{on "click" this.cancelAdding}}><Icon @name="times" /></button>
          </form>
        {{else}}
          <button type="button" class="rr-add-link" data-test-rr="new-genre-label" {{on "click" this.startAdding}}>
            <Icon @name="plus" />
            <span>Add new genre</span>
          </button>
        {{/if}}
      </div>
    </aside>
  </template>
}
