import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  final String docid;

  const EditPage({Key key, this.docid}) : super(key: key);
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController _foodcontroller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    // var _foodcontroller1;

    return Scaffold(
      appBar: AppBar(
        title: Text("เเก้ไขข้อมูลสินค้า"),
      ),
      body: Column(
        children: [
          Container(
            child: TextField(
              controller: _foodcontroller1,
            ),
          ),
          Container(
            child: TextField(
              controller: _controller2,
            ),
          ),
          Container(
            child: TextField(
              controller: _controller3,
            ),
          ),
          RaisedButton(
            onPressed: () {
              updateGear();
            },
            child: Text('บันทึก'),
            textColor: Colors.white,
              color: Colors.red,
          )
        ],
      ),
    );
  }

  Future<void> getInfo() async {
    await FirebaseFirestore.instance
        .collection("Gears")
        .doc(widget.docid)
        .get()
        .then((value) {
      setState(() {
        //ค่ามันเปลี่ยนเลยต้อง setstate
        _foodcontroller1 =
            TextEditingController(text: value.data()['gear_name']);
        _controller2 =
            TextEditingController(text: value.data()['price'].toString());
        _controller3 = TextEditingController(text: value.data()['type_gear']);
      });
    });
  }

  Future<void> updateGear() async {
    await FirebaseFirestore.instance
        .collection("Gears")
        .doc(widget.docid)
        .update({
      'gear_name': _foodcontroller1.text,
      'price': _controller2.text,
      'type_gear': _controller3.text,
    }).whenComplete(() => Navigator.pop(context));
  }
}
