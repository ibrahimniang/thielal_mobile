import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../application/auth_controller.dart';
import '../../../../l10n/app_localizations.dart';

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

  String? _genreUiValue;
  String? _selectedBloodGroup;

  bool _accepteConditions = false;
  bool _acceptePolitique = false;
  bool? _aDonneRecemment;

  double? _latitude;
  double? _longitude;
  bool _isFetchingLocation = false;

  static const List<String> _bloodGroups = [
    'O+',
    'O-',
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
  ];

  /// ==========================================
/// VILLES + QUARTIERS
/// ==========================================

final Map<String, List<String>> mauritaniaLocations = {
  "Nouakchott": [
    "Tevragh Zeina",
    "Ksar",
    "Sebkha",
    "El Mina",
    "Arafat",
    "Riyadh",
    "Dar Naim",
    "Toujounine",
    "Teyarett",
  ],
  "Nouadhibou": ["Cansado", "Numerowat", "Baghdad"],
  "Rosso": ["Escale", "Satara", "Medina"],
  "Kaedi": ["Moderne", "Touldé", "Gurel"],
  "Kiffa": ["Bellewar", "Siyassa", "Moughataa"],
  "Selibaby": ["Collège", "Silo", "Quartier Administratif", "Medina"],
  "Atar": ["Atar Centre", "Tiyaret", "Extention"],
  "Zouerate": ["Ksar", "Robinet", "Centre"],
  "Aioun": ["Centre", "Medina"],
  "Nema": ["Centre", "Jedida"],
  "Aleg": ["Centre", "Jedida"],
  "Akjoujt": ["Centre", "Ancien Quartier"],
  "Tidjikja": ["Centre", "Moughataa"],
  "Boghé": ["Centre", "Wendou"],
  "Boutilimit": ["Centre", "Ancien Quartier"],
};

