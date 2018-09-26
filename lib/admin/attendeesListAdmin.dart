import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AttendeesLists extends StatelessWidget {
  final String eventName;
  final String eventKey;
  AttendeesLists({this.eventName, this.eventKey});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List of Attendees"),
        centerTitle: true,
        backgroundColor: Colors.green[200],
      ),
      body: StreamBuilder(
          initialData: 0,
          stream: Firestore.instance
              .collection('${eventKey}_attendees')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData == null && !snapshot.hasData)
              return Center(child: Text("Loading..."));
            return AttendeesListsDocuments(
                lists: snapshot.data.documents, eventKey: eventKey);
          }),
    );
  }
}

class AttendeesListsDocuments extends StatelessWidget {
  final List<DocumentSnapshot> lists;
  final String eventKey;
  AttendeesListsDocuments({this.lists, this.eventKey});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: lists.length,
      itemBuilder: (context, index) {
        String name = lists[index].data["Name"].toString();
        String attendanceIN = lists[index].data['In'].toString();
        String attendanceOut = lists[index].data['Out']?.toString();
        return Card(
          color: Colors.white,
          child: Column(children: [
            ListTile(
              title: Text("${index + 1}. $name"),
            ),
            ButtonTheme.bar(
              child: ButtonBar(
                children: <Widget>[
                  Text(attendanceIN ?? "Not attended"),
                  Icon(attendanceIN != "Absent" || attendanceIN != null
                      ? Icons.check
                      : Icons.close),
                  Text(attendanceOut ?? "Not Attended"),
                  Icon(attendanceOut != null ? Icons.check : Icons.close)
                ],
              ),
            )
          ]),
        );
      },
    );
  }
}
