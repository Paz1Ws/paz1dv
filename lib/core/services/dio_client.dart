import 'package:dio/dio.dart';

class DioClient {
  // Replace with your Supabase URL and anon key
  static const String _supabaseUrl = 'https://aixvrdlpkpctqttaohax.supabase.co';
  static const String _supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFpeHZyZGxwa3BjdHF0dGFvaGF4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA1NDc3NzYsImV4cCI6MjA2NjEyMzc3Nn0.Xqth1iFAUXmMiXSkDXR97A_L8KpmG-O6bSSDbCKnbnc';

  // Private constructor
  DioClient._();

  // Singleton instance
  static final DioClient _instance = DioClient._();

  // Dio instance
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: '$_supabaseUrl/rest/v1',
      headers: {
        'apikey': _supabaseKey,
        'Authorization': 'Bearer $_supabaseKey',
      },
    ),
  );

  // Getter for the Dio instance
  static Dio get instance => _instance._dio;
}
