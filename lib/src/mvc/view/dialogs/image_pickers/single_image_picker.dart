import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../tools.dart';
import '../../../model/list_models/list_medias.dart';
import '../../../model/models.dart';
import '../../model_widgets.dart';
import '../../model_widgets/custom_drop_down_button.dart';
import '../../model_widgets/custom_type_picker_button.dart';
import '../../tiles/modern_picker_tiles/media_picker_tile.dart';

class SingleImagePicker extends StatefulWidget {
  const SingleImagePicker({
    super.key,
    required this.onPick,
    required this.mediumType,
    this.updateAspectRatio = false,
    this.cropStyle = CropStyle.rectangle,
    this.aspectRatio = 1,
    this.cropAspectRatio,
    this.aspectRatioPresets = const [],
  }) : assert(cropAspectRatio == null || aspectRatioPresets.length > 0);

  final Future<void> Function(MediaNotifier) onPick;
  final MediumType mediumType;
  final CropStyle cropStyle;
  final double aspectRatio;
  final CropAspectRatio? cropAspectRatio;
  final List<CropAspectRatioPreset> aspectRatioPresets;
  final bool updateAspectRatio;

  @override
  State<SingleImagePicker> createState() => _SingleImagePickerState();
}

class _SingleImagePickerState extends State<SingleImagePicker> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: ListMedias(
        limit: 30,
        pickLimit: 1,
      ),
      child: Consumer<ListMedias>(
        builder: (context, listMedias, _) {
          listMedias.get(
            context,
            mediumType: widget.mediumType,
          );
          return Scaffold(
            appBar: AppBar(
              centerTitle: Platform.isIOS ? true : false,
              backgroundColor: Colors.black,
              elevation: 0.2,
              iconTheme: const IconThemeData(
                color: Colors.white,
              ),
              leading: IconButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
                ),
              ),
              title: listMedias.listAlbums.isEmpty
                  ? const SizedBox.shrink()
                  : SizedBox(
                      width: 0.7.sw,
                      child: CustomDropDownButton<Album?>(
                        value: listMedias.album,
                        fontSize: 16.sp,
                        getText: (context, album) => album?.name ?? 'Unknown',
                        items: listMedias.listAlbums,
                        onChanged: (album) {
                          if (album == null) return;
                          listMedias.changeAlbum(
                            context,
                            album: album,
                          );
                        },
                      ),
                    ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (listMedias.pickedMedias.isEmpty) return;
                    if (widget.cropAspectRatio != null) {
                      ImageCropper().cropImage(
                        sourcePath: listMedias.pickedMedias.first.file!.path,
                        maxWidth: 512,
                        maxHeight: 512,
                        compressFormat: ImageCompressFormat.png,
                        cropStyle: widget.cropStyle,
                        aspectRatio: widget.cropAspectRatio,
                        aspectRatioPresets: widget.aspectRatioPresets,
                        uiSettings: [
                          AndroidUiSettings(
                            activeControlsWidgetColor:
                                Theme.of(context).primaryColor,
                            toolbarTitle: 'Cropper',
                            toolbarColor: Theme.of(context).primaryColor,
                            toolbarWidgetColor: Colors.white,
                            initAspectRatio:
                                widget.aspectRatioPresets.isNotEmpty
                                    ? widget.aspectRatioPresets.first
                                    : null,
                            lockAspectRatio: true,
                          ),
                          IOSUiSettings(
                            minimumAspectRatio: widget.cropAspectRatio!.ratioX /
                                widget.cropAspectRatio!.ratioY,
                            title: 'Cropper',
                            aspectRatioLockEnabled: true,
                            aspectRatioPickerButtonHidden: true,
                            aspectRatioLockDimensionSwapEnabled: true,
                            rotateButtonsHidden: true,
                          ),
                        ],
                      ).then((croppedFile) {
                        if (croppedFile != null) {
                          widget.onPick(
                            MediaNotifier.fromFile(
                              File(croppedFile.path),
                              MediumType.image,
                              null,
                            ),
                          );
                        }
                        Navigator.pop(context);
                      });
                    } else {
                      widget.onPick(listMedias.pickedMedias.first);
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context)!.ok,
                    style: Styles.poppins(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: Styles.semiBold,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.black,
            body: Builder(
              builder: (context) {
                if (listMedias.isNull) {
                  return CustomLoadingIndicator(
                    margin: EdgeInsets.only(top: 20.h),
                    isSliver: false,
                  );
                }
                if (listMedias.hasPermission) {
                  //when has no permission, open app settings or refresh.
                }
                return GridView.builder(
                  controller: listMedias.controller,
                  physics: const ClampingScrollPhysics(),
                  itemCount: listMedias.length + 1,
                  itemBuilder: (context, index) => builderMediaCard(
                    context,
                    index,
                    listMedias,
                  ),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 0.35.sw,
                    childAspectRatio: widget.aspectRatio,
                    crossAxisSpacing: 2.sp,
                    mainAxisSpacing: 2.sp,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget builderMediaCard(
    BuildContext context,
    int index,
    ListMedias listMedias,
  ) {
    if (index > 0) {
      index -= 1;
      return MediaPickerTile(
        media: listMedias.elementAt(index),
        aspectRatio: widget.aspectRatio,
        listMedias: listMedias,
        updateAspectRatio: widget.updateAspectRatio,
      );
    }
    if (index == 0) {
      return CustomTypePickerButton(
        label: AppLocalizations.of(context)!.camera,
        aspectRatio: widget.aspectRatio,
        icon: widget.mediumType == MediumType.image
            ? Icons.camera_alt_outlined
            : Icons.video_camera_back_outlined,
        onTap: widget.mediumType == MediumType.image
            ? () => pickFromCamera(context, listMedias)
            : () => throw Exception('Picking videos is not implemented'),
      );
    }
    return const SizedBox.shrink();
  }

  Future<void> pickFromCamera(
    BuildContext context,
    ListMedias listMedias,
  ) async =>
      await ModernPicker.showClassicSingleImagePicker(
        context,
        source: ImageSource.camera,
        maxHeight: 1080,
        maxWidth: 1080,
        imageQuality: 100,
        onPicked: (file) {
          MediaNotifier media = MediaNotifier.fromXFile(
            file,
            MediumType.image,
            null,
          );
          widget.onPick(media);
          Navigator.pop(context);
        },
      );
}
