import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { service } from '@ember/service';
import { action } from '@ember/object';
import { on } from '@ember/modifier';

/**
 * The genre's description with Edit / Save.
 * Leaving the page while editing asks for confirmation.
 */
export default class GenreDetails extends Component {
  @service catalog;
  @service router;

  @tracked isEditing = false;
  @tracked draft = '';

  constructor(owner, args) {
    super(owner, args);
    this.router.on('routeWillChange', this.confirmLeave);
  }

  willDestroy() {
    super.willDestroy();
    this.router.off('routeWillChange', this.confirmLeave);
  }

  @action
  confirmLeave(transition) {
    // query param changes and staying on this page are fine
    if (!this.isEditing || transition.to?.name === 'genres.genre.details') {
      return;
    }
    if (!window.confirm('You have unsaved changes. Leave anyway?')) {
      transition.abort();
    } else {
      this.isEditing = false;
    }
  }

  @action edit() {
    this.draft = this.args.genre.description;
    this.isEditing = true;
  }

  @action updateDraft(event) {
    this.draft = event.target.value;
  }

  @action
  async save() {
    await this.catalog.saveDescription(this.args.genre, this.draft.trim());
    this.isEditing = false;
  }

  <template>
    <section class="rr-panel">
      <div class="rr-panel-header">
        <h3>Description</h3>
        {{#if this.isEditing}}
          <button type="button" class="rr-action-button" data-test-rr="save-description" {{on "click" this.save}}>Save</button>
        {{else}}
          <button type="button" class="rr-action-button" data-test-rr="edit-description" {{on "click" this.edit}}>Edit</button>
        {{/if}}
      </div>

      {{#if this.isEditing}}
        <textarea class="rr-textarea" rows="5" aria-label="Description" value={{this.draft}} {{on "input" this.updateDraft}}></textarea>
      {{else if @genre.description}}
        <p>{{@genre.description}}</p>
      {{else}}
        <p class="rr-muted">No description yet.</p>
      {{/if}}
    </section>
  </template>
}
