import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:animated_button/animated_button.dart';
import 'package:step_tech/controllers/auth_provider.dart';
import 'package:step_tech/models/auth/login_model.dart';
import 'package:step_tech/views/shared/alert.dart';
import 'package:step_tech/views/shared/appstyle.dart';
import 'package:step_tech/views/shared/custom_textfield.dart';
import 'package:step_tech/views/shared/reusable_text.dart';
import 'package:step_tech/views/ui/auth/register.dart';
import 'package:step_tech/views/ui/main_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool validation = false;

  void formValidation() {
    if (email.text.isNotEmpty && password.text.isNotEmpty) {
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
        toolbarHeight: 40,
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
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
              text: "Wellcome!",
              style: appstyle(
                30,
                Colors.white,
                FontWeight.w600,
              ),
            ),
            ReusableText(
              text: "Sign in now.",
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
                  return 'Password too weak';
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
                      builder: (context) => const RegisterPage(),
                    ),
                  );
                },
                child: ReusableText(
                  text: "Register",
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
            Center(
              child: AnimatedButton(
                onPressed: () {
                  formValidation();
                  if (validation) {
                    LoginModel model =
                        LoginModel(email: email.text, password: password.text);
                    authNotifier.userLogin(model).then(
                      (response) {
                        if (response == true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainScreen(),
                            ),
                          );
                          Alert.showSuccessSnackbar(
                              context, "Successfully login");
                        } else {
                          Alert.showSnackbarWarning(context, "Failed to login");
                        }
                      },
                    );
                  } else {
                    // Validasi
                    if (email.text.isEmpty && password.text.isEmpty) {
                      Alert.showSnackbarWarning(
                          context, "Email & password is required");
                    } else if (email.text.isEmpty) {
                      Alert.showSnackbarWarning(context, "Email is required");
                    } else if (!email.text.contains("@")) {
                      Alert.showSnackbarWarning(
                          context, "Invalid email format");
                    } else if (password.text.isEmpty) {
                      Alert.showSnackbarWarning(
                          context, "Password is required");
                    } else {
                      Alert.showSnackbarWarning(context, "Form not valid");
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
                        Icons.login,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 80,
                      ),
                      ReusableText(
                        text: "Sign In",
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
            ),
            Center(
              child: ReusableText(
                  text: "Or",
                  style: appstyle(20, Colors.white, FontWeight.w600)),
            ),
            Center(
              child: AnimatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainScreen(),
                    ),
                  );
                  Alert.showSuccessSnackbar(
                      context, "You are sign in as a guest.");
                },
                width: 290,
                color: Colors.orange,
                enabled: true,
                shadowDegree: ShadowDegree.light,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(
                        AntDesign.login,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      ReusableText(
                        text: "Sign In as Guest",
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
            )
          ],
        ),
      ),
    );
  }
}
