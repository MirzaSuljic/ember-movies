import { pageTitle } from 'ember-page-title';
import { LinkTo } from '@ember/routing';
import { capitalize } from '../../utils/capitalize';

<template>
  {{pageTitle (capitalize @model.name)}}
  <nav class="rr-navbar" aria-label="Genre">
    <ul class="rr-nav">
      <li class="rr-navbar-item" data-test-rr="details-nav-item"><LinkTo @route="genres.genre.details">Details</LinkTo></li>
      <li class="rr-navbar-item" data-test-rr="movies-nav-item"><LinkTo @route="genres.genre.movies">Movies</LinkTo></li>
    </ul>
  </nav>
  {{outlet}}
</template>
