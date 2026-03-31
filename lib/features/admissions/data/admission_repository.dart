import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final admissionRepositoryProvider = Provider<AdmissionRepository>((ref) {
  return AdmissionRepository(Supabase.instance.client);
});

class AdmissionRepository {
  final SupabaseClient _supabase;
  AdmissionRepository(this._supabase);

  Future<Map<String, dynamic>> registerStudent({
    required String nom,
    required String prenom,
    required String sexe,
    required String lieuNaissance,
    required String dateNaissance,
    required String classeAssignee,
    required String ecoleProvenance,
    required String tuteurNom,
    required String lienParente,
    required String tuteurPhone,
    required String tuteurAdresse,
    required String urgenceContact,
    required String urgenceMaladie,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception("Non authentifié");

    final profile = await _supabase
        .from('profiles')
        .select('school_id')
        .eq('id', userId)
        .single();
    final schoolId = profile['school_id'];

    final year = DateTime.now().year;
    final countRes = await _supabase
        .from('students')
        .select('id')
        .eq('school_id', schoolId);
    final nextNumber = (countRes.length + 1).toString().padLeft(4, '0');
    final matricule = 'MAT-$year-$nextNumber';

    final studentData = await _supabase
        .from('students')
        .insert({
          'school_id': schoolId,
          'matricule': matricule,
          'nom': nom,
          'prenom': prenom,
          'sexe': sexe,
          'date_naissance': dateNaissance.isEmpty ? null : dateNaissance,
          'lieu_naissance': lieuNaissance,
          'niveau_scolaire': classeAssignee, // using classeAssignee as fallback for UI
          'classe_assignee': classeAssignee,
          'ecole_provenance': ecoleProvenance,
        })
        .select()
        .single();

    final studentId = studentData['id'];

    await _supabase.from('guardians').insert({
      'student_id': studentId,
      'nom_complet': tuteurNom,
      'lien_parente': lienParente,
      'telephone': tuteurPhone,
      'adresse': tuteurAdresse,
      'urgence_contact': urgenceContact,
      'urgence_maladie': urgenceMaladie,
    });

    return {'matricule': matricule, 'classe_assignee': classeAssignee};
  }
}
