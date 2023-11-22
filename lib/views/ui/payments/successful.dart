import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:step_tech/controllers/payment_provider.dart';
import 'package:step_tech/views/shared/appstyle.dart';
import 'package:step_tech/views/shared/reusable_text.dart';
import 'package:step_tech/views/ui/main_screen.dart';
import 'package:provider/provider.dart';

class Successful extends StatelessWidget {
  const Successful({super.key});

  @override
  Widget build(BuildContext context) {
    var paymentNotifier = Provider.of<PaymentNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            paymentNotifier.setPaymentUrl = '';
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainScreen(),
              ),
            );
          },
          child: const Icon(
            AntDesign.closecircleo,
            color: Colors.black,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/Checkmark.png"),
            ReusableText(
              text: "Payment Successful",
              style: appstyle(
                28,
                Colors.black,
                FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
