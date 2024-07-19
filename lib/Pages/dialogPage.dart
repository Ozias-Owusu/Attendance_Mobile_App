import 'package:flutter/material.dart';

/*
create a stf class and display a dialog where it asks users the same thing in the notification
if they have already signed in , should display , you're at work , if not should display the actions for users to select  from and save the record to shared preferences0
*/
class DialogService {
  final BuildContext context;

  DialogService(this.context);

  Future<void> showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
