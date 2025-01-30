import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tasktender_frontend/routes/app_router.gr.dart';
import 'package:tasktender_frontend/utils/app_gradients.dart';
import 'package:tasktender_frontend/widgets/main_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

@RoutePage()
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final translator = AppLocalizations.of(context)!;
    return Scaffold(
        body: GradientBackground(
            child: Center(
      child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 30),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            // const Image(
            //     image: AssetImage('lib/assets/tasktenders_logo.png'),
            //     width: 200),
            Text(
              translator.appName,
              style: TextStyle(
                fontSize: 31.0,
                color: Color(0xFF00CED1),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 150),
            MainButton(
                context: context,
                onPressed: () {
                  // Navigator.pushNamed(context, '/login');
                  context.router.push(LoginRoute());
                },
                text: translator.login),
            const SizedBox(height: 20),
            MainButton(
                context: context,
                isOutlined: true,
                onPressed: () {
                  context.router.push(SignUpRoute());
                },
                text: translator.signUp),
          ])),
    )));
  }
}
