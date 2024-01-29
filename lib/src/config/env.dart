import 'package:flutter_dotenv/flutter_dotenv.dart';

/// 환경변수
class EnvConfig {
  /// 앱 이름
  final String name = dotenv.get('NAME');
  /// 버전(major.minor.patch)
  final String version = dotenv.get('VERSION');
  /// 이메일 주소
  final String emailAddress = dotenv.get('EMAIL_ADDRESS');
  /// github 링크
  final String githubUrl = dotenv.get('GITHUB_URL');

  /// local storage key
  final String localStorageKey = dotenv.get("LOCAL_STORAGE_KEY");

  final String dbSchema = dotenv.get("DB_SCHEMA");

  /// Custom REST API url
  final String utilsApiUrl = dotenv.get("UTILS_API_URL");

  /// 기상청 ApiKey
  final String weatherApiKey = dotenv.get('WEATHER_API_KEY');
  /// 기상청 Api URL
  final String weatherApiUrl = dotenv.get('WEATHER_API_URL');
}

final env = EnvConfig();