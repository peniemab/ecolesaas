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
    required String niveauScolaire,
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
    final matricule = 'MAT-$year-$nextNumber'; // Ex: MAT-2026-0005

    final existingStudents = await _supabase
        .from('students')
        .select('classe_assignee')
        .eq('school_id', schoolId)
        .eq('niveau_scolaire', niveauScolaire);

    int countA = 0;
    int countB = 0;
    for (var row in existingStudents) {
      final classe = row['classe_assignee'] as String?;
      if (classe != null) {
        if (classe.endsWith(' A')) countA++;
        if (classe.endsWith(' B')) countB++;
      }
    }

    final section = countA <= countB ? 'A' : 'B';
    final classeFinale = '$niveauScolaire $section';

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
          'niveau_scolaire': niveauScolaire,
          'classe_assignee': classeFinale,
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

    return {'matricule': matricule, 'classe_assignee': classeFinale};
  }
}
