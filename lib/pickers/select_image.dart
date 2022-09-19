import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class SelectImage extends StatefulWidget {
  final void Function(File pickedImage) imagePickFn;
 SelectImage({
    Key key,
     this.imagePickFn,
     this.size,
  }) : super(key: key);
  
  final Size size;

  @override
  State<SelectImage> createState() => _SelectImageState();
}

class _SelectImageState extends State<SelectImage> {
  File image;

  void pickImage() async {
    try {
      final pickedImagefile = await ImagePicker.pickImage(
        maxWidth: 200,
        imageQuality: 100,
        source: ImageSource.gallery,
      );
      if (pickedImagefile == null) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text("No file picked!"),
        //     backgroundColor: Theme.of(context).errorColor,
        //   ),
        // );
        return;
      }
  
      final imageTemporary = File(pickedImagefile.path);

      setState(() {
        this.image = imageTemporary;
      });
      widget.imagePickFn(image);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.yellow),
      ),
      margin: EdgeInsets.symmetric(horizontal: widget.size.width * 0.05),
      child: Material(
        child: InkWell(
          onTap: () async {
            pickImage();
          },
          splashColor: Colors.yellow,
          child: image != null
              ? Image.file(
                  image,
                  width: widget.size.width * 0.8,
                  height: widget.size.height * 0.2,
                )
              : Ink(
                  width: widget.size.width * 0.8,
                  height: widget.size.height * 0.2,
                  child: Center(child: Text('Select Image')),
                ),
          // Image.asset('assets/images/minimal.jpg'),
        ),
      ),
    );
  }
}
