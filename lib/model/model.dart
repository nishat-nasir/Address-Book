import 'package:firebase_database/firebase_database.dart';

class Address {
  String _id;
  String _name;
  String _phone;
  String _city;
  String _country;

  // Constructor for add
  Address(this._name, this._phone, this._city, this._country);

  // Constructor for edit
  Address.withId(this._id, this._name, this._phone, this._city, this._country);

  // Getters
  String get id => this._id;
  String get name => this._name;
  String get phone => this._phone;
  String get city => this._city;
  String get country => this._country;

  // Setters
  set firstName(String firstName) {
    this._name = name;
  }

  set phone(String phone) {
    this._phone = phone;
  }

  set city(String city) {
    this._city = city;
  }

  set country(String country) {
    this._country = country;
  }

  Address.fromSnapshot(DataSnapshot snapshot) {
    this._id = snapshot.key;
    this._name = snapshot.value['name'];
    this._phone = snapshot.value['phone'];
    this._city = snapshot.value['city'];
    this._country = snapshot.value['country'];
  }

  Map<String, dynamic> toJson() {
    return {
      "name": _name,
      "phone": _phone,
      "city": _city,
      "country": _country,
    };
  }
}
