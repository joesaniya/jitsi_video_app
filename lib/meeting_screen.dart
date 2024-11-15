import 'package:flutter/material.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import 'package:provider/provider.dart';
import 'package:sample/call_state_provider.dart';
import 'package:sample/notification_service.dart';

class MeetingScreen extends StatefulWidget {
  const MeetingScreen({super.key});

  @override
  _MeetingScreenState createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  final _jitsiMeetPlugin = JitsiMeet();

  Future<void> _joinMeeting(BuildContext context) async {
    final provider = Provider.of<MeetingProvider>(context, listen: false);

    const roomName = "Fun with Shinchan";
    var options = JitsiMeetConferenceOptions(
      room: roomName,
      configOverrides: {
        "startWithAudioMuted": true,
        "startWithVideoMuted": true,
      },
      userInfo: JitsiMeetUserInfo(
        avatar:
            'https://i.pinimg.com/736x/42/95/05/4295058dc0c4a14750dec6a166d5f4c6.jpg',
        displayName: "Shinchan",
        email: "estherjenslin99@gmail.com",
      ),
    );

    var listener = JitsiMeetEventListener(
      conferenceJoined: (url) {
        provider.startMeeting(roomName);
        NotificationHelper.showNotification(
          "Meeting Joined",
          "You have joined the meeting: $roomName",
        );
        debugPrint("Conference Joined: $url");
      },
      conferenceTerminated: (url, error) {
        provider.endMeeting();
        NotificationHelper.showNotification(
          "Meeting Ended",
          "You have left the meeting.",
        );
        debugPrint("Conference Terminated: $url, error: $error");
      },
      participantJoined: (email, name, role, participantId) {
        debugPrint(
          "Participant Joined: name: $name, email: $email, role: $role",
        );
      },
    );

    await _jitsiMeetPlugin.join(options, listener);
  }

  Future<void> _hangUp(BuildContext context) async {
    await _jitsiMeetPlugin.hangUp();
    Provider.of<MeetingProvider>(context, listen: false).endMeeting();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MeetingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Jitsi Meet App"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              provider.isMeetingActive
                  ? "In Meeting: ${provider.currentMeetingRoom}"
                  : "No Active Meeting",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  provider.isMeetingActive ? null : () => _joinMeeting(context),
              child: const Text("Join Meeting"),
            ),
            ElevatedButton(
              onPressed:
                  provider.isMeetingActive ? () => _hangUp(context) : null,
              child: const Text("Hang Up"),
            ),
          ],
        ),
      ),
    );
  }
}
