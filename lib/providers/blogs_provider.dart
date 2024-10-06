// Developed By Muhammad Waleed.. Senior Android and Flutter developer..
// waleedkalyar48@gmail.com/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:horti_vige/data/models/blog/blog_model.dart';

class BlogsProvider extends ChangeNotifier {
  final _blogsCollectionRef = FirebaseFirestore.instance.collection('Blogs');

  Future<List<BlogModel>> getAllBlogs() async {
    final querySnapshots = await _blogsCollectionRef.get();
    return querySnapshots.docs
        .map((e) => BlogModel.fromJson(e.data()))
        .toList();
  }

  Future<void> sendDummyBlogs() async {
    for (var i = 0; i < 5; i++) {
      final id = _blogsCollectionRef.doc().id;
      final model = BlogModel(
        id: id,
        title: 'Why do humans love flowers?',
        imageUrl:
            'https://t4.ftcdn.net/jpg/05/57/29/25/360_F_557292539_2kXYz0frOcCGISoYEd2MNTmxyT0lYyOj.jpg',
        description: 'This is just a test description of blog',
        senderId: 'WILL REPLACE WITH ADMIN ID',
        senderName: 'App Admin',
        senderProfileUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnKrJfzU-EFhRz3Ixuo-NvpibFpwITsX0TWG2i2D1l0d5nuv8mxRIG901_A_hUuNgN1nA&usqp=CAU',
        time: DateTime.now().millisecondsSinceEpoch,
      );

      await _blogsCollectionRef.doc(id).set(model.toJson());
    }
  }
}
