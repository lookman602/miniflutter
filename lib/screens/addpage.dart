import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController _foodcontroller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();

  File _image;
  final picker = ImagePicker();

  Future<void> chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("เพิ่มข้อมูลสินค้า"),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              width: 130,

              // child: RaisedButton(
              //   onPressed: () {
              //     // chooseImage();

              //   },
              child: FlatButton.icon(
                color: Colors.red,
                icon: Icon(Icons.add_a_photo_outlined),
                label: Text('Add Image'),
                textColor: Colors.white,
                 onPressed: () { chooseImage(); },
              ),
              // child: Icon(Icons.add),

              // child: Text('เลือกรูป'),
            ),

            // ),
            Container(
              width: 59,
              height: 200,
              child: _image == null ? Text('no image') : Image.file(_image),
            ),
            Container(
              width: 200,
              child: TextField(
                controller: _foodcontroller1,
                decoration: InputDecoration(labelText: 'ชื่อสินค้า'),
              ),
            ),
            Container(
              width: 200,
              child: TextField(
                controller: _controller2,
                decoration: InputDecoration(labelText: 'ราคา'),
              ),
            ),
            Container(
              width: 200,
              child: TextField(
                controller: _controller3,
                decoration: InputDecoration(labelText: 'ประเภทสินค้า'),
              ),
            ),
            RaisedButton(
              onPressed: () {
                addGear();
              },
              child: Text('Upload'),
              textColor: Colors.white,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addGear() async {
    String fileName = Path.basename(_image.path);
    StorageReference reference =
        FirebaseStorage.instance.ref().child('$fileName');
    StorageUploadTask storageUploadTask = reference.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then((value) async {
      await FirebaseFirestore.instance.collection('Gears').add({
        'gear_name': _foodcontroller1.text,
        'price': _controller2.text,
        'type_gear': _controller3.text,
        'img': value,
      }).whenComplete(() => Navigator.pop(context));
    });
  }
}
