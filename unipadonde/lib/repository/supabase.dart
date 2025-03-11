import 'package:supabase_flutter/supabase_flutter.dart';

class AuthenticationService {
  final SupabaseClient _supabase = Supabase.instance.client;

  //Sing in
  Future<AuthResponse> signIn(String email, String password) async {
    return await _supabase.auth
        .signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> signUp(String email, String password) async {
    return await _supabase.auth.signUp(email: email, password: password);
  }

  //Get user email
  String? getCurrentUserEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }

  //Sign out
  Future<void> singOut() async {
    await _supabase.auth.signOut();
  }

  SupabaseClient getsupabase() {
    return _supabase;
  }
}
