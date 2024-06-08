import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:poducts/core/shared_data.dart';

import '../screens/main_coach/add _new _product/core/shared_data.dart';

class PickImageBottomSheet extends StatefulWidget {
  const PickImageBottomSheet({super.key});

  @override
  State<PickImageBottomSheet> createState() => _PickImageBottomSheetState();
}

class _PickImageBottomSheetState extends State<PickImageBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 15),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * .02,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () async {
                final ImagePicker picker = ImagePicker();
                // Pick an image
                final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery, imageQuality: 80);
                if (image != null) {
                  log('Image path: ${image.path} -- MimeType ${image.mimeType}');
                  setState(() {
                    SharedData.productImage = image.path;
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: const CircleBorder(),
                  fixedSize: Size(MediaQuery.of(context).size.width * .3,
                      MediaQuery.of(context).size.height * .15)),
              child: Image.asset('assets/images/photo.png'),
            ),
            ElevatedButton(
              onPressed: () async {
                final ImagePicker picker = ImagePicker();
                // Pick an image
                final XFile? image = await picker.pickImage(
                    source: ImageSource.camera, imageQuality: 80);
                if (image != null) {
                  log('Image path: ${image.path}');
                  setState(() {
                    SharedData.productImage = image.path;
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: const CircleBorder(),
                  fixedSize: Size(MediaQuery.of(context).size.width * .3,
                      MediaQuery.of(context).size.height * .15)),
              child: Image.asset('assets/images/camera.png'),
            )
          ],
        )
      ],
    );
  }
}
