import 'package:flutter/cupertino.dart';

class Participants extends ChangeNotifier {
  late String? name = "";
  late int? bornYear = 1990;
  late int? drivingExperience = 0;
  int count = 0;

  Participants({this.name, this.bornYear, this.drivingExperience});

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
}
