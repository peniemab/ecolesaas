import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepository(Supabase.instance.client);
});

class PaymentRepository {
  final SupabaseClient _supabase;
  PaymentRepository(this._supabase);

  Future<String> _getSchoolId() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception("Non authentifié");
    final profile = await _supabase.from('profiles').select('school_id').eq('id', userId).single();
    return profile['school_id'];
  }

  // Chercher un élève par matricule
  Future<Map<String, dynamic>?> searchStudentByMatricule(String matricule) async {
    final schoolId = await _getSchoolId();
    final res = await _supabase
        .from('students')
        .select()
        .eq('school_id', schoolId)
        .eq('matricule', matricule)
        .maybeSingle();
    return res;
  }

  // Récupérer le statut des frais (tous les frais attendus vs montant payé)
  Future<List<Map<String, dynamic>>> getStudentFeeStatus(String studentId, String academicYear) async {
    final schoolId = await _getSchoolId();

    // 1. Get all fees for the academic year
    final fees = await _supabase
        .from('fees')
        .select()
        .eq('school_id', schoolId)
        .eq('academic_year', academicYear);

    // 2. Get all payments made by this student
    final payments = await _supabase
        .from('payments_history')
        .select()
        .eq('student_id', studentId);

    // 3. Compute sums
    List<Map<String, dynamic>> statusList = [];
    for (var fee in fees) {
      final feeId = fee['id'];
      final expectedAmount = double.parse(fee['amount'].toString());
      
      // Calculate total paid for this fee
      double totalPaid = 0;
      for (var p in payments) {
        if (p['fee_id'] == feeId) {
          totalPaid += double.parse(p['amount_paid'].toString());
        }
      }

      statusList.add({
        'fee_id': feeId,
        'fee_name': fee['name'],
        'expected_amount': expectedAmount,
        'total_paid': totalPaid,
        'remaining': expectedAmount - totalPaid,
        'is_fully_paid': totalPaid >= expectedAmount,
        'payments': payments.where((p) => p['fee_id'] == feeId).toList(),
      });
    }

    return statusList;
  }

  // Enregistrer un paiement
  Future<Map<String, dynamic>> payFee({
    required String studentId,
    required String feeId,
    required double amountPaid,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    final receiptNumber = 'REC-${DateTime.now().millisecondsSinceEpoch}';

    final res = await _supabase.from('payments_history').insert({
      'student_id': studentId,
      'fee_id': feeId,
      'amount_paid': amountPaid,
      'receipt_number': receiptNumber,
      'created_by': userId,
    }).select().single();

    return res;
  }

  // Historique global (pour dashboard/caissier optionnel)
  Future<List<dynamic>> getRecentPayments() async {
    // Note: requires join if we want student names. For simple stats, just fetch.
    return [];
  }
}
