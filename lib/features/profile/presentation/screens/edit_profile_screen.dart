import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/profile_controller.dart';
import '../../data/models/profile_model.dart';
import '../widgets/profile_section_card.dart';
import '../widgets/profile_action_button.dart';
import '../widgets/contact_change_dialog.dart';
import '../../../../shared/widgets/app_loading_view.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _villeController = TextEditingController();
  final _quartierController = TextEditingController();

  bool _initialized = false;
  bool _saving = false;

  void _init(ProfileModel? user) {
    if (_initialized || user == null) return;

    _nomController.text = user.nom ?? '';
    _prenomController.text = user.prenom ?? '';
    _villeController.text = user.ville ?? '';
    _quartierController.text = user.quartier ?? '';

    _initialized = true;
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _villeController.dispose();
    _quartierController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() => _saving = true);

    try {
      await ref
          .read(profileControllerProvider.notifier)
          .updateProfile(
            nom: _nomController.text.trim(),
            prenom: _prenomController.text.trim(),
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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil mis à jour avec succès'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur lors de la mise à jour du profil'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  void _openEmailDialog() {
    showDialog(
      context: context,
      builder:
          (_) => ContactChangeDialog(
            title: 'Changer / Ajouter un email',
            valueLabel: 'Email',
            keyboardType: TextInputType.emailAddress,
            onRequestCode: (ref, value) async {
              await ref
                  .read(profileControllerProvider.notifier)
                  .requestEmail(value);

              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Code envoyé par email'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            onVerify: (ref, value, code) async {
              await ref
                  .read(profileControllerProvider.notifier)
                  .verifyEmail(value, code);

              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Email mis à jour avec succès'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
    );
  }

  void _openPhoneDialog() {
    showDialog(
      context: context,
      builder:
          (_) => ContactChangeDialog(
            title: 'Changer le téléphone',
            valueLabel: 'Téléphone',
            keyboardType: TextInputType.phone,
            onRequestCode: (ref, value) async {
              await ref
                  .read(profileControllerProvider.notifier)
                  .requestPhone(value);

              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Code envoyé par SMS'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            onVerify: (ref, value, code) async {
              await ref
                  .read(profileControllerProvider.notifier)
                  .verifyPhone(value, code);

              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Téléphone mis à jour avec succès'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text("Modifier Profil"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.red.shade50.withOpacity(0.55),
              Colors.green.shade50.withOpacity(0.30),
              Colors.blue.shade50.withOpacity(0.40),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: state.when(
          loading:
              () => const AppLoadingView(message: 'Chargement du profil...'),
          error:
              (e, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    "Erreur: $e",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          data: (user) {
            _init(user);

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      ProfileSectionCard(
                        title: "Informations personnelles",
                        icon: Icons.person_rounded,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nomController,
                              decoration: InputDecoration(
                                labelText: "Nom",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Le nom est obligatoire';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _prenomController,
                              decoration: InputDecoration(
                                labelText: "Prénom",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Le prénom est obligatoire';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _villeController,
                              decoration: InputDecoration(
                                labelText: "Ville",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _quartierController,
                              decoration: InputDecoration(
                                labelText: "Quartier",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      ProfileSectionCard(
                        title: "Coordonnées",
                        icon: Icons.contact_phone_rounded,
                        child: Column(
                          children: [
                            _contactTile(
                              icon: Icons.email_rounded,
                              title: "Email actuel",
                              value: user?.email ?? "Aucun email ajouté",
                            ),
                            const SizedBox(height: 12),
                            _contactTile(
                              icon: Icons.phone_rounded,
                              title: "Téléphone actuel",
                              value: user?.telephone ?? "--",
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      ProfileSectionCard(
                        title: "Actions de sécurité",
                        icon: Icons.verified_user_rounded,
                        child: Column(
                          children: [
                            ProfileActionButton(
                              text: "Changer / Ajouter un email",
                              icon: Icons.mark_email_read_rounded,
                              color: Colors.blue,
                              onPressed: _openEmailDialog,
                            ),
                            const SizedBox(height: 12),
                            ProfileActionButton(
                              text: "Changer le téléphone",
                              icon: Icons.phone_android_rounded,
                              color: Colors.green,
                              onPressed: _openPhoneDialog,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      ProfileActionButton(
                        text: "Enregistrer les modifications",
                        icon: Icons.save_rounded,
                        onPressed: _saving ? () {} : _saveProfile,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _contactTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.red.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
