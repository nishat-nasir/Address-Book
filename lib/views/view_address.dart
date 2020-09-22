import 'package:address_book/model/model.dart';
import 'package:address_book/views/edit_address.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ViewAddress extends StatefulWidget {
  final String id;
  ViewAddress(this.id);
  @override
  _ViewAddressState createState() => _ViewAddressState(id);
}

class _ViewAddressState extends State<ViewAddress> {
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  String id;
  _ViewAddressState(this.id);
  Address _address;
  bool isLoading = true;

  getAddress(id) async {
    _databaseReference.child(id).onValue.listen((event) {
      setState(() {
        _address = Address.fromSnapshot(event.snapshot);
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    this.getAddress(id);
  }

  deleteAddress() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text("Delete"),
            content: Text("Are you sure?"),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                color: Colors.cyan[900],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Delete'),
                color: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _databaseReference.child(id).remove();
                  navigateToLastScreen();
                },
              ),
            ],
          );
        });
  }

  navigateToEditScreen(id) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditAddress(id);
    }));
  }

  navigateToLastScreen() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // wrap screen in WillPopScreen widget
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[900],
        title: Text("View Address"),
      ),
      body: Container(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: <Widget>[
                  //name
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Container(
                        padding: const EdgeInsets.all(60.0),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Color(0xff006064), Color(0xff004d51)]),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0x000000).withOpacity(.6),
                                  offset: Offset(1.0, 3.0),
                                  blurRadius: 5.0)
                            ]),
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.person,
                              size: 50.0,
                              color: Colors.white,
                            ),
                            Container(
                              width: 20.0,
                            ),
                            Text(
                              "${_address.name}",
                              style: TextStyle(
                                  fontSize: 70.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                  ),
                  // phone
                  Card(
                    color: Colors.teal[700],
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
                              _address.phone,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                  ),
                  // city
                  Card(
                    elevation: 2.0,
                    color: Colors.teal[700],
                    child: Container(
                        margin: EdgeInsets.all(20.0),
                        width: double.maxFinite,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.location_city),
                            Container(
                              width: 10.0,
                            ),
                            Text(
                              _address.city,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                  ),
                  // country
                  Card(
                    color: Colors.teal[700],
                    elevation: 2.0,
                    child: Container(
                        margin: EdgeInsets.all(20.0),
                        width: double.maxFinite,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.home),
                            Container(
                              width: 10.0,
                            ),
                            Text(
                              _address.country,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                  ),

                  // edit and delete
                  Container(
                    margin: const EdgeInsets.all(5.0),
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Color(0xff006064), Color(0xff004d51)]),
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x000000).withOpacity(.6),
                          )
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        IconButton(
                          iconSize: 30.0,
                          icon: Icon(Icons.edit),
                          color: Colors.white,
                          onPressed: () {
                            navigateToEditScreen(id);
                          },
                        ),
                        IconButton(
                          iconSize: 30.0,
                          icon: Icon(Icons.delete),
                          color: Colors.white,
                          onPressed: () {
                            deleteAddress();
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
