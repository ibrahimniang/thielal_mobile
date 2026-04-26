import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _valueController,
            keyboardType: widget.keyboardType,
            decoration: InputDecoration(labelText: widget.valueLabel),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _codeController,
            decoration: const InputDecoration(labelText: 'Code OTP'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed:
              _loadingRequest
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
          child:
              _loadingRequest
                  ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : const Text('Envoyer code'),
        ),
        ElevatedButton(
          onPressed:
              _loadingVerify
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
          child:
              _loadingVerify
                  ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : const Text('Valider'),
        ),
      ],
    );
  }
}
