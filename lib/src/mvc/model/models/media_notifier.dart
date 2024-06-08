import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../tools.dart';
import '../list_models/list_medias.dart';

class MediaNotifier with ChangeNotifier {
  final Medium? media;
  File? file;
  String? fileUrl;
  // File? thumbnail;
  // String? thumbnailUrl;
  bool picked = false;
  int index = -1;
  Size? size;
  final DateTime? creationDate;
  final DateTime? modifiedDate;
  final MediumType mediumType;
  double? aspectRatio;

  MediaNotifier({
    required this.media,
    required this.index,
    required this.picked,
    required this.file,
    required this.creationDate,
    required this.modifiedDate,
    required this.mediumType,
    // required this.thumbnail,
    this.aspectRatio,
  });

  factory MediaNotifier.fromMedium(
    Medium medium, [
    List<MediaNotifier> listMedium = const [],
  ]) {
    int index = listMedium.map((e) => e.media).toList().indexOf(medium);
    if (index > -1) {
      index++;
    }
    return MediaNotifier(
      media: medium,
      index: index,
      picked: index > 0,
      file: null,
      creationDate: medium.creationDate,
      modifiedDate: medium.modifiedDate,
      mediumType: medium.mediumType ?? MediumType.image,
      // thumbnail: null,
    );
  }

  factory MediaNotifier.fromFile(
    File file,
    MediumType mediumType,
    File? thumbnail,
  ) {
    return MediaNotifier(
        media: null,
        index: -1,
        picked: false,
        file: file,
        creationDate: null,
        modifiedDate: null,
        mediumType: mediumType
        // thumbnail: thumbnail,
        );
  }

  factory MediaNotifier.fromXFile(
    XFile file,
    MediumType mediumType,
    File? thumbnail,
  ) {
    return MediaNotifier(
        media: null,
        index: -1,
        picked: false,
        file: File(file.path),
        creationDate: null,
        modifiedDate: null,
        mediumType: mediumType
        // thumbnail: thumbnail,
        );
  }

  Future<void> initFile() async {
    file = await media?.getFile();
  }

  // String? get photoUrl => thumbnailUrl ?? fileUrl;

  bool get requireFile => media != null && file == null;

  bool get haveFile => file != null;

  String? get id => media?.id;

  bool get isMedium => media != null;

  bool get isImage => media == null && file != null; // && thumbnail == null;

  void setIndex(int index) {
    if (index == -1 && picked) {
      picked = false;
      this.index = -1;
    } else {
      picked = true;
      if (!picked) {
        this.index = -1;
      } else {
        this.index = index;
      }
    }
    notifyListeners();
  }

  void incrementIndex() {
    index++;
    notifyListeners();
  }

  void decerementIndex() {
    index--;
    notifyListeners();
  }

  Future<void> onToggle(
    BuildContext context, {
    required ListMedias listMedias,
    required bool updateAspectRatio,
  }) async {
    if (updateAspectRatio) {
      getImageAspectRatio();
    }
    if (file == null) return;
    if (index >= 0) {
      listMedias.pickedDecrementAfterWhere(index);
      setIndex(-1);
      return;
    }
    if (listMedias.pickLimit == 1 && listMedias.pickedIsNotEmpty) {
      listMedias.pickedClear();
    }
    if (listMedias.pickedIsFull) {
      context.showSnackBar(
        AppLocalizations.of(context)!
            .snackbar_upload_limited(listMedias.pickLimit),
        duration: const Duration(seconds: 1),
      );
      return;
    }
    if (listMedias.canInsert(null, media: this)) {
      setIndex(listMedias.pickedLength + 1);
    }
  }

  Future<void> updateImageSize() async {
    if (file != null && size == null) {
      size = await ModernPicker.getImageSizeFromFile(file!);
    }
  }

  Future<void> uploadMedia({
    required String root,
    required String id,
    void Function(TaskSnapshot)? uploadListener,
  }) async {
    File? compressedFile = await ModernPicker.compressMedia(this);
    UploadTask uploadTask;
    String extension = '.jpg';
    Reference ref =
        FirebaseStorage.instance.ref().child(root).child('/$id$extension');
    uploadTask = ref.putFile(compressedFile);
    uploadTask.snapshotEvents.listen(
      uploadListener,
    );
    await uploadTask.whenComplete(() async {});
    fileUrl = await uploadTask.snapshot.ref.getDownloadURL();
    compressedFile.delete();
  }

  Future<double> getImageAspectRatio() async {
    aspectRatio ??= await ModernPicker.getImageAspectRatioFromPath(file!.path);
    return aspectRatio!;
  }
}
