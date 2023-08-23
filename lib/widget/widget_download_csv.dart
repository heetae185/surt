import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:surt/database/database.dart';

class DownloadCSVButton extends StatelessWidget {
  final DBHelper _dbHelper = DBHelper();

  DownloadCSVButton({Key? key}) : super(key: key);

  Future<void> _generateCSV() async {
    PermissionStatus status = await Permission.manageExternalStorage.request();
    final participantsList = await _dbHelper.getAllParticipants();

    if (status.isDenied) {
      Fluttertoast.showToast(
          msg: '권한 요청 실패',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM);
    }

    final csvData = participantsList.map((participant) {
      return '${participant.id},${participant.name},${participant.bornYear},${participant.drivingExperience},${participant.count}';
    }).join('\n');

    String? externalPath = await ExternalPath.getExternalStoragePublicDirectory(
      ExternalPath.DIRECTORY_DOWNLOADS,
    );

    if (externalPath != null) {
      final file = File('$externalPath/participants.csv');
      print(externalPath);
      await file.writeAsString(csvData);
      Fluttertoast.showToast(
          msg: '다운로드 완료!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM);
    } else {
      Fluttertoast.showToast(
          msg: '다운로드 실패',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.download),
      onPressed: (() async {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                content: const Text("다운로드 하시겠습니까?"),
                actions: [
                  ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await _generateCSV();
                      },
                      child: const Text("네")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                      child: const Text("아니오"))
                ],
              );
            });
      }),
    );
  }
}
