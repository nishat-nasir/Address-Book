import 'package:address_book/model/model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class EditAddress extends StatefulWidget {
  final String id;
  EditAddress(this.id);
  @override
  _EditAddressState createState() => _EditAddressState(id);
}

class _EditAddressState extends State<EditAddress> {
  String id;
  _EditAddressState(this.id);

  String _name = '';
  String _phone = '';
  String _city = '';
  String _country = '';

  // handle text editing controller

  TextEditingController _nController = TextEditingController();
  TextEditingController _poController = TextEditingController();
  TextEditingController _ctController = TextEditingController();
  TextEditingController _cntController = TextEditingController();

  bool isLoading = true;

  // firebase/db helper
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    // get address from firebase
    this.getAddress(id);
  }

  getAddress(id) async {
    Address address;
    _databaseReference.child(id).onValue.listen((event) {
      address = Address.fromSnapshot(event.snapshot);

      _nController.text = address.name;
      _poController.text = address.phone;
      _ctController.text = address.city;
      _cntController.text = address.country;

      setState(() {
        _name = address.name;
        _phone = address.phone;
        _city = address.city;
        _country = address.country;
        isLoading = false;
      });
    });
  }

  // update address
  updateaddress(BuildContext context) async {
    if (_name.isNotEmpty &&
        _phone.isNotEmpty &&
        _city.isNotEmpty &&
        _country.isNotEmpty) {
      Address address = Address.withId(
          this.id, this._name, this._phone, this._city, this._country);
      await _databaseReference.child(id).set(address.toJson());
      navigateToLastScreen(context);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Field Required'),
            content: Text('All fields are required'),
            actions: <Widget>[
              FlatButton(
                color: Colors.black,
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  navigateToLastScreen(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Address"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.all(20.0),
                child: ListView(
                  children: <Widget>[
                    //name
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _name = value;
                          });
                        },
                        controller: _nController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),

                    //phone
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _phone = value;
                          });
                        },
                        controller: _poController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Phone',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    //
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _city = value;
                          });
                        },
                        controller: _ctController,
                        decoration: InputDecoration(
                          labelText: 'City',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    //
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _country = value;
                          });
                        },
                        controller: _cntController,
                        decoration: InputDecoration(
                          labelText: 'Country',
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
                          updateaddress(context);
                        },
                        color: Colors.black,
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
