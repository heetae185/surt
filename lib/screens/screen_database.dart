import 'package:flutter/material.dart';
import 'package:surt/database/database.dart';
import 'package:surt/provider/participants.dart';

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
      appBar: AppBar(title: const Text('SuRT Demo')),
      body: ListView.separated(
        itemCount: _participantsList.length,
        itemBuilder: ((context, index) {
          final participant = _participantsList[index];
          return ListTile(
            title: Text(participant.name ?? ''),
            subtitle: Text(
                "Born Year: ${participant.bornYear}, Driving Experience: ${participant.drivingExperience} years"),
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
