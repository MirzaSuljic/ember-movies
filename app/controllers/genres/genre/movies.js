import Controller from '@ember/controller';
import { tracked } from '@glimmer/tracking';

// sort and search live in the URL: /genres/1/movies?sort=titleAsc&s=star
export default class GenreMoviesController extends Controller {
  queryParams = [{ sortBy: 'sort' }, { searchTerm: 's' }];

  @tracked sortBy = 'ratingDesc';
  @tracked searchTerm = '';
}
