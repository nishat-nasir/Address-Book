import 'package:flutter/material.dart';
import 'add_address.dart';
import 'view_address.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  //new
  bool searchState = false;

  navigateToAddScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddAddress();
    }));
  }

  navigateToViewScreen(id) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ViewAddress(id);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: !searchState
            ? Text("Address Book")
            : TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: 'Search . . .',
                  hintStyle: TextStyle(color: Colors.white),
                ),
                onChanged: (text) {
                  searchMethod(text);
                }),

        //search button
        actions: <Widget>[
          !searchState
              ? IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      searchState = !searchState;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      searchState = !searchState;
                    });
                  }),
        ],
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        child: FirebaseAnimatedList(
          query: _databaseReference,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            return GestureDetector(
              onTap: () {
                navigateToViewScreen(snapshot.key);
              },
              child: Card(
                margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 5.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xff006064), Color(0xff004d51)]),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0x000000).withOpacity(.6),
                            offset: Offset(1.0, 3.0),
                            blurRadius: 8.0)
                      ]),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(children: [
                              Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 30.0,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "${snapshot.value['name']}",
                                style: TextStyle(
                                    fontSize: 40.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ]),
                            SizedBox(height: 10.0),
                            Row(children: [
                              Icon(
                                Icons.phone,
                                color: Colors.white70,
                                size: 15.0,
                              ),
                              SizedBox(width: 10.0),
                              Text(
                                "${snapshot.value['phone']}",
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white70),
                              ),

                              //city
                              SizedBox(width: 30.0),
                              Icon(
                                Icons.location_city,
                                color: Colors.white70,
                                size: 15.0,
                              ),
                              SizedBox(width: 5.0),
                              Text(
                                "${snapshot.value['city']}",
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white70),
                              )
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        onPressed: navigateToAddScreen,
        backgroundColor: Colors.white,
      ),
    );
  }

  void searchMethod(String text) {}
}
