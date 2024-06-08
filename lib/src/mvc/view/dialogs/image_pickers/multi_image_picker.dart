import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

class MultiImagePicker extends StatelessWidget {
  const MultiImagePicker({
    super.key,
    required this.onPick,
    required this.mediumType,
    this.updateAspectRatio = false,
    this.cardAspectRatio = 1,
    this.limit = 5,
  });

  final Future<void> Function(List<MediaNotifier>) onPick;
  final MediumType mediumType;
  final double cardAspectRatio;
  final int limit;
  final bool updateAspectRatio;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: ListMedias(
        limit: 30,
        pickLimit: limit,
      ),
      child: Consumer<ListMedias>(
        builder: (context, listMedias, _) {
          listMedias.get(
            context,
            mediumType: mediumType,
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
                    Platform.isAndroid
                        ? Icons.arrow_back
                        : Icons.arrow_back_ios,
                  )),
              title: listMedias.listAlbums.isEmpty
                  ? const SizedBox.shrink()
                  : CustomDropDownButton<Album?>(
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
              actions: [
                TextButton(
                  onPressed: () async {
                    if (listMedias.pickedMedias.isEmpty) return;
                    await onPick(listMedias.pickedMedias).then(
                      (_) => Navigator.pop(context),
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context)!.ok,
                    style: context.h5b1.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: Styles.semiBold,
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
                    childAspectRatio: cardAspectRatio,
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
        showIndex: true,
        media: listMedias.elementAt(index),
        aspectRatio: cardAspectRatio,
        listMedias: listMedias,
        updateAspectRatio: updateAspectRatio,
      );
    }
    if (index == 0) {
      return CustomTypePickerButton(
        label: AppLocalizations.of(context)!.camera,
        aspectRatio: cardAspectRatio,
        icon: mediumType == MediumType.image
            ? Icons.camera_alt_outlined
            : Icons.video_camera_back_outlined,
        onTap: mediumType == MediumType.image
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
          onPick([media]);
          Navigator.pop(context);
        },
      );
}
