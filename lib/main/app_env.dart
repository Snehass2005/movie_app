enum AppEnvironment { dev, stage, prod }

abstract class EnvInfo {
  static AppEnvironment _environment = AppEnvironment.dev;

  /// Initialize the environment at app startup
  static void initialize(AppEnvironment environment) {
    EnvInfo._environment = environment;
  }

  static String get appName => _environment._appTitle;
  static String get envName => _environment._envName;
  static String get connectionString => _environment._connectionString;
  static String get baseUrl => _environment._baseUrls;
  static String get apiKey => _environment._apiKeys;
  static String get webPageUrl => _environment._webPageUrls;

  static AppEnvironment get environment => _environment;
  static bool get isProduction => _environment == AppEnvironment.prod;
}

extension _EnvProperties on AppEnvironment {
  static const _appTitles = {
    AppEnvironment.dev: 'OMDb Dev',
    AppEnvironment.stage: 'OMDb Staging',
    AppEnvironment.prod: 'OMDb Prod',
  };

  static const _connectionStrings = {
    AppEnvironment.dev: '',
    AppEnvironment.stage: '',
    AppEnvironment.prod: '',
  };

  /// OMDb API base URLs
  static const _baseUrl = {
    AppEnvironment.dev: 'https://www.omdbapi.com/',
    AppEnvironment.stage: 'https://www.omdbapi.com/',
    AppEnvironment.prod: 'https://www.omdbapi.com/',
  };

  static const _apiKeyMap = {
    AppEnvironment.dev: 'fba622c4',
    AppEnvironment.stage: 'fba622c4',
    AppEnvironment.prod: 'fba622c4',
  };


  static const _envs = {
    AppEnvironment.dev: 'dev',
    AppEnvironment.stage: 'uat',
    AppEnvironment.prod: 'prod',
  };

  static const _webPageUrl = {
    AppEnvironment.dev: 'https://www.omdbapi.com',
    AppEnvironment.stage: 'https://www.omdbapi.com',
    AppEnvironment.prod: 'https://www.omdbapi.com',
  };

  String get _appTitle => _appTitles[this]!;
  String get _envName => _envs[this]!;
  String get _connectionString => _connectionStrings[this]!;
  String get _baseUrls => _baseUrl[this]!;
  String get _apiKeys =>_apiKeyMap[this]!;
  String get _webPageUrls => _webPageUrl[this]!;
}