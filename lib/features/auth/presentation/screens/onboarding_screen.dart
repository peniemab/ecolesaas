import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/auth_repository.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  bool _isLoading = false;

  final _schoolNameCtrl = TextEditingController();
  final _schoolAddressCtrl = TextEditingController();
  final _adminNameCtrl = TextEditingController();

  @override
  void dispose() {
    _schoolNameCtrl.dispose();
    _schoolAddressCtrl.dispose();
    _adminNameCtrl.dispose();
    super.dispose();
  }

  Future<void> _submitOnboarding() async {
    if (_schoolNameCtrl.text.isEmpty || _adminNameCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Le nom de l'école et votre nom sont requis")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.completeOnboarding(
        schoolName: _schoolNameCtrl.text.trim(),
        schoolAddress: _schoolAddressCtrl.text.trim(),
        adminName: _adminNameCtrl.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Configuration terminée ! Bienvenue sur votre plateforme !"))
        );
        context.go('/dashboard');
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur : $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: Responsive.isMobile(context) 
        ? AppBar(
            backgroundColor: Colors.transparent, 
            elevation: 0,
            title: const Text("Configuration Initiale", style: TextStyle(color: AppColors.textPrimary)),
            centerTitle: true,
          ) : null,
      body: Responsive(
        mobile: SingleChildScrollView(
          child: Padding(padding: const EdgeInsets.symmetric(vertical: 24.0), child: _buildFormContent()),
        ),
        desktop: Center(
          child: Container(
            width: 600,
            padding: const EdgeInsets.all(48.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 24, offset: const Offset(0, 8))
              ]
            ),
            child: _buildFormContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.rocket_launch, size: 64, color: AppColors.primary),
          const SizedBox(height: 24),
          const Text(
            "Dernière étape !",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            "Finalisons la configuration de votre établissement avant d'accéder au tableau de bord.",
            style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),

          CustomTextField(controller: _schoolNameCtrl, label: "Nom de l'établissement", hint: "Ex: Lycée d'Excellence", prefixIcon: Icons.account_balance),
          const SizedBox(height: 20),
          CustomTextField(controller: _schoolAddressCtrl, label: "Ville / Adresse", hint: "Ex: Kinshasa, Gombe", prefixIcon: Icons.location_on_outlined),
          const SizedBox(height: 20),
          CustomTextField(controller: _adminNameCtrl, label: "Votre nom complet", hint: "Ex: Jean Dupont", prefixIcon: Icons.person_outline),
          
          const SizedBox(height: 40),
          CustomButton(
            text: "Enregistrer mon école",
            isLoading: _isLoading,
            onPressed: _submitOnboarding,
          ),
        ],
      ),
    );
  }
}
