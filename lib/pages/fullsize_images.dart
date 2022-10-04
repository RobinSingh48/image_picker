
import 'package:flutter/material.dart';

class FullSizeImages extends StatefulWidget {
  var userData;
   FullSizeImages({Key? key,required this.userData}) : super(key: key);

  @override
  State<FullSizeImages> createState() => _FullSizeImagesState();
}

class _FullSizeImagesState extends State<FullSizeImages> {
  @override
  Widget build(BuildContext context) {
    return Container(

      child: SingleChildScrollView(
        child: Column(
          children: [
            Image(image: NetworkImage(widget.userData["finalImage"])),
            
          ],
        ),
      ),
    );
  }
}
