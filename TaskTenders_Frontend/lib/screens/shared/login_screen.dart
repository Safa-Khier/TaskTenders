import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tasktender_frontend/routes/app_router.gr.dart';
import 'package:tasktender_frontend/services/locator.service.dart';
import 'package:tasktender_frontend/services/toast.service.dart';
import 'package:tasktender_frontend/services/user.service.dart';
import 'package:tasktender_frontend/utils/app_gradients.dart';
import 'package:tasktender_frontend/widgets/image_button.dart';
import 'package:tasktender_frontend/widgets/main_button.dart';
import 'package:tasktender_frontend/widgets/main_input.dart';
import 'package:tasktender_frontend/widgets/primary_text_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:toastification/toastification.dart' hide ToastificationItem;

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userService = locator<UserService>();
  final toastService = locator<ToastService>();

  final TextEditingController _emailController =
      TextEditingController(text: 'safakhier@gmail.com');
  final TextEditingController _passwordController =
      TextEditingController(text: '123456');

  void _signIn() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      toastService.showToast(
        context,
        ToastificationItem(
          type: ToastificationType.warning,
          style: ToastificationStyle.flatColored,
          duration: const Duration(seconds: 3),
          description: RichText(
            text: TextSpan(
              text: AppLocalizations.of(context)!.emptyFieldsError,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
      );
      return;
    }
    userService
        .loginUser(context, _emailController.text, _passwordController.text)
        .onError((error, stackTrace) {
      toastService.showToast(
        context,
        ToastificationItem(
          type: ToastificationType.error,
          style: ToastificationStyle.flatColored,
          duration: const Duration(seconds: 3),
          description: RichText(
            text: TextSpan(
              text: error.toString(),
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 30),
          child: Center(
            child: SingleChildScrollView(
              // Add this widget
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome,',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00CED1),
                    ),
                  ),
                  const Text(
                    'Glad to see you!',
                    style: TextStyle(
                      fontSize: 24,
                      color: Color(0xFF00CED1),
                    ),
                  ),
                  const SizedBox(height: 55),
                  MainInput(
                    hintText: 'Email',
                    initialValue: 'safakhier@gmail.com',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    color: const Color(0xFF00CED1),
                  ),
                  const SizedBox(height: 15),
                  MainInput(
                    isPassword: true,
                    hintText: 'Password',
                    initialValue: '123456',
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    color: const Color(0xFF00CED1),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      PrimaryTextButton(
                        onPressed: () {},
                        text: 'Forgot your password?',
                        baseColor: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  MainButton(
                    context: context,
                    text: AppLocalizations.of(context)!.login,
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      _signIn();
                    },
                  ),
                  // const SizedBox(height: 20),
                  // Row(
                  //   children: <Widget>[
                  //     Expanded(
                  //       child: Container(
                  //         margin: const EdgeInsets.only(right: 10.0),
                  //         child: Divider(
                  //           color: Theme.of(context).primaryColor,
                  //           height: 50,
                  //           thickness: 1,
                  //         ),
                  //       ),
                  //     ),
                  //     Text(
                  //       'Or Log In Using',
                  //       style: TextStyle(
                  //         color: Theme.of(context).primaryColor,
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: Container(
                  //         margin: const EdgeInsets.only(left: 10.0),
                  //         child: Divider(
                  //           color: Theme.of(context).primaryColor,
                  //           height: 50,
                  //           thickness: 1,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 50),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     ImageButton(
                  //       context: context,
                  //       onPressed: () {},
                  //       imagePath: 'lib/assets/external_images/apple_logo.png',
                  //     ),
                  //     const SizedBox(width: 25),
                  //     ImageButton(
                  //       context: context,
                  //       onPressed: () {},
                  //       imagePath: 'lib/assets/external_images/google_logo.png',
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      PrimaryTextButton(
                        onPressed: () {
                          context.router.replace(SignUpRoute());
                        },
                        text: 'Sign Up Now',
                        baseColor: const Color(0xFF00CED1),
                        pressedColor: const Color(0xFF3A4F66),
                      ),
                    ],
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
