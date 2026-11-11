import { on } from '@ember/modifier';
import { fn } from '@ember/helper';

const STAR = 'M10 1.8l2.5 5.2 5.7.8-4.1 4 1 5.6L10 14.7l-5.1 2.7 1-5.6-4.1-4 5.7-.8z';

/** [{ rating: 1, isFull: true }, …] for maxRating stars */
const starsFor = (rating = 0, maxRating = 5) =>
  Array.from({ length: maxRating }, (_, i) => ({ rating: i + 1, isFull: rating >= i + 1 }));

/**
 * <StarRating @rating={{3}} @onClick={{this.rate}} />
 * Clicking a star calls @onClick with that star's number.
 */
<template>
  <span class="rr-rating-panel" ...attributes>
    {{#each (starsFor @rating @maxRating) as |star|}}
      <button
        type="button"
        class="rr-star {{if star.isFull 'is-full'}}"
        aria-label="Rate {{star.rating}} of 5"
        data-test-rr="star-rating-{{star.rating}}"
        {{on "click" (fn @onClick star.rating)}}
      >
        <svg viewBox="0 0 20 20" aria-hidden="true"><path d={{STAR}} /></svg>
      </button>
    {{/each}}
  </span>
</template>
