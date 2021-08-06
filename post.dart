import 'package:card/edit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class Post extends StatelessWidget {
  final Map data;
  Post({required this.data});
  @override
  Widget build(BuildContext context) {
    void deletePost() async {
      try {
        FirebaseFirestore db = FirebaseFirestore.instance;
        await db.collection('posts').doc(data['id']).delete();
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }

    void editPost() async {
      try {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return editdialog(data: data);
            });
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }

    return Column(
        // Padding(
        //   padding: const EdgeInsets.all(4.0),
        //   child: Container(
        //     decoration: BoxDecoration(
        //       border: Border.all(color: Colors.black, width: 1),
        //     ),
        //   child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        children: [
          Image.network(
            data["url"],
            height: 150,
            width: 200,
          ),
          Text(data["title"]),
          const SizedBox(
            height: 3,
          ),
          Text(data["description"]),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: editPost,
            child: const Text('Edit'),
            style: ElevatedButton.styleFrom(
              primary: Colors.teal,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: deletePost,
              child: const Text('Delete'),
              style: ElevatedButton.styleFrom(
                primary: Colors.teal,
              ))
        ]);
  }
}
