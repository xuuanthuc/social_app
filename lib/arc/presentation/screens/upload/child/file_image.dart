import 'package:flutter/material.dart';
import 'dart:io';
class FullImageFileScreen extends StatelessWidget {
  final File image;

  const FullImageFileScreen({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Image.file(
          image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
