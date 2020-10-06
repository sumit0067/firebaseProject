import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'edit_contact.dart';
import '../model/Contact.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewContact extends StatefulWidget {
  final String id;

  ViewContact(this.id);

  @override
  _ViewContactState createState() => _ViewContactState(id);
}

class _ViewContactState extends State<ViewContact> {
  DatabaseReference _reference = FirebaseDatabase.instance.reference();
  String id;
  Contact _contact;
  bool isLoading = true;

  _ViewContactState(this.id);

  getContact(id) async {
    _reference.child(id).onValue.listen((event) {
      setState(() {
        _contact = Contact.fromSnapshot(event.snapshot);
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getContact(id);
  }

  callAction(String number) async {
    String url = 'tel:$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not call $number';
    }
  }

  messageAction(String number) async {
    String url = 'sms:$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not sent sms to $number';
    }
  }

  deleteContect() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete'),
            content: Text('Delete Contact'),
            actions: [
              FlatButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Delete"),
                onPressed: () async {
                  await _reference.child(id).remove();
                  Navigator.of(context).pop();
                  navigateToLastScreen();
                },
              )
            ],
          );
        });
  }

  navigateToEditScreen(id) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return EditContact(id);
      },
    ));
  }

  navigateToLastScreen() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // wrap screen in WillPopScreen widget
    return Scaffold(
      appBar: AppBar(
        title: Text("View Contact"),
      ),
      body: Container(
        child: isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )
            : ListView(
          children: <Widget>[
            // header text container
            Container(
                height: 200.0,
                child: Image(
                  //
                  image: _contact.imageUrl == "empty"
                      ? AssetImage("asserts/logo.png")
                      : NetworkImage(_contact.imageUrl),
                  fit: BoxFit.contain,
                )),
            //name
            Card(
              elevation: 2.0,
              child: Container(
                  margin: EdgeInsets.all(20.0),
                  width: double.maxFinite,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.perm_identity),
                      Container(
                        width: 10.0,
                      ),
                      Text(
                        "${_contact.firstName} ${_contact.lastName}",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ],
                  )),
            ),
            // phone
            Card(
              elevation: 2.0,
              child: Container(
                  margin: EdgeInsets.all(20.0),
                  width: double.maxFinite,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.phone),
                      Container(
                        width: 10.0,
                      ),
                      Text(
                        _contact.phone,
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ],
                  )),
            ),
            // email
            Card(
              elevation: 2.0,
              child: Container(
                  margin: EdgeInsets.all(20.0),
                  width: double.maxFinite,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.email),
                      Container(
                        width: 10.0,
                      ),
                      Text(
                        _contact.email,
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ],
                  )),
            ),

            // call and sms
            Card(
              elevation: 2.0,
              child: Container(
                  margin: EdgeInsets.all(20.0),
                  width: double.maxFinite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      IconButton(
                        iconSize: 30.0,
                        icon: Icon(Icons.phone),
                        color: Colors.red,
                        onPressed: () {
                          callAction(_contact.phone);
                        },
                      ),
                      IconButton(
                        iconSize: 30.0,
                        icon: Icon(Icons.message),
                        color: Colors.red,
                        onPressed: () {
                          messageAction(_contact.phone);
                        },
                      )
                    ],
                  )),
            ),
            // edit and delete
            Card(
              elevation: 2.0,
              child: Container(
                  margin: EdgeInsets.all(20.0),
                  width: double.maxFinite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      IconButton(
                        iconSize: 30.0,
                        icon: Icon(Icons.edit),
                        color: Colors.red,
                        onPressed: () {
                          navigateToEditScreen(id);
                        },
                      ),
                      IconButton(
                        iconSize: 30.0,
                        icon: Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () {
                          deleteContect();
                        },
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
