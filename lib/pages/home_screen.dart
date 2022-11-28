import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

import '../api/meeting_api.dart';
import '../models/meeting_details.dart';
import 'join_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String meetingId = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Team Work"),
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
            const Text(
              "Welcome, Let's get work togheter...",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 25),
            ),
            const SizedBox(
              height: 20,
            ),
            FormHelper.inputFieldWidget(
                context, "meetingId", "enter u're Meeting Id", (val) {
              if (val.isEmpty) {
                return "MeetingId can't be Empty";
              }
              return null;
            }, (onSaved) {
              meetingId = onSaved;
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
                    child: FormHelper.submitButton("Join Meeting", () {
                  if (validateAndSave()) {
                    validateMeeting(meetingId);
                  }
                })),
                const SizedBox(
                  width: 20,
                ),
                Flexible(
                    child: FormHelper.submitButton("Start Meeting", () async {
                  var response = await startMeeting();
                  final body = json.decode(response!.body);
                  final meetingId = body['data'];
                  validateMeeting(meetingId);
                }))
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> validateMeeting(String meetingId) async {
    try {
      Response response = await joinMeeting(meetingId);
      var data = json.decode(response.body);
      final meetingDetails = MeetingDetail.fromJson(data["data"]);
      goToJoinScreen(meetingDetails);
    } catch (err) {
      FormHelper.showSimpleAlertDialog(
          context, "Team work app", "Invalid Room", "OK !", () {
        Navigator.of(context).pop();
      });
    }
  }

  goToJoinScreen(MeetingDetail meetingDetail) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => JoinScreen(
            meetingDetail: meetingDetail,
          ),
        ));
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
