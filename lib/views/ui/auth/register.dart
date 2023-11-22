import 'package:animated_button/animated_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_tech/controllers/auth_provider.dart';
import 'package:step_tech/models/auth/signup_model.dart';
import 'package:step_tech/views/shared/alert.dart';
import 'package:step_tech/views/shared/appstyle.dart';
import 'package:step_tech/views/shared/custom_textfield.dart';
import 'package:step_tech/views/shared/reusable_text.dart';
import 'package:step_tech/views/ui/auth/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  TextEditingController username = TextEditingController();

  bool validation = false;

  void formValidation() {
    if (email.text.isNotEmpty &&
        password.text.isNotEmpty &&
        username.text.isNotEmpty) {
      validation = true;
    } else {
      validation = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var authNotifier = Provider.of<AuthNotifier>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 50,
        backgroundColor: Colors.black,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/steptech-background.jpg'),
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: 12,
            ),
            ReusableText(
              text: "Hello!",
              style: appstyle(
                30,
                Colors.white,
                FontWeight.w600,
              ),
            ),
            ReusableText(
              text: "Register now.",
              style: appstyle(
                18,
                Colors.white,
                FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            CustomTextField(
              keyboard: TextInputType.emailAddress,
              hintText: "Username",
              controller: username,
              validator: (username) {
                if (username!.isEmpty) {
                  return 'Please provide valid username';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
              keyboard: TextInputType.emailAddress,
              hintText: "Email",
              controller: email,
              validator: (email) {
                if (email!.isEmpty && !email.contains("@")) {
                  return 'Please provide valid email';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
              hintText: "Password",
              obscureText: authNotifier.isObsecure,
              controller: password,
              suffixIcon: GestureDetector(
                onTap: () {
                  authNotifier.isObsecure = !authNotifier.isObsecure;
                },
                child: authNotifier.isObsecure
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility),
              ),
              validator: (password) {
                if (password!.isEmpty && password.length < 7) {
                  return 'Password to weak';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
                child: ReusableText(
                  text: "Login",
                  style: appstyle(
                    15,
                    Colors.blue,
                    FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            AnimatedButton(
              onPressed: () {
                formValidation();
                if (validation) {
                  SignupModel model = SignupModel(
                    username: username.text,
                    email: email.text,
                    password: password.text,
                  );
                  authNotifier.registerUser(model).then(
                    (response) {
                      if (response == true) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                        Alert.showSuccessSnackbar(
                            context, "Successfully registered");
                      } else {
                        Alert.showSnackbarWarning(
                            context, "Failed to registered");
                      }
                    },
                  );
                } else {
                  debugPrint('Form not valid');
                  if (email.text.isEmpty &&
                      password.text.isEmpty &&
                      username.text.isEmpty) {
                    Alert.showSnackbarWarning(
                        context, "Email, password & username is required");
                  } else if (username.text.isEmpty) {
                    Alert.showSnackbarWarning(context, "Username is required");
                  }
                  if (email.text.isEmpty) {
                    Alert.showSnackbarWarning(context, "Email is required");
                  } else if (!email.text.contains("@")) {
                    Alert.showSnackbarWarning(context, "Invalid email format");
                  }
                  if (password.text.isEmpty) {
                    Alert.showSnackbarWarning(context, "Password is required");
                  } else if (password.text.length < 7) {
                    Alert.showSnackbarWarning(context, "Password is too weak");
                  }
                }
              },
              width: 290,
              color: Colors.blue,
              enabled: true,
              shadowDegree: ShadowDegree.light,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.app_registration,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 80,
                    ),
                    ReusableText(
                      text: "Register",
                      style: appstyle(
                        23,
                        Colors.white,
                        FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
