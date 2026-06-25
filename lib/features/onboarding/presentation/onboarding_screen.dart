import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../data/onboarding_data.dart';
import '../widgets/onboarding_button.dart';
import '../widgets/onboarding_indicator.dart';
import '../widgets/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState
    extends State<OnboardingScreen> {
  final PageController _controller = PageController();

  int currentPage = 0;

  Future<void> _finishOnboarding() async {
    await SecureStorageService.setHasSeenOnboarding(true);

    if (!mounted) return;

    context.go(RouteNames.entryIdentity);
  }

@override
void dispose() {
  _controller.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: onboardingItems.length,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemBuilder: (_, index) {
              return OnboardingPage(
                item: onboardingItems[index],
              );
            },
          ),

         Positioned(
  top: 55,
  right: 20,
  child: Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: TextButton(
      onPressed: _finishOnboarding,
      child: const Text(
        'Passer',
        style: TextStyle(
          color: Colors.red,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  ),
),

          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                OnboardingIndicator(
                  currentPage: currentPage,
                  itemCount: onboardingItems.length,
                ),

                OnboardingButton(
                  text: currentPage ==
                          onboardingItems.length - 1
                      ? 'Commencer'
                      : 'Suivant',
                  onPressed: () {
                    if (currentPage <
                        onboardingItems.length - 1) {
                      _controller.nextPage(
                        duration: const Duration(
                          milliseconds: 300,
                        ),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      _finishOnboarding();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}