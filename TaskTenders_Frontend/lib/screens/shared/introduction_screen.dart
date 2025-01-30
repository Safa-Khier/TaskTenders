import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:tasktender_frontend/routes/app_router.gr.dart';
import 'package:tasktender_frontend/utils/app_gradients.dart';
import 'package:tasktender_frontend/widgets/main_button.dart';
import 'package:tasktender_frontend/widgets/primary_text_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

@RoutePage()
class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class IntroPageData {
  final String title;
  final String description;
  final String imagePathLight;
  final String imagePathDark;

  IntroPageData(
      {required this.title,
      required this.description,
      required this.imagePathLight,
      required this.imagePathDark});
}

class _IntroScreenState extends State<IntroScreen> {
  // 1. Define a `GlobalKey` as part of the parent widget's state
  final _introKey = GlobalKey<IntroductionScreenState>();
  int _currentPageIndex = 0; // State variable to track page index

  // data array of the screens: title, description and image
  List<IntroPageData> getPageData(AppLocalizations translator) {
    return [
      IntroPageData(
          title: translator.jobTitle,
          description: translator.jobDescription,
          imagePathLight: 'lib/assets/introduction_screen/intro_job_light.png',
          imagePathDark: 'lib/assets/introduction_screen/intro_job_dark.png'),
      IntroPageData(
          title: translator.biddingTitle,
          description: translator.biddingDescription,
          imagePathLight:
              'lib/assets/introduction_screen/intro_bidding_light.png',
          imagePathDark:
              'lib/assets/introduction_screen/intro_bidding_dark.png'),
      IntroPageData(
          title: translator.paymentTitle,
          description: translator.paymentDescription,
          imagePathLight:
              'lib/assets/introduction_screen/intro_secure_light.png',
          imagePathDark:
              'lib/assets/introduction_screen/intro_secure_dark.png'),
      IntroPageData(
          title: translator.encryptionTitle,
          description: translator.encryptionDescription,
          imagePathLight:
              'lib/assets/introduction_screen/intro_encryption_light.png',
          imagePathDark:
              'lib/assets/introduction_screen/intro_encryption_dark.png'),
      IntroPageData(
          title: translator.aiTitle,
          description: translator.aiDescription,
          imagePathLight: 'lib/assets/introduction_screen/intro_ai_light.png',
          imagePathDark: 'lib/assets/introduction_screen/intro_ai_dark.png'),
    ];
  }

  List<PageViewModel> getPages(
      BuildContext context, AppLocalizations translator) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return getPageData(translator).map((page) {
      return PageViewModel(
        titleWidget:
            Container(), // Use an empty Container if the title is not needed.
        bodyWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 75),
            Image.asset(isDark ? page.imagePathDark : page.imagePathLight,
                width: 300),
            // const SizedBox(height: 75),
            ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  page.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                )),
            const SizedBox(height: 25),
            Text(
              page.description,
              style: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? const Color(0xFFC1C1C1)
                      : const Color(0xFF3A4F66)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildGlobalHeader(BuildContext context, AppLocalizations translator) {
    if (_currentPageIndex != getPageData(translator).length - 1) {
      return Align(
        alignment: Alignment.centerRight,
        child: Row(
          // Ensure the row takes the size of its children
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            PrimaryTextButton(
                onPressed: () {
                  _onIntroEnd(context);
                },
                text: 'Skip',
                baseColor: Theme.of(context).colorScheme.primary,
                pressedColor: Theme.of(context).colorScheme.secondary,
                textSize: 16,
                trailingIconData: Icons.arrow_forward_ios)
          ],
        ),
      );
    } else {
      // Optionally, return an empty widget when on the last page
      return const SizedBox.shrink();
    }
  }

  Widget _buildGlobalFooter(BuildContext context, AppLocalizations translator) {
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(30, 0, 30, 0),
        child: MainButton(
            context: context,
            onPressed: () {
              if (_currentPageIndex < getPageData(translator).length - 1) {
                // Advance to the next page
                _introKey.currentState?.animateScroll(_currentPageIndex + 1);
                setState(() {
                  _currentPageIndex++;
                });
              } else {
                // Last page 'Done' action
                _onIntroEnd(context);
              }
            },
            text: _currentPageIndex == getPageData(translator).length - 1
                ? 'Done'
                : 'Next'));
  }

  @override
  Widget build(BuildContext context) {
    final translator = AppLocalizations.of(context)!;
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
            child: IntroductionScreen(
              key: _introKey,
              globalBackgroundColor: Colors.transparent,
              pages: getPages(context, translator),
              showNextButton: false,
              showDoneButton: false,
              globalFooter: _buildGlobalFooter(context, translator),
              globalHeader: _buildGlobalHeader(context, translator),
              onChange: (index) => setState(() {
                _currentPageIndex =
                    index; // Update current page index on page change
              }),
              dotsDecorator: DotsDecorator(
                activeColor: Theme.of(context).colorScheme.primary,
                size: const Size(7.34, 4.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                activeSize: const Size(20.0, 4.2),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                spacing: const EdgeInsets.symmetric(horizontal: 4.0),
              ),
              // next button on the bottom of the screen
            ),
          ),
        ),
      ),
    );
  }

  void _onIntroEnd(BuildContext context) {
    context.router.replace(WelcomeRoute());
  }
}
