import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/profile_controller.dart';
import '../../data/models/profile_model.dart';
import '../widgets/profile_section_card.dart';
import '../widgets/profile_action_button.dart';
import '../widgets/contact_change_dialog.dart';
import '../../../../shared/widgets/app_loading_view.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:thielal/core/constants/mauritania_locations.dart';

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

  String? _selectedVille;

  bool _initialized = false;
  bool _saving = false;

  void _init(ProfileModel? user) {
    if (_initialized || user == null) return;

    _nomController.text = user.nom ?? '';
    _prenomController.text = user.prenom ?? '';

    final ville = user.ville?.trim();

    _selectedVille =
        (ville != null && mauritaniaLocations.containsKey(ville))
            ? ville
            : null;

    _villeController.text = _selectedVille ?? '';
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
    final l10n = AppLocalizations.of(context)!;
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
        SnackBar(
          content: Text(l10n.profileUpdatedSuccessfully),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.profileUpdateError),
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
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (_) => ContactChangeDialog(
        title: l10n.changeAddEmail,
        valueLabel: l10n.email,
        keyboardType: TextInputType.emailAddress,
        onRequestCode: (ref, value) async {
          await ref
              .read(profileControllerProvider.notifier)
              .requestEmail(value);

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.codeSentByEmail),
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
            SnackBar(
              content: Text(l10n.emailUpdatedSuccessfully),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  void _openPhoneDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (_) => ContactChangeDialog(
        title: l10n.changePhone,
        valueLabel: l10n.phone,
        keyboardType: TextInputType.phone,
        onRequestCode: (ref, value) async {
          await ref
              .read(profileControllerProvider.notifier)
              .requestPhone(value);

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.codeSentBySms),
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
            SnackBar(
              content: Text(l10n.phoneUpdatedSuccessfully),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(profileControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: Text(l10n.editProfile),
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
          loading: () => AppLoadingView(message: l10n.loadingProfile),
          error: (e, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                "${l10n.error}: $e",
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
                        title: l10n.personalInformation,
                        icon: Icons.person_rounded,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nomController,
                              decoration: InputDecoration(
                                labelText: l10n.lastName,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _prenomController,
                              decoration: InputDecoration(
                                labelText: l10n.firstName,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),

                            /// VILLE (FIX SAFE)
                            DropdownButtonFormField<String>(
                              value: (mauritaniaLocations.keys
                                      .contains(_selectedVille))
                                  ? _selectedVille
                                  : null,
                              items: mauritaniaLocations.keys
                                  .map((v) => DropdownMenuItem(
                                        value: v,
                                        child: Text(v),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedVille = value;
                                  _villeController.text = value ?? '';
                                  _quartierController.clear();
                                });
                              },
                              decoration: InputDecoration(
                                labelText: l10n.city,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 16),

                            /// QUARTIER (FIX SAFE)
                            DropdownButtonFormField<String>(
                              value: (_selectedVille != null &&
                                      mauritaniaLocations[_selectedVille!]!
                                          .contains(_quartierController.text))
                                  ? _quartierController.text
                                  : null,
                              items: (_selectedVille != null)
                                  ? mauritaniaLocations[_selectedVille!]!
                                      .map((q) => DropdownMenuItem(
                                            value: q,
                                            child: Text(q),
                                          ))
                                      .toList()
                                  : [],
                              onChanged: (value) {
                                setState(() {
                                  _quartierController.text = value ?? '';
                                });
                              },
                              decoration: InputDecoration(
                                labelText: l10n.district,
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
                        title: l10n.contactDetails,
                        icon: Icons.contact_phone_rounded,
                        child: Column(
                          children: [
                            _contactTile(
                              icon: Icons.email_rounded,
                              title: l10n.currentEmail,
                              value: user?.email ?? l10n.noEmailAdded,
                            ),
                            const SizedBox(height: 12),
                            _contactTile(
                              icon: Icons.phone_rounded,
                              title: l10n.currentPhone,
                              value: user?.telephone ?? "--",
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      ProfileSectionCard(
                        title: l10n.securityActions,
                        icon: Icons.verified_user_rounded,
                        child: Column(
                          children: [
                            ProfileActionButton(
                              text: l10n.changeAddEmail,
                              icon: Icons.mark_email_read_rounded,
                              color: Colors.blue,
                              onPressed: _openEmailDialog,
                            ),
                            const SizedBox(height: 12),
                            ProfileActionButton(
                              text: l10n.changePhone,
                              icon: Icons.phone_android_rounded,
                              color: Colors.green,
                              onPressed: _openPhoneDialog,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      ProfileActionButton(
                        text: l10n.saveChanges,
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
          Expanded(child: Text(title)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}