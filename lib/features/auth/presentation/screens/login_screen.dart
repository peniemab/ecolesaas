import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/auth_repository.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_emailCtrl.text.isEmpty || _passwordCtrl.text.isEmpty) return;

    setState(() => _isLoading = true);
    
    try {
      final authRepo = ref.read(authRepositoryProvider);
      
      // Essayer de se connecter
      await authRepo.signIn(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
      );
      
      // Vérifier l'état de l'utilisateur (Onboarding incomplet, ou client actif)
      if (mounted) {
         final status = await authRepo.checkUserStatus();
         
         if (status == 'needs_onboarding') {
            // C'est sa toute première connexion et il n'a pas encore configuré son école !
            context.go('/onboarding');
         } else if (status == 'active') {
             context.go('/dashboard');
         } else if (status == 'pending') {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => AlertDialog(
                title: const Text("🔒 Accès restreint"),
                content: const Text("Votre établissement est en attente d'activation administrative."),
                actions: [TextButton(onPressed: () { Navigator.pop(context); authRepo.signOut(); }, child: const Text("Compris"))]
              )
            );
         } else {
             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Accès refusé.")));
             authRepo.signOut();
         }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur : Email ou mot de passe incorrect.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Responsive(
        mobile: Center(
          child: SingleChildScrollView(
            child: _buildLoginForm(),
          ),
        ),
        desktop: Row(
          children: [
            Expanded(
              child: Container(
                color: AppColors.primary,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.school_rounded, size: 120, color: Colors.white),
                      SizedBox(height: 24),
                      Text('School SaaS', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white)),
                      SizedBox(height: 16),
                      Text('La gestion scolaire simplifiée.', style: TextStyle(fontSize: 20, color: Colors.white70)),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 64.0),
                    child: _buildLoginForm(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (Responsive.isMobile(context)) ...[
            const Icon(Icons.school_rounded, size: 80, color: AppColors.primary),
            const SizedBox(height: 16),
            const Text('School SaaS', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primary)),
            const SizedBox(height: 32),
          ],
          const Text('Bienvenue !', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          const Text('Connectez-vous à votre espace établissement.', style: TextStyle(fontSize: 15, color: AppColors.textSecondary)),
          const SizedBox(height: 48),
          
          CustomTextField(
            controller: _emailCtrl,
            label: 'Adresse email',
            hint: 'admin@ecole.com',
            prefixIcon: Icons.email_outlined,
          ),
          const SizedBox(height: 20),
          
          CustomTextField(
            controller: _passwordCtrl,
            label: 'Mot de passe',
            hint: '••••••••',
            isPassword: true,
            prefixIcon: Icons.lock_outline,
          ),
          const SizedBox(height: 8),
          
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text('Mot de passe oublié ?', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 24),
          
          CustomButton(
            text: 'Se connecter',
            isLoading: _isLoading,
            onPressed: _login,
          ),
          const SizedBox(height: 32),
          
          // Le bouton d'inscription a été masqué. 
          // Les comptes sont dorénavant fournis manuellement par l'administrateur du SaaS.
        ],
      ),
    );
  }
}
