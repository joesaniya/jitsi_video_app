import 'package:flutter/material.dart';

class MeetingProvider extends ChangeNotifier {
  String _meetingId = '';
  String _userName = 'Guest';
  bool _isMeetingActive = false;
  String? _currentMeetingRoom;

  String get meetingId => _meetingId;
  String get userName => _userName;
  bool get isMeetingActive => _isMeetingActive;
  String? get currentMeetingRoom => _currentMeetingRoom;

  void updateMeetingDetails(String meetingId, String userName) {
    _meetingId = meetingId;
    _userName = userName;
    notifyListeners();
  }

 
  void startMeeting(String meetingRoom) {
    _currentMeetingRoom = meetingRoom;
    _isMeetingActive = true;
    notifyListeners();
    
  }


  void endMeeting() {
    _currentMeetingRoom = null;
    _isMeetingActive = false;
    notifyListeners();
    
  }
}
