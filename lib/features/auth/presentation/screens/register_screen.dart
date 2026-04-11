import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/progress_stepper.dart';
import '../../application/auth_controller.dart';

/// Écran d'inscription multi-étapes.
///
/// UX choisie :
/// - un seul écran
/// - 3 étapes avec barre de progression
/// - étape 3 = données médicales + consentements + question don récent
///
/// Important :
/// la question "don dans les 4 derniers mois" est ajoutée ici pour la logique métier.
/// Pour l'instant, elle est gérée côté UI.
/// TODO Dev1/Backend : ajouter ce champ dans l'endpoint register step 3
/// si vous voulez l'enregistrer directement en base.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  int _step = 1;

  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _genreController = TextEditingController();
  final _dateNaissanceController = TextEditingController();

  final _villeController = TextEditingController();
  final _quartierController = TextEditingController();

  final _groupeSanguinController = TextEditingController();

  bool _accepteConditions = false;
  bool _acceptePolitique = false;

  /// null = pas encore répondu
  /// true = oui, a donné du sang récemment
  /// false = non
  bool? _aDonneRecemment;

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _genreController.dispose();
    _dateNaissanceController.dispose();
    _villeController.dispose();
    _quartierController.dispose();
    _groupeSanguinController.dispose();
    super.dispose();
  }

  Future<void> _submitStep() async {
    final authCtrl = ref.read(authControllerProvider.notifier);

    if (_step == 1) {
      final isValid = _formKey.currentState?.validate() ?? false;
      if (!isValid) return;

      await authCtrl.registerStep1(
        nom: _nomController.text.trim(),
        prenom: _prenomController.text.trim(),
        genre:
            _genreController.text.trim().isEmpty
                ? null
                : _genreController.text.trim(),
        dateNaissance:
            _dateNaissanceController.text.trim().isEmpty
                ? null
                : _dateNaissanceController.text.trim(),
      );

      if (!mounted) return;
      if (ref.read(authControllerProvider).errorMessage == null) {
        setState(() => _step = 2);
      }
      return;
    }

    if (_step == 2) {
      await authCtrl.registerStep2(
        ville:
            _villeController.text.trim().isEmpty
                ? null
                : _villeController.text.trim(),
        quartier:
            _quartierController.text.trim().isEmpty
                ? null
                : _quartierController.text.trim(),
      );

      if (!mounted) return;
      if (ref.read(authControllerProvider).errorMessage == null) {
        setState(() => _step = 3);
      }
      return;
    }

    if (_step == 3) {
      if (_aDonneRecemment == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Veuillez indiquer si vous avez donné du sang durant les 4 derniers mois.',
            ),
          ),
        );
        return;
      }

      if (!_accepteConditions || !_acceptePolitique) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Veuillez accepter les conditions et la politique de confidentialité.',
            ),
          ),
        );
        return;
      }

      await authCtrl.registerStep3(
        groupeSanguin:
            _groupeSanguinController.text.trim().isEmpty
                ? null
                : _groupeSanguinController.text.trim(),
        accepteConditions: _accepteConditions,
        acceptePolitiqueConfidentialite: _acceptePolitique,
      );

      if (!mounted) return;

      if (ref.read(authControllerProvider).errorMessage == null) {
        // Décision UX actuelle :
        // après inscription, on va vers Home.
        // Le mot de passe sera demandé ensuite dans un modal côté HomeScreen.
        context.go(RouteNames.home);
      }
    }
  }

  Widget _buildStep1() {
    return Column(
      children: [
        CustomTextField(
          controller: _nomController,
          hintText: 'Nom',
          labelText: 'Nom',
          validator:
              (value) => Validators.requiredField(value, fieldName: 'Le nom'),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _prenomController,
          hintText: 'Prénom',
          labelText: 'Prénom',
          validator:
              (value) =>
                  Validators.requiredField(value, fieldName: 'Le prénom'),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _genreController,
          hintText: 'Genre',
          labelText: 'Genre',
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _dateNaissanceController,
          hintText: 'YYYY-MM-DD',
          labelText: 'Date de naissance',
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      children: [
        CustomTextField(
          controller: _villeController,
          hintText: 'Ville',
          labelText: 'Ville',
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _quartierController,
          hintText: 'Quartier',
          labelText: 'Quartier',
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: _groupeSanguinController,
          hintText: 'Ex: O+, A-, B+',
          labelText: 'Groupe sanguin',
        ),
        const SizedBox(height: 20),

        const Text(
          'Avez-vous donné du sang durant les 4 derniers mois ?',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),

        RadioListTile<bool>(
          value: true,
          groupValue: _aDonneRecemment,
          onChanged: (value) {
            setState(() => _aDonneRecemment = value);
          },
          title: const Text('Oui'),
          contentPadding: EdgeInsets.zero,
        ),
        RadioListTile<bool>(
          value: false,
          groupValue: _aDonneRecemment,
          onChanged: (value) {
            setState(() => _aDonneRecemment = value);
          },
          title: const Text('Non'),
          contentPadding: EdgeInsets.zero,
        ),

        const SizedBox(height: 8),
        CheckboxListTile(
          value: _accepteConditions,
          onChanged: (value) {
            setState(() => _accepteConditions = value ?? false);
          },
          title: const Text('J’accepte les conditions'),
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          value: _acceptePolitique,
          onChanged: (value) {
            setState(() => _acceptePolitique = value ?? false);
          },
          title: const Text('J’accepte la politique de confidentialité'),
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Inscription')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ProgressStepper(currentStep: _step, totalSteps: 3),
                  const SizedBox(height: 24),

                  if (_step == 1) _buildStep1(),
                  if (_step == 2) _buildStep2(),
                  if (_step == 3) _buildStep3(),

                  if (authState.errorMessage != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      authState.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      if (_step > 1)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() => _step--);
                            },
                            child: const Text('Retour'),
                          ),
                        ),
                      if (_step > 1) const SizedBox(width: 12),
                      Expanded(
                        child: CustomButton(
                          text: _step == 3 ? 'Terminer' : 'Suivant',
                          isLoading: authState.isLoading,
                          onPressed: _submitStep,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
