import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return ReportRepository(Supabase.instance.client);
});

class ReportRepository {
  final SupabaseClient _supabase;
  ReportRepository(this._supabase);

  Future<String> _getSchoolId() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception("Non authentifié");
    final profile = await _supabase.from('profiles').select('school_id').eq('id', userId).single();
    return profile['school_id'];
  }

  /// Calculates the financial report for a given academic year.
  Future<Map<String, dynamic>> getFinancialReport(String academicYear) async {
    final schoolId = await _getSchoolId();

    // 1. Get all fees for this year
    final fees = await _supabase
        .from('fees')
        .select()
        .eq('school_id', schoolId)
        .eq('academic_year', academicYear);

    // 2. Get all students
    final students = await _supabase
        .from('students')
        .select()
        .eq('school_id', schoolId)
        .order('nom');

    // 3. Get all payments
    final payments = await _supabase
        .from('payments_history')
        .select();

    // Filter payments for only the fees defined this year
    final feeIds = fees.map((f) => f['id']).toSet();
    final currentYearPayments = payments.where((p) => feeIds.contains(p['fee_id'])).toList();

    // Calculate Global Stats
    double totalExpectedGlobally = 0;
    for (var fee in fees) {
      double amount = double.parse(fee['amount'].toString());
      totalExpectedGlobally += (amount * students.length);
    }

    double totalReceivedGlobally = 0;
    for (var p in currentYearPayments) {
      totalReceivedGlobally += double.parse(p['amount_paid'].toString());
    }

    // Assign stats per student
    List<Map<String, dynamic>> studentReports = [];

    for (var student in students) {
      final sId = student['id'];
      final studentPayments = currentYearPayments.where((p) => p['student_id'] == sId).toList();
      
      double studentExpected = 0;
      double studentPaid = 0;
      
      for (var f in fees) {
        studentExpected += double.parse(f['amount'].toString());
      }

      for (var p in studentPayments) {
        studentPaid += double.parse(p['amount_paid'].toString());
      }

      studentReports.add({
        ...student,
        'total_expected': studentExpected,
        'total_paid': studentPaid,
        'remaining': studentExpected - studentPaid,
        'is_solde': studentPaid >= studentExpected,
      });
    }

    return {
      'global': {
        'total_students': students.length,
        'total_expected': totalExpectedGlobally,
        'total_received': totalReceivedGlobally,
        'total_remaining': totalExpectedGlobally - totalReceivedGlobally,
      },
      'students': studentReports,
    };
  }
}
