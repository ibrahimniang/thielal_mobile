import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/staff_controller.dart';

class VerifyBloodGroupModal extends ConsumerStatefulWidget {
  const VerifyBloodGroupModal({super.key});

  @override
  ConsumerState<VerifyBloodGroupModal> createState() =>
      _VerifyBloodGroupModalState();
}

class _VerifyBloodGroupModalState extends ConsumerState<VerifyBloodGroupModal> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();

  String? _selectedBloodGroup;

  final List<String> _bloodGroups = const [
    'O+',
    'O-',
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
  ];

  @override
  void dispose() {
    _userIdController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final userId = int.tryParse(_userIdController.text.trim());

    if (userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('ID utilisateur invalide')));
      return;
    }

    if (_selectedBloodGroup == null || _selectedBloodGroup!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez choisir un groupe sanguin')),
      );
      return;
    }

    await ref
        .read(staffControllerProvider.notifier)
        .verifyBloodGroup(userId: userId, groupeSanguin: _selectedBloodGroup!);

    if (!mounted) return;

    final state = ref.read(staffControllerProvider);

    state.actionStatus.whenOrNull(
      data: (_) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Groupe sanguin vérifié avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      },
      error: (e, _) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(staffControllerProvider);
    final isLoading = state.actionStatus.isLoading;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.verified_rounded, color: Colors.red, size: 40),
              const SizedBox(height: 12),
              const Text(
                'Vérifier le groupe sanguin',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 18),

              TextFormField(
                controller: _userIdController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Veuillez entrer l’ID utilisateur';
                  }
                  if (int.tryParse(value.trim()) == null) {
                    return 'ID invalide';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'ID utilisateur',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedBloodGroup,
                items:
                    _bloodGroups
                        .map(
                          (group) => DropdownMenuItem(
                            value: group,
                            child: Text(group),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBloodGroup = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez choisir un groupe sanguin';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Groupe sanguin validé',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed:
                          isLoading ? null : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('Annuler'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child:
                          isLoading
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.3,
                                ),
                              )
                              : const Text(
                                'Valider',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
