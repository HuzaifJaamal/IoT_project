import 'package:flutter/material.dart';

Future<void> showCustomStatusDialog({
  required BuildContext context,
  required IconData icon,
  required Color iconColor,
  required String title,
  required String message,
  required TextAlign textAlign,
  // String? messages,
  required String buttonText1,
  String? buttonText2,             // <-- OPTIONAL BUTTON
  required VoidCallback onButtonTap,
  VoidCallback? onButton2Tap,      // <-- OPTIONAL CALLBACK
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon Circle
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: iconColor.withOpacity(0.1),
                      ),
                      child: Icon(
                        icon,
                        color: iconColor,
                        size: 40,
                      ),
                    ),
                    SizedBox(height: 16),
              
                    // Title
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
              
                    SizedBox(height: 8),
              
                    // Message
                    Text(
                      message,
                      textAlign: textAlign,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        // Optional: override the color if you want a custom one
                        // color: Theme.of(context).colorScheme.onBackground,
                      ),
                      /*style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),*/
                    ),
              
                    SizedBox(height: 8),
              
                    // Message
                   /* Text(
                      messages!,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),*/
              
                    SizedBox(height: 24),
              
                    // BUTTONS — handle optional button 2
                    if (buttonText2 == null || buttonText2.isEmpty)
                    // ----------------------
                    //   ONLY ONE BUTTON
                    // ----------------------
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: iconColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            onButtonTap();
                          },
                          child: Text(
                            buttonText1,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    else
                    // ----------------------
                    //     TWO BUTTONS
                    // ----------------------
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[300],
                                foregroundColor: Colors.black87,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                if (onButton2Tap != null) onButton2Tap();
                              },
                              child: Text(
                                buttonText2!,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: iconColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                onButtonTap();
                              },
                              child: Text(
                                buttonText1,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
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
    },
  );
}

