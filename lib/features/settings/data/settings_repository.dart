import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(Supabase.instance.client);
});

class SettingsRepository {
  final SupabaseClient _supabase;
  SettingsRepository(this._supabase);

  Future<String> _getSchoolId() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception("Non authentifié");
    
    final profile = await _supabase
        .from('profiles')
        .select('school_id')
        .eq('id', userId)
        .single();
    return profile['school_id'];
  }

  // --- Classrooms ---
  Future<List<Map<String, dynamic>>> getClassrooms() async {
    final schoolId = await _getSchoolId();
    return await _supabase
        .from('classrooms')
        .select()
        .eq('school_id', schoolId)
        .order('name');
  }

  Future<void> addClassroom(String name) async {
    final schoolId = await _getSchoolId();
    await _supabase.from('classrooms').insert({
      'school_id': schoolId,
      'name': name,
    });
  }

  Future<void> deleteClassroom(String id) async {
    await _supabase.from('classrooms').delete().eq('id', id);
  }

  // --- Fees ---
  Future<List<Map<String, dynamic>>> getFees(String academicYear) async {
    final schoolId = await _getSchoolId();
    return await _supabase
        .from('fees')
        .select()
        .eq('school_id', schoolId)
        .eq('academic_year', academicYear)
        .order('name');
  }

  Future<void> addFee({
    required String name,
    required double amount,
    required String academicYear,
  }) async {
    final schoolId = await _getSchoolId();
    await _supabase.from('fees').insert({
      'school_id': schoolId,
      'name': name,
      'amount': amount,
      'academic_year': academicYear,
    });
  }

  Future<void> deleteFee(String id) async {
    await _supabase.from('fees').delete().eq('id', id);
  }

  // --- Logo Upload ---
  Future<String> uploadLogo(Uint8List fileBytes, String fileName) async {
    try {
      final schoolId = await _getSchoolId();
      final ext = fileName.split('.').last.toLowerCase();
      final filePath = '$schoolId/logo.${DateTime.now().millisecondsSinceEpoch}.$ext';
      
      String mimeType = 'image/png';
      if (ext == 'jpg' || ext == 'jpeg') {
        mimeType = 'image/jpeg';
      } else if (ext == 'webp') {
        mimeType = 'image/webp';
      } else if (ext == 'gif') {
        mimeType = 'image/gif';
      }
      
      await _supabase.storage.from('logos').uploadBinary(
        filePath, 
        fileBytes,
        fileOptions: FileOptions(contentType: mimeType, upsert: true),
      );
      
      final publicUrl = _supabase.storage.from('logos').getPublicUrl(filePath);
      
      final userId = _supabase.auth.currentUser?.id;
      // Depending on table structure, maybe we should update `profiles` or `schools`. We put it in `profiles` for now.
      await _supabase.from('profiles').update({'logo_url': publicUrl}).eq('id', userId!);
      
      return publicUrl;
    } catch (e) {
      throw Exception("Erreur lors de l'upload du logo : $e");
    }
  }

  Future<String?> getLogoUrl() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return null;
    final profile = await _supabase.from('profiles').select('logo_url').eq('id', userId).single();
    return profile['logo_url'] as String?;
  }
}
