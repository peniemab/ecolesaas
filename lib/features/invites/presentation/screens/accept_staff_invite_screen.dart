import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../auth/data/auth_repository.dart';
import '../../data/invitations_repository.dart';

class AcceptStaffInviteScreen extends ConsumerStatefulWidget {
  const AcceptStaffInviteScreen({super.key, required this.token});

  final String? token;

  @override
  ConsumerState<AcceptStaffInviteScreen> createState() => _AcceptStaffInviteScreenState();
}

class _AcceptStaffInviteScreenState extends ConsumerState<AcceptStaffInviteScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _firstCtrl = TextEditingController();
  final _lastCtrl = TextEditingController();
  bool _loading = false;
  String? _peekError;
  bool _inviteOk = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _validateToken());
  }

  Future<void> _validateToken() async {
    final t = widget.token?.trim();
    if (t == null || t.isEmpty) {
      setState(() => _peekError = 'Lien invalide : token manquant.');
      return;
    }
    try {
      final repo = ref.read(invitationsRepositoryProvider);
      final peek = await repo.peekInvitation(t);
      final ok = peek['ok'] == true;
      final type = peek['invite_type']?.toString();
      if (!ok || type != 'staff_join') {
        setState(() => _peekError = 'Invitation inconnue, expirée ou déjà utilisée.');
        return;
      }
      setState(() => _inviteOk = true);
    } catch (e) {
      setState(() => _peekError = 'Erreur : $e');
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _firstCtrl.dispose();
    _lastCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final t = widget.token!.trim();
    if (_firstCtrl.text.isEmpty || _lastCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Prénom et nom requis.')));
      return;
    }

    setState(() => _loading = true);
    try {
      final client = Supabase.instance.client;
      if (client.auth.currentUser == null) {
        if (_emailCtrl.text.isEmpty || _passwordCtrl.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('E-mail et mot de passe requis.')));
          setState(() => _loading = false);
          return;
        }
        final auth = ref.read(authRepositoryProvider);
        final res = await auth.signUpWithEmail(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text.trim(),
        );
        if (res.session == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Confirmez votre e-mail si demandé, puis reconnectez-vous et rouvrez ce lien.'),
                duration: Duration(seconds: 10),
              ),
            );
            context.go('/login');
          }
          return;
        }
      }

      await ref.read(invitationsRepositoryProvider).acceptStaffInvitation(
        token: t,
        firstName: _firstCtrl.text.trim(),
        lastName: _lastCtrl.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bienvenue dans l’équipe !')));
        context.go('/dashboard');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur : $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loggedIn = Supabase.instance.client.auth.currentUser != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Rejoindre mon établissement'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: _buildBody(loggedIn),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(bool loggedIn) {
    if (_peekError != null) {
      return Column(
        children: [
          const Icon(Icons.error_outline, size: 56, color: Colors.red),
          const SizedBox(height: 16),
          Text(_peekError!, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          OutlinedButton(onPressed: () => context.go('/login'), child: const Text('Retour connexion')),
        ],
      );
    }
    if (!_inviteOk) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Invitation personnelle : complétez votre identité pour être rattaché à l’établissement.',
          style: TextStyle(color: AppColors.textSecondary, height: 1.4),
        ),
        const SizedBox(height: 24),
        if (!loggedIn) ...[
          CustomTextField(controller: _emailCtrl, label: 'E-mail professionnel', hint: 'vous@ecole.cd', prefixIcon: Icons.email_outlined),
          const SizedBox(height: 16),
          CustomTextField(controller: _passwordCtrl, label: 'Mot de passe', hint: '••••••••', isPassword: true, prefixIcon: Icons.lock_outline),
          const SizedBox(height: 24),
        ],
        CustomTextField(controller: _firstCtrl, label: 'Prénom', hint: 'Jean', prefixIcon: Icons.badge_outlined),
        const SizedBox(height: 16),
        CustomTextField(controller: _lastCtrl, label: 'Nom', hint: 'Mobutu', prefixIcon: Icons.badge_outlined),
        const SizedBox(height: 32),
        CustomButton(text: loggedIn ? 'Rejoindre l’établissement' : 'Créer mon compte et rejoindre', isLoading: _loading, onPressed: _submit),
        const SizedBox(height: 12),
        TextButton(onPressed: () => context.go('/login'), child: const Text('Se connecter avec un autre compte')),
      ],
    );
  }
}
