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

  // Se connecter avec le compte invité (provisionné par l'admin via Dashboard Supabase)
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Compléter l'Onboarding de manière atomique via une fonction Supabase (RPC)
  Future<void> completeOnboarding({
    required String schoolName,
    required String schoolAddress,
    required String adminName,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception("Vous n'êtes pas connecté.");

    // Exécution de la fonction Postgres (RPC) pour tout créer en une seule transaction sécurisée.
    await _supabase.rpc('complete_onboarding', params: {
      'p_school_name': schoolName,
      'p_school_address': schoolAddress,
      'p_admin_name': adminName,
    });
  }

  // Déconnexion
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Vérifier l'état du profil utilisateur (pour le rootage vers Onboarding vs Dashboard)
  Future<String> checkUserStatus() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return 'unauthenticated';

    try {
      // Étape 1 : Vérifie si l'utilisateur possède déjà une ligne dans 'profiles'
      final profileResponse = await _supabase
          .from('profiles')
          .select('school_id')
          .eq('id', userId)
          .maybeSingle();

      // S'il n'en a pas, alors il doit passer par l'Onboarding !
      if (profileResponse == null) {
        return 'needs_onboarding';
      }

      // Étape 2 : S'il est inscrit, on vérifie l'état global de l'école
      final schoolId = profileResponse['school_id'];
      final schoolResponse = await _supabase
          .from('schools')
          .select('status')
          .eq('id', schoolId)
          .single();

      return schoolResponse['status'] as String; // Va retourner 'active', 'pending', etc.
    } catch (e) {
      return 'error';
    }
  }
}
