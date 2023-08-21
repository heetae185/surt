import 'package:flutter/material.dart';
import 'package:surt/provider/participants.dart';

class DatabaseScreen extends StatefulWidget {
  const DatabaseScreen({super.key});

  @override
  State<DatabaseScreen> createState() => _DatabaseScreenState();
}

class _DatabaseScreenState extends State<DatabaseScreen> {
  final List<Participants> tempData = [
    Participants(name: "희태", bornYear: 1998, drivingExperience: 2),
    Participants(name: "혜선", bornYear: 1998, drivingExperience: 1),
    Participants(name: "선균", bornYear: 1968, drivingExperience: 25),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SuRT Demo')),
      body: ListView.separated(
        itemCount: tempData.length,
        itemBuilder: ((context, index) {
          final participant = tempData[index];
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
