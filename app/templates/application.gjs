import { pageTitle } from 'ember-page-title';
import AppHeader from '../components/app-header';

<template>
  {{pageTitle "Movie List"}}
  <div class="rr-container">
    <AppHeader />
    <main class="rr-main-content">
      {{outlet}}
    </main>
  </div>
</template>
