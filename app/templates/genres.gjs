import { pageTitle } from 'ember-page-title';
import GenreSidebar from '../components/genre-sidebar';

<template>
  {{pageTitle "Genres"}}
  <div class="rr-layout">
    <GenreSidebar />
    <div class="rr-main-panel">
      {{outlet}}
    </div>
  </div>
</template>
