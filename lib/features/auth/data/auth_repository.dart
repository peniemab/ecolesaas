import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(supabaseClientProvider));
});

class AuthRepository {
  final SupabaseClient _supabase;

  AuthRepository(this._supabase);

  Future<void> signIn({required String email, required String password}) async {
    await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> completeOnboarding({
    required String schoolName,
    required String schoolAddress,
    required String adminName,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception("Vous n'êtes pas connecté.");

    await _supabase.rpc(
      'complete_onboarding',
      params: {
        'p_school_name': schoolName,
        'p_school_address': schoolAddress,
        'p_admin_name': adminName,
      },
    );
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  Future<String> checkUserStatus() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return 'unauthenticated';

    try {
      final profileResponse = await _supabase
          .from('profiles')
          .select('school_id')
          .eq('id', userId)
          .maybeSingle();

      if (profileResponse == null) {
        return 'needs_onboarding';
      }

      final schoolId = profileResponse['school_id'];
      final schoolResponse = await _supabase
          .from('schools')
          .select('status')
          .eq('id', schoolId)
          .single();

      return schoolResponse['status'] as String;
    } catch (e) {
      return 'error';
    }
  }
}
