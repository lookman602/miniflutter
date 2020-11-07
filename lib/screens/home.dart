import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasedemo/screens/addpage.dart';
import 'package:firebasedemo/screens/editpage.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isSearching = false;
  String user;
  String password;
  String name;
  String tel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // setState(() {

              // });
            }),
        title: !isSearching
            ? Text("Gaming Gear Shop")
            : TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    hintText: "ค้นหาสินค้า",
                    hintStyle: TextStyle(color: Colors.white)),
              ),
        actions: <Widget>[
          isSearching
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      this.isSearching = false;
                    });
                  },
                  icon: Icon(Icons.cancel),
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      this.isSearching = true;
                    });
                  },
                  icon: Icon(Icons.search),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MaterialPageRoute route =
              MaterialPageRoute(builder: (context) => AddPage());
          Navigator.push(context, route);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: realTimeGear(),
    );
  }

  Widget realTimeGear() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("Gears").snapshots(),
      builder: (context, snapshots) {
        switch (snapshots.connectionState) {
          case ConnectionState.waiting:
            return CircularProgressIndicator();
            break;
          default:
            return Column(
              children: makeListWidget(snapshots),
            );
        }
      },
    );
  }

  List<Widget> makeListWidget(AsyncSnapshot snapshots) {
    return snapshots.data.docs.map<Widget>((document) {
      return Card(
        child: ListTile(
          trailing: IconButton(
              //--------trailing คือ เพิ่มข้างหลัง เพื่อไว้ใส่ icon ลบ
              icon: Icon(Icons.delete),
              color: Colors.red,
              //----------ปุ่มลบ-----------
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Center(),
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Text("ต้องการลบข้อมูลหรือไม่!!"),
                            )
                          ],
                        ),
                        actions: [
                          FlatButton(
                              child: Text("ลบ"),
                              color: Colors.red,
                              onPressed: () {
                                deleteFood(
                                    document.id); //-------ใส่ document id
                                Navigator.of(context).pop();
                              }),
                          FlatButton(
                              child: Text("ยกเลิก"),
                              color: Colors.blueGrey,
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                        ],
                      );
                    });
              }),
          leading: Container(
              width: 60,
              child: Image.network(
                document['img'],
                fit: BoxFit.cover,
              )),
          title: Text(document['gear_name']),
          subtitle: Text(
            document['price'].toString(),
          ),
          onTap: () {
            MaterialPageRoute route = MaterialPageRoute(
              builder: (context) => EditPage(docid: document.id),
            );
            Navigator.push(context, route);
          },
        ),
      );
    }).toList();
  }

  Future<void> deleteFood(id) async {
    await FirebaseFirestore.instance.collection("Gears").doc(id).delete();
  }
}
