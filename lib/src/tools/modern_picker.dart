import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:path_provider/path_provider.dart';

import '../mvc/model/models.dart';
import '../mvc/view/dialogs/image_pickers/multi_image_picker.dart';
import '../tools.dart';

class ModernPicker {
  final BuildContext context;

  ModernPicker(this.context);

  static ModernPicker of(BuildContext context) {
    assert(context.mounted);
    return ModernPicker(context);
  }

  // static void showModernSingleImagePicker(
  //   BuildContext context, {
  //   /// On confirm picked images.
  //   required Future<void> Function(MediaNotifier) onPick,
  //   CropStyle cropStyle = CropStyle.rectangle,
  //   CropAspectRatio? cropAspectRatio,
  //   List<CropAspectRatioPreset> aspectRatioPresets = const [],
  // }) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => SingleImagePicker(
  //         mediumType: MediumType.image,
  //         cropAspectRatio: cropAspectRatio,
  //         aspectRatioPresets: aspectRatioPresets,
  //         cropStyle: cropStyle,
  //         onPick: onPick,
  //       ),
  //     ),
  //   );
  // }

  static Future<File> compressMedia(
    MediaNotifier media, {
    int minWidth = 1080,
    int minHeight = 1080,
    int quality = 70,
  }) async {
    if (media.mediumType == MediumType.image) {
      File? result = await compressImage(
        media.file!.path,
      );
      return result!;
    } else {
      throw Exception('Compressing videos require package VideoCompress');
    }
  }

  ///upload image from local storage [photoPath] with [fileName] to `cloud storage`
  static Future<String> uploadImageFile({
    required String photoPath,
    required String root,
    required String fileName,
    // required bool compress,
  }) async {
    File? file =
        //  compress
        //     ? await compressImage(photoPath) ?? File(photoPath)
        //     :
        File(photoPath);
    UploadTask uploadTask;
    Reference ref =
        FirebaseStorage.instance.ref().child(root).child('/$fileName.jpg');
    uploadTask = ref.putFile(file);
    await uploadTask.whenComplete(() async {});
    return await uploadTask.snapshot.ref.getDownloadURL();
  }

  static void showModernMultiImagePicker(
    BuildContext context, {
    /// On confirm picked images.
    required Future<void> Function(List<MediaNotifier>) onPick,

    /// Limit of the number of images
    int limit = 1,

    /// Update aspectRatio in MediaNotifier.
    bool updateAspectRatio = true,

    /// Aspect ratio of the picker card
    double cardAspectRatio = 1,
  }) {
    //consider adding permission handling
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiImagePicker(
          mediumType: MediumType.image,
          limit: limit,
          updateAspectRatio: updateAspectRatio,
          cardAspectRatio: cardAspectRatio,
          onPick: onPick,
        ),
      ),
    );
  }

  static Future<void> showClassicSingleImagePicker(
    BuildContext context, {
    required ImageSource source,
    required double? maxWidth,
    required double? maxHeight,
    required int? imageQuality,
    required void Function(XFile) onPicked,
    bool checkPermission = false,
  }) async {
    if (checkPermission) {
      if (source == ImageSource.camera &&
          await Permissions.of(context).showCameraPermission()) {
        return;
      }
      if (source == ImageSource.gallery &&
          // ignore: use_build_context_synchronously
          await Permissions.of(context).showPhotoLibraryPermission()) {
        return;
      }
    }
    final ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(
      source: source,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
      imageQuality: imageQuality,
    );
    if (file == null) return;
    onPicked(file);
  }

  static Future<File?> compressImage(
    String photoPath, {
    int minWidth = 1080,
    int minHeight = 1080,
    int quality = 70,
  }) async {
    final dir = await getTemporaryDirectory();
    XFile? file = await FlutterImageCompress.compressAndGetFile(
      photoPath,
      '${dir.absolute.path}/compressed.jpg',
      minWidth: minWidth,
      minHeight: minHeight,
      quality: quality,
    );

    if (file != null) {
      return File(file.path);
    } else {
      return null;
    }
  }

  ///upload image from local storage [photoPath] with [fileName] to `cloud storage`
  static Future<String> uploadImage({
    required String photoPath,
    required String root,
    required String fileName,
    required bool compress,
  }) async {
    File? file = compress
        ? await compressImage(photoPath) ?? File(photoPath)
        : File(photoPath);
    UploadTask uploadTask;
    Reference ref =
        FirebaseStorage.instance.ref().child(root).child('/$fileName.jpg');
    uploadTask = ref.putFile(file);
    await uploadTask.whenComplete(() async {});
    return await uploadTask.snapshot.ref.getDownloadURL();
  }

  static Future<double> getImageAspectRatioFromPath(String imagePath) async {
    File image = File(imagePath);
    var decodedImage = await decodeImageFromList(image.readAsBytesSync());
    Size size =
        Size(decodedImage.width.toDouble(), decodedImage.height.toDouble());
    return size.aspectRatio;
  }

  static Future<Size> getImageSizeFromFile(File image) async {
    var decodedImage = await decodeImageFromList(image.readAsBytesSync());
    Size size =
        Size(decodedImage.width.toDouble(), decodedImage.height.toDouble());
    return size;
  }
}
