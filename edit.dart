import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

// ignore: use_key_in_widget_constructors
class editdialog extends StatefulWidget {
  Map data;
  // ignore: use_key_in_widget_constructors
  editdialog({required this.data});

  @override
  State<editdialog> createState() => _editdialogState();
}

class _editdialogState extends State<editdialog> {
  @override
  late String imgPath;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  void initState() {
    super.initState();

    titleController.text = widget.data['title'];
    descriptionController.text = widget.data['description'];
  }

  // ignore: annotate_overrides
  Widget build(BuildContext context) {
    void pickImage() async {
      final ImagePicker _picker = ImagePicker();
      // ignore: deprecated_member_use
      final image = await _picker.getImage(source: ImageSource.gallery);

      setState(() {
        imgPath = image!.path;
      });
    }

    void done() async {
      try {
        String imgName = path.basename(imgPath);

        firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.ref('/$imgName');

        File file = File(imgPath);
        await ref.putFile(file);

        String downloadURL = await ref.getDownloadURL();
        FirebaseFirestore db = FirebaseFirestore.instance;

        Map<String, dynamic> newPost = {
          'title': titleController.text,
          'description': descriptionController.text,
          'url': downloadURL
        };
        await db.collection('posts').doc(widget.data['id']).set(newPost);

        Navigator.of(context).pop();
      } catch (e) {
        print(e);
      }
    }

    return AlertDialog(
      // ignore: avoid_unnecessary_containers
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // ignore: prefer_const_constructors
            Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                // ignore: prefer_const_constructors
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: const Text(
                    'Edit Post',
                    // ignore: prefer_const_constructors
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: TextField(
                controller: titleController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Title',
                    hintText: 'Enter title'),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Description',
                    hintText: 'Enter description'),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: pickImage,
              child: const Text('Upload'),
              style: ElevatedButton.styleFrom(
                primary: Colors.teal,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: done,
              child: const Text('Done'),
              style: ElevatedButton.styleFrom(
                primary: Colors.teal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
