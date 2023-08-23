import 'package:flutter/material.dart';
import 'package:surt/database/database.dart';
import 'package:surt/provider/participants.dart';
import 'package:surt/widget/widget_download_csv.dart';

class DatabaseScreen extends StatefulWidget {
  const DatabaseScreen({super.key});

  @override
  State<DatabaseScreen> createState() => _DatabaseScreenState();
}

class _DatabaseScreenState extends State<DatabaseScreen> {
  final DBHelper _dbHelper = DBHelper();
  List<Participants> _participantsList = [];

  @override
  void initState() {
    super.initState();
    _loadParticipantsFromDatabase();
  }

  Future<void> _loadParticipantsFromDatabase() async {
    final participants = await _dbHelper.getAllParticipants();
    setState(() {
      _participantsList = participants;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SuRT Demo'),
        actions: [
          DownloadCSVButton(),
        ],
      ),
      body: ListView.separated(
        itemCount: _participantsList.length,
        itemBuilder: ((context, index) {
          final participant = _participantsList[index];
          return ListTile(
            title: Text(participant.name ?? ''),
            subtitle: Text(
                "Born in ${participant.bornYear}, Driving Experience: ${participant.drivingExperience} years, Count: ${participant.count}"),
            trailing: GestureDetector(
              onTap: (() async {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: const Text("삭제하시겠습니까?"),
                        actions: [
                          ElevatedButton(
                              onPressed: () async {
                                await _dbHelper.delete(participant.id);
                                setState(() {
                                  _loadParticipantsFromDatabase();
                                });
                                Navigator.pop(context);
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
              child: const Icon(Icons.delete),
            ),
          );
        }),
        separatorBuilder: (context, index) {
          return const Divider(
            color: Colors.black,
          );
        },
      ),
    );
  }
}