String? _selectedVille;

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
    final l10n = AppLocalizations.of(context)!;
    switch (_step) {
      case 1:
        return l10n.personalInformation;
      case 2:
        return l10n.addressContact;
      case 3:
        return l10n.healthConsent;
      default:
        return '';
    }
  }

  String _stepSubtitle() {
    final l10n = AppLocalizations.of(context)!;
    switch (_step) {
      case 1:
        return l10n.personalInformationDescription;
      case 2:
        return l10n.addressContactDescription;
      case 3:
        return l10n.healthConsentDescription;
      default:
        return '';
    }
  }

  Future<void> _pickBirthDate() async {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final initialDate = DateTime(now.year - 18, 1, 1);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1940),
      lastDate: now,
      helpText: l10n.chooseBirthDate,
      cancelText: l10n.cancel,
      confirmText: l10n.validate,
    );

    if (picked != null) {
      final formatted =
          '${picked.year.toString().padLeft(4, '0')}-'
          '${picked.month.toString().padLeft(2, '0')}-'
          '${picked.day.toString().padLeft(2, '0')}';

      setState(() {
        _dateNaissanceController.text = formatted;
      });
    }
  }

  Future<void> _selectBloodGroup() async {
    final l10n = AppLocalizations.of(context)!;
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                l10n.chooseBloodGroup,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children:
                    _bloodGroups.map((group) {
                      final isSelected = _selectedBloodGroup == group;
                      return GestureDetector(
                        onTap: () => Navigator.pop(context, group),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            gradient:
                                isSelected
                                    ? LinearGradient(
                                      colors: [
                                        Colors.red.shade500,
                                        Colors.red.shade700,
                                      ],
                                    )
                                    : null,
                            color: isSelected ? null : Colors.red.shade50,
                            border: Border.all(
                              color:
                                  isSelected
                                      ? Colors.transparent
                                      : Colors.red.shade100,
                            ),
                          ),
                          child: Text(
                            group,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color:
                                  isSelected
                                      ? Colors.white
                                      : Colors.red.shade700,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        _selectedBloodGroup = selected;
        _groupeSanguinController.text = selected;
      });
    }
  }

  Future<bool> _confirmBloodGroup() async {
    final l10n = AppLocalizations.of(context)!;
    final group = _groupeSanguinController.text.trim();

    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(l10n.confirmation),
              content: Text(
                group.isEmpty
                    ? l10n.confirmWithoutBloodGroup
                    : '${l10n.confirmBloodGroup} : $group ?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(l10n.cancel),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(l10n.confirm),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<Position> _determinePosition() async {
    final l10n = AppLocalizations.of(context)!;
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception(l10n.gpsDisabled);
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        throw Exception(l10n.locationDenied);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(l10n.locationDeniedForever);
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> _fetchCurrentLocation() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      setState(() {
        _isFetchingLocation = true;
      });

      final position = await _determinePosition();

      if (!mounted) return;

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _isFetchingLocation = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${l10n.locationRetrieved} : ${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isFetchingLocation = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n.locationUnavailable} : $e')),
      );
    }
  }

  Future<void> _submitStep() async {
    final l10n = AppLocalizations.of(context)!;
    final authCtrl = ref.read(authControllerProvider.notifier);

    if (_step == 1) {
      final isValid = _formKey.currentState?.validate() ?? false;
      if (!isValid) return;
      /// ======================================
/// AGE VALIDATION
/// ======================================

if (_dateNaissanceController
    .text
    .trim()
    .isNotEmpty) {
  final birthDate = DateTime.parse(
    _dateNaissanceController.text.trim(),
  );

  final today = DateTime.now();

  int age =
      today.year -
      birthDate.year;

  if (today.month <
          birthDate.month ||
      (today.month ==
              birthDate.month &&
          today.day <
              birthDate.day)) {
    age--;
  }

  /// minimum 18 ans
  if (age < 18) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        backgroundColor:
            Colors.red.shade600,

        content: const Text(
          'Vous devez avoir au moins 18 ans pour créer un compte LifeLink.',
        ),
      ),
    );

    return;
  }
}

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
      if (_latitude == null || _longitude == null) {
        await _fetchCurrentLocation();
      }

      await authCtrl.registerStep2(
        ville:
            _villeController.text.trim().isEmpty
                ? null
                : _villeController.text.trim(),
        quartier:
            _quartierController.text.trim().isEmpty
                ? null
                : _quartierController.text.trim(),
        latitude: _latitude,
        longitude: _longitude,
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
           SnackBar(content: Text(l10n.recentDonationQuestionError)),
        );
        return;
      }

      if (!_accepteConditions || !_acceptePolitique) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(l10n.acceptConditionsError)),
        );
        return;
      }

      final confirmed = await _confirmBloodGroup();
      if (!confirmed) return;

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
    required VoidCallback onTap,
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
       title: GestureDetector(
        onTap: onTap,
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
        activeColor: accent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }

  Widget _buildStep1() {
    final l10n = AppLocalizations.of(context)!;
    return _buildSectionCard(
      child: Column(
        children: [
          CustomTextField(
            controller: _nomController,
            hintText: l10n.lastName,
            labelText: l10n.lastName,
            validator:
                (value) =>
                    Validators.requiredField(value, fieldName: l10n.lastName),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _prenomController,
            hintText: l10n.firstName,
            labelText: l10n.firstName,
            validator:
                (value) =>
                    Validators.requiredField(value, fieldName: l10n.firstName),
          ),
          const SizedBox(height: 18),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              l10n.gender,
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
                label: l10n.male,
                selected: _genreUiValue == l10n.male,
                onTap: () => setState(() => _genreUiValue = l10n.male),
                colors: [Colors.blue.shade500, Colors.blue.shade700],
                icon: Icons.male_rounded,
              ),
              const SizedBox(width: 12),
              _buildChoiceChip(
                label: l10n.female,
                selected: _genreUiValue == l10n.female,
                onTap: () => setState(() => _genreUiValue = l10n.female),
                colors: [Colors.red.shade400, Colors.red.shade600],
                icon: Icons.female_rounded,
              ),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _pickBirthDate,
            child: AbsorbPointer(
              child: CustomTextField(
                controller: _dateNaissanceController,
                hintText: l10n.chooseDate,
                labelText: l10n.birthDate,
                suffixIcon: const Icon(Icons.calendar_month_rounded),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    final l10n = AppLocalizations.of(context)!;
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
                        : l10n.phoneRecoveredOtp,
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
          DropdownButtonFormField<String>(
  value: _selectedVille,

  decoration: InputDecoration(
    labelText: l10n.city,
    hintText: l10n.city,
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
    ),
  ),

  items: mauritaniaLocations.keys.map((ville) {
    return DropdownMenuItem(
      value: ville,
      child: Text(ville),
    );
  }).toList(),

  onChanged: (value) {
    setState(() {
      _selectedVille = value;
      _villeController.text = value ?? "";

      /// reset quartier
      _quartierController.clear();
    });
  },
),

const SizedBox(height: 16),

DropdownButtonFormField<String>(
  value: _quartierController.text.isEmpty
      ? null
      : _quartierController.text,

  decoration: InputDecoration(
    labelText: l10n.district,
    hintText: l10n.district,
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
    ),
  ),

  items: (_selectedVille != null
          ? mauritaniaLocations[_selectedVille]!
          : <String>[])
      .map((quartier) {
    return DropdownMenuItem(
      value: quartier,
      child: Text(quartier),
    );
  }).toList(),

  onChanged: _selectedVille == null
      ? null
      : (value) {
          setState(() {
            _quartierController.text = value ?? "";
          });
        },
),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _isFetchingLocation ? null : _fetchCurrentLocation,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon:
                  _isFetchingLocation
                      ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2.2),
                      )
                      : const Icon(Icons.my_location_rounded),
              label: Text(
                _latitude != null && _longitude != null
                    ? l10n.locationRetrieved
                    : l10n.useMyLocation,
              ),
            ),
          ),
          if (_latitude != null && _longitude != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green.shade100),
              ),
              child: Text(
                '${l10n.latitude} : ${_latitude!.toStringAsFixed(5)}'
                '${l10n.longitude} : ${_longitude!.toStringAsFixed(5)}',
                style: TextStyle(
                  color: Colors.green.shade800,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBloodGroupSelector() {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: _selectBloodGroup,
      child: AbsorbPointer(
        child: CustomTextField(
          controller: _groupeSanguinController,
          hintText: l10n.chooseBloodGroupHint,
          labelText: l10n.bloodGroup,
          suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
        ),
      ),
    );
  }

  Widget _buildStep3() {
    final l10n = AppLocalizations.of(context)!;
    return _buildSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBloodGroupSelector(),
          const SizedBox(height: 22),
          Text(
            l10n.recentDonationQuestion,
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
                label: l10n.yes,
                selected: _aDonneRecemment == true,
                onTap: () => setState(() => _aDonneRecemment = true),
                colors: [Colors.green.shade500, Colors.green.shade700],
                icon: Icons.check_circle_rounded,
              ),
              const SizedBox(width: 12),
              _buildChoiceChip(
                label: l10n.no,
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
            title: l10n.acceptConditions,
            accent: Colors.red.shade600,
            onTap: () {
              context.push(RouteNames.terms);
            },
          ),
          _buildConsentTile(
            value: _acceptePolitique,
            onChanged: (value) {
              setState(() => _acceptePolitique = value ?? false);
            },
            title: l10n.acceptPrivacy,
            accent: Colors.blue.shade600,
            onTap: () {
              context.push(RouteNames.privacy);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isLoading) {
    final l10n = AppLocalizations.of(context)!;
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
              child: Text(l10n.back),
            ),
          ),
        if (_step > 1) const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: CustomButton(
            text: _step == 3 ? l10n.finish : l10n.continueText,
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: Text(l10n.register),
        elevation: 0,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
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
