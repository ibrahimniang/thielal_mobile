import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/profile_controller.dart';
import '../../data/models/profile_model.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _nom = TextEditingController();
  final _prenom = TextEditingController();

  bool _initialized = false;

  void _init(ProfileModel? user) {
    if (_initialized || user == null) return;

    _nom.text = user.nom ?? '';
    _prenom.text = user.prenom ?? '';
    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Modifier Profil")),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (e, _) => Center(child: Text("Erreur: $e")),

        data: (user) {
          _init(user);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _nom,
                  decoration: const InputDecoration(labelText: "Nom"),
                ),
                TextField(
                  controller: _prenom,
                  decoration: const InputDecoration(labelText: "Prénom"),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () async {
                    await ref
                        .read(profileControllerProvider.notifier)
                        .updateProfile(nom: _nom.text, prenom: _prenom.text);

                    if (mounted) Navigator.pop(context);
                  },
                  child: const Text("Enregistrer"),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () => _showEmailModal(context),
                  child: const Text("Changer Email"),
                ),

                ElevatedButton(
                  onPressed: () => _showPhoneModal(context),
                  child: const Text("Changer Téléphone"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ================= EMAIL =================

  void _showEmailModal(BuildContext context) {
    final emailCtrl = TextEditingController();
    final codeCtrl = TextEditingController();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Changer Email"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                TextField(
                  controller: codeCtrl,
                  decoration: const InputDecoration(labelText: "Code OTP"),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  await ref
                      .read(profileControllerProvider.notifier)
                      .requestEmail(emailCtrl.text);
                },
                child: const Text("Envoyer code"),
              ),
              TextButton(
                onPressed: () async {
                  await ref
                      .read(profileControllerProvider.notifier)
                      .verifyEmail(emailCtrl.text, codeCtrl.text);

                  Navigator.pop(context);
                },
                child: const Text("Valider"),
              ),
            ],
          ),
    );
  }

  // ================= PHONE =================

  void _showPhoneModal(BuildContext context) {
    final phoneCtrl = TextEditingController();
    final codeCtrl = TextEditingController();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Changer Téléphone"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: phoneCtrl,
                  decoration: const InputDecoration(labelText: "Téléphone"),
                ),
                TextField(
                  controller: codeCtrl,
                  decoration: const InputDecoration(labelText: "Code OTP"),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  await ref
                      .read(profileControllerProvider.notifier)
                      .requestPhone(phoneCtrl.text);
                },
                child: const Text("Envoyer code"),
              ),
              TextButton(
                onPressed: () async {
                  await ref
                      .read(profileControllerProvider.notifier)
                      .verifyPhone(phoneCtrl.text, codeCtrl.text);

                  Navigator.pop(context);
                },
                child: const Text("Valider"),
              ),
            ],
          ),
    );
  }
}
