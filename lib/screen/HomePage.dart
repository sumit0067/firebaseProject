import 'package:flutter/material.dart';
import 'add_screen.dart';
import 'view_contact.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  navigateToAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return AddContact();
      }),
    );
  }

  navigateToView(id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return ViewContact(id);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact App"),
      ),
      body: Container(
        child: FirebaseAnimatedList(
          query: _databaseReference,
          itemBuilder: (context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            return GestureDetector(
              onTap: () {
                navigateToView(snapshot.key);
              },
              child: Card(
                color: Colors.orange,
                elevation: 3,
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: snapshot.value['imageUrl'] == "empty"
                                  ? AssetImage("asserts/logo.png")
                                  : NetworkImage(snapshot.value['imageUrl'])),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${snapshot.value['firstName']} ${snapshot.value['lastName']}',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            Text(
                              '${snapshot.value['phone']}',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAdd,
        child: Icon(Icons.add),
      ),
    );
  }
}
