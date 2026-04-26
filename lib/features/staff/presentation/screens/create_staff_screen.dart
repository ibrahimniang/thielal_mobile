import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/app_loading_view.dart';
import '../../application/staff_controller.dart';

class CreateStaffScreen extends ConsumerStatefulWidget {
  const CreateStaffScreen({super.key});

  @override
  ConsumerState<CreateStaffScreen> createState() => _CreateStaffScreenState();
}

class _CreateStaffScreenState extends ConsumerState<CreateStaffScreen> {
  final _formKey = GlobalKey<FormState>();

  final nomCtrl = TextEditingController();
  final prenomCtrl = TextEditingController();
  final telCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final villeCtrl = TextEditingController();
  final quartierCtrl = TextEditingController();
  final dateCtrl = TextEditingController();

  String? genre;
  bool _obscurePassword = true;

  @override
  void dispose() {
    nomCtrl.dispose();
    prenomCtrl.dispose();
    telCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    villeCtrl.dispose();
    quartierCtrl.dispose();
    dateCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initialDate = DateTime(now.year - 25, 1, 1);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: now,
      helpText: 'Choisir la date de naissance',
      cancelText: 'Annuler',
      confirmText: 'Valider',
    );

    if (picked != null) {
      final formatted =
          '${picked.year.toString().padLeft(4, '0')}-'
          '${picked.month.toString().padLeft(2, '0')}-'
          '${picked.day.toString().padLeft(2, '0')}';

      setState(() {
        dateCtrl.text = formatted;
      });
    }
  }

  void _resetForm() {
    nomCtrl.clear();
    prenomCtrl.clear();
    telCtrl.clear();
    emailCtrl.clear();
    passCtrl.clear();
    villeCtrl.clear();
    quartierCtrl.clear();
    dateCtrl.clear();

    setState(() {
      genre = null;
    });
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    if (genre == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez sélectionner le genre"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final controller = ref.read(staffControllerProvider.notifier);

    try {
      await controller.createStaff(
        nom: nomCtrl.text.trim(),
        prenom: prenomCtrl.text.trim(),
        genre: genre!,
        dateNaissance: dateCtrl.text.trim(),
        telephone: telCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        password: passCtrl.text.trim(),
        ville: villeCtrl.text.trim(),
        quartier: quartierCtrl.text.trim(),
      );

      if (!mounted) return;

      final state = ref.read(staffControllerProvider);

      state.actionStatus.whenOrNull(
        data: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Staff créé avec succès 🎉"),
              backgroundColor: Colors.green,
            ),
          );

          _resetForm();
        },
        error: (e, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
          );
        },
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }

  Widget _buildHeroCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.95),
                Colors.red.shade50.withOpacity(0.88),
                Colors.blue.shade50.withOpacity(0.76),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.78),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.08),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: Colors.blue.withOpacity(0.05),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.red.shade500, Colors.red.shade700],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.20),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person_add_alt_1_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                "Créer un compte staff",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                "Ajoutez un nouveau membre du staff avec ses informations principales.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  height: 1.45,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard(Widget child) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            color: Colors.white.withOpacity(0.84),
            border: Border.all(color: Colors.white.withOpacity(0.76)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
    bool obscure = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscure,
        readOnly: readOnly,
        onTap: onTap,
        validator:
            validator ??
            (v) => v == null || v.trim().isEmpty ? "Champ requis" : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          filled: true,
          fillColor: Colors.white,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  Widget _genreField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<String>(
        value: genre,
        items: const [
          DropdownMenuItem(value: "M", child: Text("Homme")),
          DropdownMenuItem(value: "F", child: Text("Femme")),
        ],
        onChanged: (value) => setState(() => genre = value),
        validator: (v) => v == null ? "Champ requis" : null,
        decoration: InputDecoration(
          labelText: "Genre",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(staffControllerProvider);
    final loading = state.actionStatus.isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text("Créer un staff"),
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
              Colors.blue.shade50.withOpacity(0.42),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child:
              loading && state.actionStatus.isLoading && false
                  ? const AppLoadingView(message: 'Création du staff...')
                  : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildHeroCard(),
                          const SizedBox(height: 22),
                          _buildFormCard(
                            Column(
                              children: [
                                _field(nomCtrl, "Nom"),
                                _field(prenomCtrl, "Prénom"),
                                _genreField(),
                                _field(
                                  dateCtrl,
                                  "Date de naissance",
                                  readOnly: true,
                                  onTap: _pickDate,
                                  suffixIcon: const Icon(
                                    Icons.calendar_month_rounded,
                                  ),
                                ),
                                _field(
                                  telCtrl,
                                  "Téléphone",
                                  keyboardType: TextInputType.phone,
                                ),
                                _field(
                                  emailCtrl,
                                  "Email",
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return "Champ requis";
                                    }
                                    if (!v.contains('@')) {
                                      return "Email invalide";
                                    }
                                    return null;
                                  },
                                ),
                                _field(
                                  passCtrl,
                                  "Mot de passe",
                                  obscure: _obscurePassword,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                  ),
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return "Champ requis";
                                    }
                                    if (v.trim().length < 6) {
                                      return "Minimum 6 caractères";
                                    }
                                    return null;
                                  },
                                ),
                                _field(villeCtrl, "Ville"),
                                _field(quartierCtrl, "Quartier"),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: loading ? null : _submit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      minimumSize: const Size(
                                        double.infinity,
                                        52,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child:
                                        loading
                                            ? const SizedBox(
                                              width: 22,
                                              height: 22,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2.4,
                                              ),
                                            )
                                            : const Text(
                                              "Créer Staff",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                  ),
                                ),
                              ],
                            ),
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
