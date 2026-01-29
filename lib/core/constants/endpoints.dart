/// ApiEndpoint
///
/// This class contains all the API path suffixes and query parameter keys.
/// How it works:
/// The app combines the BaseURL (from Environment) + Endpoint to make a full request.
/// Example: `https://www.omdbapi.com/` + '' + `?s=batman&page=1&apikey=xxxx`
class ApiEndpoint {
  /// Movie endpoints (OMDb uses root path, so keep empty string)
  static const String searchMovies = '';   // Search movies endpoint
  static const String movieDetail = '';    // Movie detail endpoint

  /// Query parameter keys
  static const String searchParam = 's';       // search term
  static const String pageParam = 'page';      // pagination
  static const String idParam = 'i';           // imdbID for detail
}