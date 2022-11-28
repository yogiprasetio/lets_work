import 'package:client_voip2/pages/meeting_pages.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

import '../models/meeting_details.dart';
import '../utils/user_util.dart';

class JoinScreen extends StatefulWidget {
  // final String? meetingId;
  final MeetingDetail? meetingDetail;
  JoinScreen({super.key, this.meetingDetail});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String userName = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Join Meeting"),
        backgroundColor: Colors.amber,
      ),
      body: Form(key: globalKey, child: formUi()),
    );
  }

  formUi() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            FormHelper.inputFieldWidget(context, "userId", "enter u're name",
                (val) {
              if (val.isEmpty) {
                return "Name can't be Empty";
              }
              return null;
            }, (onSaved) {
              userName = onSaved;
            },
                borderRadius: 10,
                borderFocusColor: Colors.redAccent,
                borderColor: Colors.redAccent,
                hintColor: Colors.grey),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                    child: FormHelper.submitButton("Join", () async {
                  final String userId = await loadUserId();
                  if (validateAndSave()) {
                    //Meeting Page
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return MeetingPages(
                        meetingDetail: widget.meetingDetail!,
                        name: userName,
                        meetingId: widget.meetingDetail!.id,
                        userId: userId,
                      );
                    }));
                  }
                })),
              ],
            )
          ],
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
