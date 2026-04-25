import 'package:flutter/material.dart';
import 'app_heart_loader.dart';

class AppLoadingView extends StatelessWidget {
  final String? message;
  final double size;

  const AppLoadingView({super.key, this.message, this.size = 120});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppHeartLoader(size: size),
            if (message != null) ...[
              const SizedBox(height: 18),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
