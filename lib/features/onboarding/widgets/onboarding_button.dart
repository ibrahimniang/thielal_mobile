import 'package:flutter/material.dart';

class OnboardingButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const OnboardingButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
   return SizedBox(
  width: text == 'Suivant' ? 55 : 140,
  height: 55,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.red,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          text == 'Suivant' ? 30 : 15,
        ),
      ),
    ),
    onPressed: onPressed,
    child: text == 'Suivant'
        ? const Icon(
            Icons.arrow_forward_rounded,
            color: Colors.white,
            size: 28,
          )
        : Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
  ),
);
  }
}