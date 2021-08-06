import 'dart:io';
import 'package:card/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;

// ignore: use_key_in_widget_constructors
class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController titleController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();
  late String imgPath;
  Stream<QuerySnapshot> postStream =
      FirebaseFirestore.instance.collection('posts').snapshots();

  @override
  Widget build(BuildContext context) {
    void pickImage() async {
      final ImagePicker _picker = ImagePicker();
      final image = await _picker.getImage(source: ImageSource.gallery);

      setState(() {
        imgPath = image!.path;
      });
    }

    void submit() async {
      try {
        String title = titleController.text;
        String description = descriptionController.text;
        print('Title is ' + title);
        print('Description is ' + description);
        String imgName = path.basename(imgPath);

        firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.ref('/$imgName');

        File file = File(imgPath);
        await ref.putFile(file);

        String downloadURL = await ref.getDownloadURL();
        FirebaseFirestore db = FirebaseFirestore.instance;
        await db.collection('posts').add(
            {'title': title, 'description': description, 'url': downloadURL});
        print('Post  Uploaded Succesfully');
        titleController.clear();
        descriptionController.clear();
        // print(downloadURL);
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
        body: Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    // ignore: prefer_const_constructors
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: const Text(
                        'Create a new post',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
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
                Padding(
                  padding: const EdgeInsets.all(4.0),
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
                  onPressed: submit,
                  child: const Text('Submit a post'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    // ignore: prefer_const_constructors
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: const Text(
                        'Your Posts',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                // ignore: avoid_unnecessary_containers
                Expanded(
                  child: Container(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: postStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          // ignore: prefer_const_constructors
                          return Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text("Loading");
                        }

                        // ignore: unnecessary_new
                        return new ListView(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;
                            String id = document.id;
                            data['id'] = id;
                            return Post(data: data);
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ),
              ],
            )));
  }
}
