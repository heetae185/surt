import 'package:flutter/cupertino.dart';

class Participants extends ChangeNotifier {
  late String id = "";
  late String? name = "";
  late int? bornYear = 1990;
  late int? drivingExperience = 0;
  int count = 0;

  Participants({this.name, this.bornYear, this.drivingExperience});

  String _formatNumber(int num) {
    return num.toString().padLeft(2, '0');
  }

  void setId() {
    DateTime dt = DateTime.now();
    String month = _formatNumber(dt.month);
    String day = _formatNumber(dt.day);
    String hour = _formatNumber(dt.hour);
    String minute = _formatNumber(dt.minute);
    String second = _formatNumber(dt.second);
    id = "$month$day$hour$minute$second";
    notifyListeners();
  }

  void changeName(newName) {
    name = newName;
    notifyListeners();
  }

  void changeBornYear(newBornYear) {
    bornYear = newBornYear;
    notifyListeners();
  }

  void changeDriveEx(newDriveEx) {
    drivingExperience = newDriveEx;
    notifyListeners();
  }

  void addCount() {
    count += 1;
    notifyListeners();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'born_year': bornYear,
      'driving_experience': drivingExperience,
      'count': count,
    };
  }

  Participants.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    bornYear = map['born_year'];
    drivingExperience = map['driving_experience'];
    count = map['count'];
  }
}
