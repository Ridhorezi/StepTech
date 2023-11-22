import 'package:flutter/material.dart';
import 'package:step_tech/views/shared/appstyle.dart';
import 'package:step_tech/views/shared/reusable_text.dart';

class Alert {
  static void showSnackbar(
    BuildContext context,
    String message, {
    IconData? icon,
    Color? iconColor,
    bool warning = false,
    bool canceled = false,
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          if (icon != null)
            Icon(
              icon,
              color: iconColor ?? Colors.white,
            ),
          SizedBox(width: icon != null ? 8.0 : 0),
          Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
      backgroundColor: warning
          ? Colors.amber
          : canceled
              ? Colors.grey.shade600
              : Colors.blue,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.startToEnd,
      margin: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showErrorSnackbar(
    BuildContext context,
    String errorMessage, {
    IconData? icon,
    Color? iconColor,
  }) {
    showSnackbar(
      context,
      errorMessage,
      icon: icon ?? Icons.error,
      iconColor: iconColor ?? Colors.white,
      warning: true,
    );
  }

  static void showSuccessSnackbar(
    BuildContext context,
    String successMessage, {
    IconData? icon,
    Color? iconColor,
  }) {
    showSnackbar(
      context,
      successMessage,
      icon: icon ?? Icons.check_circle,
      iconColor: iconColor ?? Colors.white,
    );
  }

  static void showSnackbarWarning(
    BuildContext context,
    String message, {
    IconData? icon,
    Color? iconColor,
  }) {
    showSnackbar(
      context,
      message,
      icon: icon ?? Icons.warning,
      iconColor: iconColor ?? Colors.white,
      warning: true,
    );
  }

  static void showSnackbarCancel(
    BuildContext context,
    String message, {
    IconData? icon,
    Color? iconColor,
  }) {
    showSnackbar(context, message,
        icon: icon ?? Icons.info,
        iconColor: iconColor ?? Colors.white,
        canceled: true);
  }

  // Function to show delete confirmation dialog
  static Future<bool?> showDeleteConfirmationDialog(
      BuildContext context, String itemName) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: ReusableText(
            text: "Delete $itemName",
            style: appstyle(18, Colors.black87, FontWeight.bold),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Are you sure you want to delete $itemName?"),
              const SizedBox(height: 25, width: 10),
              Image.asset('assets/images/info.png', fit: BoxFit.contain)
            ],
          ),
          actions: [
            const SizedBox(
              height: 5,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel deletion
              },
              child: Text(
                "Cancel",
                style: appstyle(
                  12,
                  Colors.grey.shade600,
                  FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm deletion
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text(
                "Delete",
                style: appstyle(
                  12,
                  Colors.white,
                  FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
