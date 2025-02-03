import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tasktender_frontend/routes/app_router.gr.dart';
import 'package:tasktender_frontend/services/locator.service.dart';
import 'package:tasktender_frontend/services/user.service.dart';
import 'package:tasktender_frontend/utils/app_gradients.dart';
import 'package:tasktender_frontend/widgets/image_button.dart';
import 'package:tasktender_frontend/widgets/main_button.dart';
import 'package:tasktender_frontend/widgets/main_input.dart';
import 'package:tasktender_frontend/widgets/primary_text_button.dart';

@RoutePage()
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final UserService _userService = locator<UserService>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool validateFields() {
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
          child: Center(
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Welcome,',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00CED1))),
              const Text('Create an account\nTo start now!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF00CED1))),
              const SizedBox(height: 55),
              MainInput(
                controller: _emailController,
                hintText: 'Email',
                color: const Color(0xFF00CED1),
              ),
              const SizedBox(height: 15),
              MainInput(
                controller: _passwordController,
                isPassword: true,
                hintText: 'Password',
                color: const Color(0xFF00CED1),
              ),
              const SizedBox(height: 15),
              MainInput(
                controller: _confirmPasswordController,
                isPassword: true,
                hintText: 'Confirm Password',
                color: const Color(0xFF00CED1),
              ),
              const SizedBox(height: 50),
              MainButton(
                context: context,
                text: 'Create An Account',
                onPressed: () async {
                  if (validateFields()) {
                    await _userService.registerUser(context,
                        _emailController.text, _passwordController.text);
                  }
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
              //       'Or Register Using',
              //       style: TextStyle(color: Theme.of(context).primaryColor),
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
              //   ], //
              // ),
              // const SizedBox(height: 50),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     ImageButton(
              //       context: context,
              //       onPressed: () {},
              //       // color: Colors.white,
              //       imagePath: 'lib/assets/external_images/apple_logo.png',
              //     ),
              //     const SizedBox(width: 25),
              //     ImageButton(
              //       context: context,
              //       onPressed: () {},
              //       // color: Colors.white,
              //       imagePath: 'lib/assets/external_images/google_logo.png',
              //     ),
              //   ],
              // ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Do you have an account?',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  PrimaryTextButton(
                    onPressed: () {
                      // Navigator.pushReplacementNamed(context, '/login');
                      context.router.replace(LoginRoute());
                    },
                    text: 'Sign In Now',
                    baseColor: const Color(0xFF00CED1),
                    pressedColor: const Color(0xFF3A4F66),
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
