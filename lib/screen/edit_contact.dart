import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import '../model/Contact.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class EditContact extends StatefulWidget {
  final String id;

  EditContact(this.id);

  @override
  _EditContactState createState() => _EditContactState(id);
}

class _EditContactState extends State<EditContact> {
  String id;

  _EditContactState(id);

  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _phone = '';
  String _imageUrl;

  //handel textEditController
  TextEditingController _firstCont = TextEditingController();
  TextEditingController _lastCont = TextEditingController();
  TextEditingController _emailCont = TextEditingController();
  TextEditingController _phoneCont = TextEditingController();

  bool isLoading = true;

  //db Firebase Helper
  DatabaseReference _reference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    //getContact Form database
    this.getContact(id);
  }

  getContact(id) async {
    Contact contact;
    _reference.child(id).onValue.listen((event) {
      contact = Contact.fromSnapshot(event.snapshot);
      _firstCont.text = contact.firstName;
      _lastCont.text = contact.lastName;
      _emailCont.text = contact.email;
      _phoneCont.text = contact.phone;

      setState(() {
        _firstName = contact.firstName;
        _lastName = contact.firstName;
        _email = contact.firstName;
        _phone = contact.firstName;

        isLoading = false;
      });
    });
  }

  //pick Image
  Future pickImage() async {
    File file = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 200,
      maxWidth: 200,
    );
    String fileName = basename(file.path);
    uploadImage(file, fileName);
  }

  //updateImage
  updateCon(BuildContext context) async {
    if (_firstName.isNotEmpty &&
        _lastName.isNotEmpty &&
        _email.isNotEmpty &&
        _phone.isNotEmpty) {
      Contact contact = Contact.withId(this.id, this._firstName, this._lastName,
          this._phone, this._email, this._imageUrl);

      await _reference.child(id).set(contact.tojson());
      navigateToLastScreen(context);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: Text('Field Required'),
                content: Text('All Field Required'),
                actions: [
                  FlatButton(
                    child: Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ));
    }
  }

  //upload Image
  void uploadImage(File file, String fileName) async {
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    //upload Image
    reference.put(file).onComplete.then((value) async {
      var downloadUrl = await value.ref.getDownloadURL();
      setState(() {
        _imageUrl = downloadUrl;
      });
    });
  }

  navigateToLastScreen(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Contact"),
      ),
      body: Container(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.all(20.0),
                child: ListView(
                  children: <Widget>[
                    //image view
                    Container(
                        margin: EdgeInsets.only(top: 20.0),
                        child: GestureDetector(
                          onTap: () {
                            this.pickImage();
                          },
                          child: Center(
                            child: Container(
                                width: 100.0,
                                height: 100.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      fit: BoxFit.cover,
                                      image: _imageUrl == "empty"
                                          ? AssetImage("asserts/logo.png")
                                          : NetworkImage(_imageUrl),
                                    ))),
                          ),
                        )),

                    //first Name
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _firstName = value;
                          });
                        },
                        controller: _firstCont,
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),

                    //last name
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _lastName = value;
                          });
                        },
                        controller: _lastCont,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),

                    //email
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                          });
                        },
                        controller: _emailCont,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),

                    //phone No
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _phone = value;
                          });
                        },
                        controller: _phoneCont,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Phone',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),

                    // update button
                    Container(
                      padding: EdgeInsets.only(top: 20.0),
                      child: RaisedButton(
                        padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
                        onPressed: () {
                          updateCon(context);
                        },
                        color: Colors.red,
                        child: Text(
                          "Update",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
