import 'dart:io';

import 'package:blog_minimal/widgets/custom_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../pickers/select_image.dart';

class CreatePost extends StatefulWidget {
  CreatePost({Key key}) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  File _userImageFile;
  var isloading = false;
  

  void _submitForm(
      {String title,
      String description,
      File image,
      BuildContext context}) async {
    try {
      if (title.isNotEmpty &&
          description.isNotEmpty &&
          _userImageFile != null) {
        setState(() {
          isloading = true;
        });

        final _user = FirebaseAuth.instance.currentUser;

        final user = await FirebaseFirestore.instance
            .collection('users')
            .doc(_user.uid)
            .get();
        final author = user['username'];

        final ref = FirebaseStorage.instance
            .ref('user_images/${Timestamp.now().toString()}');

        await ref.putFile(image);

        final url = await ref.getDownloadURL();

        DateTime now = new DateTime.now();
        DateTime date = new DateTime(now.year, now.month, now.day);

        await FirebaseFirestore.instance.collection('blogs').doc().set({
          'title': title,
          'content': description,
          'imageUrl': url,
          'publisher': author,
          'date': date.toString().substring(0, 10),
        });

        setState(() {
          isloading = false;
        });
         ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Published successfully"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please fill up all the fields"),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
      }
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  final titleController = TextEditingController();

  final descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (_userImageFile != null) print('hey');
// There are no fields for Time and Author (current time will be pushed to db & current user displayname as authername)
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Create Post',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                    vertical: size.height * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectImage(
                      size: size,
                      imagePickFn: _pickedImage,
                    ),
                    SizedBox(height: size.height * 0.025),
                    Text(
                      'Title',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: size.height * 0.005),
                    CustomTextField(
                      hint: 'Enter Title',
                      controller: titleController,
                    ),
                    SizedBox(height: size.height * 0.03),
                    Text(
                      'Description',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: size.height * 0.005),
                    CustomTextField(
                      hint: 'Enter Description',
                      controller: descController,
                    ),
                    SizedBox(height: size.height * 0.02),
                    Align(
                      child: Container(
                          width: size.width * 0.5,
                          height: size.height * 0.06,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color(0xFFFFD810))),
                              onPressed: () {
                                _submitForm(
                                  title: titleController.text.trim(),
                                  description: descController.text.trim(),
                                  image: _userImageFile,
                                  context: context,
                                );
                              },
                              child: Text('Create Post'))),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
