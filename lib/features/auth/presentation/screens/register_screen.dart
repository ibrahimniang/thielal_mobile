import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../application/auth_controller.dart';

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
  final _dateNaissanceController = TextEditingController();

  final _villeController = TextEditingController();
  final _quartierController = TextEditingController();

  final _groupeSanguinController = TextEditingController();

  String? _genreUiValue; // Masculin / Féminin

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
    _dateNaissanceController.dispose();
    _villeController.dispose();
    _quartierController.dispose();
    _groupeSanguinController.dispose();
    super.dispose();
  }

  String? _mapGenreForApi() {
    switch (_genreUiValue) {
      case 'Masculin':
        return 'M';
      case 'Féminin':
        return 'F';
      default:
        return null;
    }
  }

  String _stepTitle() {
    switch (_step) {
      case 1:
        return 'Informations personnelles';
      case 2:
        return 'Adresse et contact';
      case 3:
        return 'Santé et consentement';
      default:
        return '';
    }
  }

  String _stepSubtitle() {
    switch (_step) {
      case 1:
        return 'Renseignez votre identité de base pour commencer.';
      case 2:
        return 'Ajoutez votre localisation et vérifiez vos coordonnées.';
      case 3:
        return 'Complétez vos informations médicales et validez les conditions.';
      default:
        return '';
    }
  }

  Future<void> _submitStep() async {
    final authCtrl = ref.read(authControllerProvider.notifier);

    if (_step == 1) {
      final isValid = _formKey.currentState?.validate() ?? false;
      if (!isValid) return;

      await authCtrl.registerStep1(
        nom: _nomController.text.trim(),
        prenom: _prenomController.text.trim(),
        genre: _mapGenreForApi(),
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
        aDonneRecemment: _aDonneRecemment!,
      );

      if (!mounted) return;

      if (ref.read(authControllerProvider).errorMessage == null) {
        context.go(RouteNames.home);
      }
    }
  }

  Widget _buildProgressHeader() {
    final progress = _step / 3;

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.92),
                Colors.red.shade50.withOpacity(0.88),
                Colors.blue.shade50.withOpacity(0.76),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.75),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.08),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: Colors.blue.withOpacity(0.06),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.red.shade500, Colors.red.shade700],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.22),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.favorite_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _stepTitle(),
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1B1F24),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _stepSubtitle(),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  height: 12,
                  width: double.infinity,
                  color: Colors.white.withOpacity(0.75),
                  child: Stack(
                    children: [
                      FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            gradient: LinearGradient(
                              colors: [
                                Colors.red.shade500,
                                Colors.green.shade500,
                                Colors.blue.shade500,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: List.generate(3, (index) {
                  final itemStep = index + 1;
                  final isActive = itemStep == _step;
                  final isDone = itemStep < _step;

                  Color dotColor;
                  if (isDone) {
                    dotColor = Colors.green.shade500;
                  } else if (isActive) {
                    dotColor = Colors.red.shade600;
                  } else {
                    dotColor = Colors.grey.shade300;
                  }

                  return Expanded(
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          width: isActive ? 16 : 12,
                          height: isActive ? 16 : 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: dotColor,
                            boxShadow:
                                isActive
                                    ? [
                                      BoxShadow(
                                        color: Colors.red.withOpacity(0.20),
                                        blurRadius: 12,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                    : null,
                          ),
                        ),
                        if (index != 2)
                          Expanded(
                            child: Container(
                              height: 3,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(999),
                                color:
                                    itemStep < _step
                                        ? Colors.green.shade300
                                        : Colors.grey.shade300,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required Widget child,
    EdgeInsetsGeometry? padding,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          padding: padding ?? const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            color: Colors.white.withOpacity(0.82),
            border: Border.all(color: Colors.white.withOpacity(0.75)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildChoiceChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    required List<Color> colors,
    IconData? icon,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: selected ? LinearGradient(colors: colors) : null,
            color: selected ? null : Colors.white,
            border: Border.all(
              color: selected ? Colors.transparent : Colors.grey.shade300,
            ),
            boxShadow:
                selected
                    ? [
                      BoxShadow(
                        color: colors.first.withOpacity(0.18),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ]
                    : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 18,
                  color: selected ? Colors.white : Colors.grey.shade700,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: selected ? Colors.white : Colors.grey.shade800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConsentTile({
    required bool value,
    required ValueChanged<bool?> onChanged,
    required String title,
    required Color accent,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: accent.withOpacity(0.08),
        border: Border.all(color: accent.withOpacity(0.16)),
      ),
      child: CheckboxListTile(
        value: value,
        onChanged: onChanged,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        activeColor: accent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }

  Widget _buildStep1() {
    return _buildSectionCard(
      child: Column(
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
          const SizedBox(height: 18),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Genre',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade800,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildChoiceChip(
                label: 'Masculin',
                selected: _genreUiValue == 'Masculin',
                onTap: () => setState(() => _genreUiValue = 'Masculin'),
                colors: [Colors.blue.shade500, Colors.blue.shade700],
                icon: Icons.male_rounded,
              ),
              const SizedBox(width: 12),
              _buildChoiceChip(
                label: 'Féminin',
                selected: _genreUiValue == 'Féminin',
                onTap: () => setState(() => _genreUiValue = 'Féminin'),
                colors: [Colors.red.shade400, Colors.red.shade600],
                icon: Icons.female_rounded,
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _dateNaissanceController,
            hintText: 'YYYY-MM-DD',
            labelText: 'Date de naissance',
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    final authState = ref.watch(authControllerProvider);

    return _buildSectionCard(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.blue.shade50,
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: Row(
              children: [
                Icon(Icons.phone_rounded, color: Colors.blue.shade700),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    authState.pendingPhone?.isNotEmpty == true
                        ? authState.pendingPhone!
                        : 'Numéro récupéré depuis l’OTP',
                    style: TextStyle(
                      color: Colors.blue.shade900,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
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
      ),
    );
  }

  Widget _buildStep3() {
    return _buildSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            controller: _groupeSanguinController,
            hintText: 'Ex: O+, A-, B+',
            labelText: 'Groupe sanguin',
          ),
          const SizedBox(height: 22),
          Text(
            'Avez-vous donné du sang durant les 4 derniers mois ?',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: Colors.grey.shade900,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildChoiceChip(
                label: 'Oui',
                selected: _aDonneRecemment == true,
                onTap: () => setState(() => _aDonneRecemment = true),
                colors: [Colors.green.shade500, Colors.green.shade700],
                icon: Icons.check_circle_rounded,
              ),
              const SizedBox(width: 12),
              _buildChoiceChip(
                label: 'Non',
                selected: _aDonneRecemment == false,
                onTap: () => setState(() => _aDonneRecemment = false),
                colors: [Colors.red.shade400, Colors.red.shade600],
                icon: Icons.cancel_rounded,
              ),
            ],
          ),
          const SizedBox(height: 22),
          _buildConsentTile(
            value: _accepteConditions,
            onChanged: (value) {
              setState(() => _accepteConditions = value ?? false);
            },
            title: 'J’accepte les conditions',
            accent: Colors.red.shade600,
          ),
          _buildConsentTile(
            value: _acceptePolitique,
            onChanged: (value) {
              setState(() => _acceptePolitique = value ?? false);
            },
            title: 'J’accepte la politique de confidentialité',
            accent: Colors.blue.shade600,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isLoading) {
    return Row(
      children: [
        if (_step > 1)
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                setState(() => _step--);
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Retour'),
            ),
          ),
        if (_step > 1) const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: CustomButton(
            text: _step == 3 ? 'Terminer' : 'Continuer',
            isLoading: isLoading,
            onPressed: _submitStep,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(title: const Text('Inscription'), elevation: 0),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.red.shade50.withOpacity(0.55),
              Colors.green.shade50.withOpacity(0.40),
              Colors.blue.shade50.withOpacity(0.45),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildProgressHeader(),
                    const SizedBox(height: 22),

                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: KeyedSubtree(
                        key: ValueKey(_step),
                        child:
                            _step == 1
                                ? _buildStep1()
                                : _step == 2
                                ? _buildStep2()
                                : _buildStep3(),
                      ),
                    ),

                    if (authState.errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.red.shade50,
                          border: Border.all(color: Colors.red.shade100),
                        ),
                        child: Text(
                          authState.errorMessage!,
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),
                    _buildActionButtons(authState.isLoading),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
