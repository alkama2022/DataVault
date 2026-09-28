import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_colors.dart';
import '../config/app_strings.dart';
import '../providers/auth_provider.dart';
import '../services/storage_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/onboarding_illustration.dart';

/// Three-page onboarding with illustrations, page indicator and
/// Skip / Next / Get Started controls.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  static const List<({String title, String body})> _pages = [
    (
      title: 'Buy Data in Seconds',
      body: 'Quickly purchase affordable data bundles for your preferred network.',
    ),
    (
      title: 'Simple. Fast. Secure.',
      body: 'Experience secure payments, instant processing, and easy transaction tracking.',
    ),
    (
      title: 'Everything You Need to Stay Connected',
      body: 'Access data, airtime, wallet, transaction history, and other essential services.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final storage = await StorageService.instance;
    await storage.setOnboardingSeen(true);
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/login');
  }

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    } else {
      _finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentPage == _pages.length - 1;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
                child: TextButton(
                  onPressed: _finish,
                  child: const Text(
                    AppStrings.skip,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, i) {
                  final title = _pages[i].title;
                  final body = _pages[i].body;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 5,
                          child: OnboardingIllustration(variant: i),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              const SizedBox(height: 12),
                              Text(
                                title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                  height: 1.25,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                body,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: AppColors.textSecondary,
                                  height: 1.55,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (i) {
                final active = i == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 26 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active ? AppColors.primary : AppColors.disabled,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 28),
            // CTA
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
              child: CustomButton(
                label: isLast ? AppStrings.getStarted : AppStrings.next,
                onPressed: _next,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
