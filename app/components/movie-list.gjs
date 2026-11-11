import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { service } from '@ember/service';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { fn, hash } from '@ember/helper';
import { LinkTo } from '@ember/routing';
import Icon from './icon';
import StarRating from './star-rating';
import { capitalize } from '../utils/capitalize';

const SORTS = {
  ratingDesc: (a, b) => b.rating - a.rating || a.title.localeCompare(b.title),
  ratingAsc: (a, b) => a.rating - b.rating || a.title.localeCompare(b.title),
  titleDesc: (a, b) => b.title.localeCompare(a.title),
  titleAsc: (a, b) => a.title.localeCompare(b.title),
};

const SORT_LINKS = [
  { key: 'ratingDesc', label: 'Rating ↓', test: 'sort-by-rating-desc' },
  { key: 'ratingAsc', label: 'Rating ↑', test: 'sort-by-rating-asc' },
  { key: 'titleAsc', label: 'Title A–Z', test: 'sort-by-title-asc' },
  { key: 'titleDesc', label: 'Title Z–A', test: 'sort-by-title-desc' },
];

/**
 * Movies of @genre with search, sorting (both in the URL through @controller),
 * star ratings and a form to add a movie.
 */
export default class MovieList extends Component {
  @service catalog;

  @tracked isAddingMovie = false;
  @tracked newMovieTitle = '';

  sortLinks = SORT_LINKS;

  get movies() {
    return this.catalog.moviesFor(this.args.genre.id);
  }

  get sortedMovies() {
    const term = (this.args.controller.searchTerm ?? '').toLowerCase();
    const compare = SORTS[this.args.controller.sortBy] ?? SORTS.ratingDesc;
    return this.movies.filter((m) => m.title.toLowerCase().includes(term)).sort(compare);
  }

  get newMoviePlaceholder() {
    return `New ${capitalize(this.args.genre.name)} movie`;
  }

  get isAddButtonDisabled() {
    return this.newMovieTitle.trim() === '';
  }

  @action updateSearch(event) {
    this.args.controller.searchTerm = event.target.value;
  }

  @action startAdding(event) {
    event?.preventDefault();
    this.isAddingMovie = true;
  }

  @action cancelAdding() {
    this.isAddingMovie = false;
    this.newMovieTitle = '';
  }

  @action updateTitle(event) {
    this.newMovieTitle = event.target.value;
  }

  @action
  async saveMovie(event) {
    event.preventDefault();
    await this.catalog.createMovie(this.args.genre.id, this.newMovieTitle.trim());
    this.newMovieTitle = '';
  }

  @action rate(movie, rating) {
    this.catalog.rateMovie(movie, rating);
  }

  <template>
    <div class="rr-controls-panel">
      <div class="rr-sort-panel" role="group" aria-label="Sort movies">
        {{#each this.sortLinks as |sort|}}
          <LinkTo @query={{hash sortBy=sort.key}} class="rr-sort-button" data-test-rr={{sort.test}}>{{sort.label}}</LinkTo>
        {{/each}}
      </div>
      <label class="rr-search-panel">
        <Icon @name="search" />
        <input
          type="search"
          class="rr-input"
          placeholder="Search"
          aria-label="Search movies"
          data-test-rr="search-box"
          value={{@controller.searchTerm}}
          {{on "input" this.updateSearch}}
        />
      </label>
    </div>

    <ul class="rr-list">
      {{#each this.sortedMovies as |movie|}}
        <li class="rr-list-item rr-movie" data-test-rr="movie-list-item">
          <span>{{capitalize movie.title}}</span>
          <StarRating @rating={{movie.rating}} @onClick={{fn this.rate movie}} />
        </li>
      {{else}}
        <li class="rr-empty-message">
          {{#if @controller.searchTerm}}
            No movies match "{{@controller.searchTerm}}".
          {{else}}
            No {{capitalize @genre.name}} movies yet, why don't you
            <button type="button" class="rr-link-button" {{on "click" this.startAdding}}>create one?</button>
          {{/if}}
        </li>
      {{/each}}
    </ul>

    <div class="rr-new-label">
      {{#if this.isAddingMovie}}
        <form class="rr-inline-form" data-test-rr="new-movie-form" {{on "submit" this.saveMovie}}>
          <input
            type="text"
            class="rr-input"
            placeholder={{this.newMoviePlaceholder}}
            aria-label={{this.newMoviePlaceholder}}
            data-test-rr="new-movie-input"
            value={{this.newMovieTitle}}
            {{on "input" this.updateTitle}}
          />
          <button type="submit" class="rr-action-button" disabled={{this.isAddButtonDisabled}} data-test-rr="new-movie-button">Add</button>
          <button type="button" class="rr-cancel-icon" aria-label="Cancel" {{on "click" this.cancelAdding}}><Icon @name="times" /></button>
        </form>
      {{else}}
        <button type="button" class="rr-add-link" data-test-rr="new-movie-label" {{on "click" this.startAdding}}>
          <Icon @name="plus" />
          <span>Add new movie</span>
        </button>
      {{/if}}
    </div>
  </template>
}
