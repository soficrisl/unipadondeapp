import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseRepository {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchCountries() async {
    final response = await _supabaseClient.from('table').select('name');
    return response;
  }
}
