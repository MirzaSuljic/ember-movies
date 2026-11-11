<template>
  <div class="rr-empty-message" data-test-rr="genres-empty-message">
    {{if @model.length "Select a genre." "Let's start by creating a genre."}}
  </div>
</template>
