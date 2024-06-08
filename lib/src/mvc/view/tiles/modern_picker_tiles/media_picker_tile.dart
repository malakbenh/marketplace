import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:provider/provider.dart';

import '../../../../tools.dart';
import '../../../model/list_models/list_medias.dart';
import '../../../model/models.dart';
import '../../dialogs/slideshows.dart';

class MediaPickerTile extends StatelessWidget {
  const MediaPickerTile({
    super.key,
    required this.media,
    required this.aspectRatio,
    required this.listMedias,
    required this.updateAspectRatio,
    this.showIndex = false,
  });

  final MediaNotifier media;
  final double aspectRatio;
  final ListMedias listMedias;
  final bool showIndex;
  final bool updateAspectRatio;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: media,
      child: Consumer<MediaNotifier>(
        builder: (context, medium, _) {
          return FutureBuilder(
            future: medium.requireFile ? medium.initFile() : null,
            builder: (context, imageFile) {
              return InkResponse(
                onLongPress: () {
                  if (!medium.haveFile) return;
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => SingleImageSlideshow(
                      image: Image.file(medium.file!).image,
                    ),
                    backgroundColor: Colors.black,
                    enableDrag: true,
                    isScrollControlled: true,
                    isDismissible: true,
                  );
                },
                onTap: () => media.onToggle(
                  context,
                  listMedias: listMedias,
                  updateAspectRatio: updateAspectRatio,
                ),
                child: AspectRatio(
                  aspectRatio: aspectRatio,
                  child: Container(
                    decoration: medium.haveFile
                        ? BoxDecoration(
                            image: DecorationImage(
                              image: medium.isMedium
                                  ? ThumbnailProvider(
                                      mediumId: medium.id!,
                                      mediumType: medium.mediumType,
                                      highQuality: true,
                                    )
                                  : Image.file(medium.file!).image,
                              fit: BoxFit.cover,
                            ),
                          )
                        : null,
                    alignment: Alignment.center,
                    child: medium.haveFile
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              medium.picked
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        if (showIndex)
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 7.sp,
                                            ),
                                            padding: EdgeInsets.all(5.sp),
                                            decoration: BoxDecoration(
                                              color: context.primary,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 2.sp,
                                              ),
                                            ),
                                            child: Text(
                                              '${media.index}',
                                              style: Styles.poppins(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.sp,
                                              ),
                                            ),
                                          ),
                                        if (!showIndex)
                                          Container(
                                            margin: EdgeInsets.all(3.sp),
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.check_circle,
                                              size: 24.sp,
                                              color: context.primary,
                                            ),
                                          ),
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                              if (medium.mediumType == MediumType.video)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(5.sp),
                                      child: Icon(
                                        Icons.video_camera_back,
                                        size: 20.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          )
                        : null,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
