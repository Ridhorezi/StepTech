import 'package:flutter/material.dart';
import 'package:step_tech/views/shared/appstyle.dart';
import 'package:step_tech/views/shared/reusable_text.dart';
import 'package:step_tech/views/ui/auth/login.dart';

class NonUser extends StatelessWidget {
  const NonUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 750,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(238, 238, 238, 1),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 80, 16, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              height: 35,
                              width: 35,
                              child: CircleAvatar(
                                backgroundImage: AssetImage(
                                    'assets/images/steptech-profile.jpg'),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            ReusableText(
                              text: "Hello, Please Login into your account",
                              style: appstyle(
                                12,
                                Colors.grey.shade600,
                                FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 5),
                            width: 50,
                            height: 30,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: Center(
                              child: ReusableText(
                                text: "Login",
                                style: appstyle(
                                  12,
                                  Colors.white,
                                  FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
