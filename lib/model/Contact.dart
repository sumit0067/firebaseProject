import 'package:firebase_database/firebase_database.dart';

class Contact {
  String _id;
  String _firstName;
  String _lastName;
  String _phone;
  String _email;
  String _imageUrl;

  Contact(this._firstName, this._lastName, this._phone, this._email,
      this._imageUrl);

  Contact.withId(this._id, this._firstName, this._lastName, this._phone,
      this._email, this._imageUrl);

  //getters
  String get imageUrl => _imageUrl;

  String get email => _email;

  String get phone => _phone;

  String get lastName => _lastName;

  String get firstName => _firstName;

  String get id => _id;

  //Setters
  set imageUrl(String value) {
    _imageUrl = value;
  }

  set email(String value) {
    _email = value;
  }

  set phone(String value) {
    _phone = value;
  }

  set lastName(String value) {
    _lastName = value;
  }

  set firstName(String value) {
    _firstName = value;
  }

  set id(String value) {
    _id = value;
  }

  Contact.fromSnapshot(DataSnapshot snapshot) {
    this._id = snapshot.key;
    this._firstName = snapshot.value['firstName'];
    this._lastName = snapshot.value['lastName'];
    this._email = snapshot.value['email'];
    this._phone = snapshot.value['phone'];
    this._imageUrl = snapshot.value['imageUrl'];
  }

  Map<String, dynamic> tojson() {
    return {
      "firstName": _firstName,
      "lastName": _lastName,
      "email": _email,
      "phone": _phone,
      "imageUrl": _imageUrl,
    };
  }
}
