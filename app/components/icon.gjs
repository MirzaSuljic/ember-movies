// small inline icons (no icon library needed): plus, times, angle-right, search
const PATHS = {
  plus: 'M10 4v12M4 10h12',
  times: 'M5 5l10 10M15 5L5 15',
  'angle-right': 'M8 5l5 5-5 5',
  search: 'M9 15a6 6 0 1 0 0-12 6 6 0 0 0 0 12zM13.5 13.5L17 17',
};

const pathFor = (name) => PATHS[name];

<template>
  <svg class="rr-icon" viewBox="0 0 20 20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
    <path d={{pathFor @name}} />
  </svg>
</template>
