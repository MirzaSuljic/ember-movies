import { pageTitle } from 'ember-page-title';
import MovieList from '../../../components/movie-list';

<template>
  {{pageTitle "Movies"}}
  <MovieList @genre={{@model}} @controller={{@controller}} />
</template>
