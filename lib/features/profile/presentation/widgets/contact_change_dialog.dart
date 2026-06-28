import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';

class ContactChangeDialog extends ConsumerStatefulWidget {
  final String title;
  final String valueLabel;
  final TextInputType keyboardType;
  final Future<void> Function(WidgetRef ref, String value) onRequestCode;
  final Future<void> Function(WidgetRef ref, String value, String code)
      onVerify;

  const ContactChangeDialog({
    super.key,
    required this.title,
    required this.valueLabel,
    required this.keyboardType,
    required this.onRequestCode,
    required this.onVerify,
  });

  @override
  ConsumerState<ContactChangeDialog> createState() =>
      _ContactChangeDialogState();
}

class _ContactChangeDialogState extends ConsumerState<ContactChangeDialog> {
  final _valueController = TextEditingController();
  final _codeController = TextEditingController();

  bool _loadingRequest = false;
  bool _loadingVerify = false;

  @override
  void dispose() {
    _valueController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: isDark ? colors.surface : Colors.white,

      title: Text(
        widget.title,
        style: TextStyle(
          color: colors.onSurface,
          fontWeight: FontWeight.w800,
        ),
      ),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _valueController,
            keyboardType: widget.keyboardType,
            style: TextStyle(color: colors.onSurface),

            decoration: InputDecoration(
              labelText: widget.valueLabel,
              labelStyle: TextStyle(
                color: colors.onSurface.withOpacity(0.7),
              ),
              filled: true,
              fillColor:
                  isDark ? colors.surfaceContainerHighest : Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: _codeController,
            style: TextStyle(color: colors.onSurface),

            decoration: InputDecoration(
              labelText: l10n.otpCode,
              labelStyle: TextStyle(
                color: colors.onSurface.withOpacity(0.7),
              ),
              filled: true,
              fillColor:
                  isDark ? colors.surfaceContainerHighest : Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),

      actions: [
        TextButton(
          onPressed: _loadingRequest
              ? null
              : () async {
                  final value = _valueController.text.trim();
                  if (value.isEmpty) return;

                  setState(() => _loadingRequest = true);
                  try {
                    await widget.onRequestCode(ref, value);
                  } finally {
                    if (mounted) {
                      setState(() => _loadingRequest = false);
                    }
                  }
                },

          child: _loadingRequest
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.sendCode),
        ),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          onPressed: _loadingVerify
              ? null
              : () async {
                  final value = _valueController.text.trim();
                  final code = _codeController.text.trim();
                  if (value.isEmpty || code.isEmpty) return;

                  setState(() => _loadingVerify = true);
                  try {
                    await widget.onVerify(ref, value, code);
                    if (mounted) Navigator.pop(context);
                  } finally {
                    if (mounted) {
                      setState(() => _loadingVerify = false);
                    }
                  }
                },

          child: _loadingVerify
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.validate),
        ),
      ],
    );
  }
}