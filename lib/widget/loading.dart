import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Loading {
  BuildContext context;

  Loading({this.context});

  void show() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text("Loading...")
              ],
            ),
          ),
        );
      },
    );
  }

  void hide() {
    Navigator.pop(context);
  }
}
