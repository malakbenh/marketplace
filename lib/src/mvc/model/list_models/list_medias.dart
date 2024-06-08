import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../tools.dart';
import '../models.dart';

class ListMedias with ChangeNotifier {
  Album? album;
  List<Album> listAlbums = [];
  MediaPage? page;
  List<MediaNotifier> list = [];
  bool isLoading = false;
  int limit;
  int pickLimit;
  bool ignoreGuidlines;
  late ScrollController controller;
  bool hasPermission = true;

  ListMedias({
    required this.limit,
    required this.pickLimit,
    this.ignoreGuidlines = true,
  });

  void updateList(
    List<MediaNotifier> resultList,
    bool refresh,
  ) {
    if (refresh) {
      list.clear();
    }
    list.addAll(resultList);
    isLoading = false;
    notifyListeners();
  }

  Future<void> get(
    BuildContext context, {
    required MediumType mediumType,
    bool refresh = false,
  }) async {
    if (!refresh && (isNotNull || isLoading || !hasPermission)) {
      return;
    }
    if (!refresh) {
      controller = ScrollController();
      controller.addListener(() {
        if (controller.position.maxScrollExtent == controller.offset) {
          getMore(context);
        }
      });
    }
    isLoading = true;

    if (!await Permissions.of(context).getPhotoLibraryPermission()) {
      isLoading = false;
      hasPermission = false;
      notifyListeners();
      return;
    }
    hasPermission = true;
    listAlbums = await PhotoGallery.listAlbums(
      mediumType: mediumType,
      newest: true,
    );
    album = listAlbums.firstWhere(
      (album) => album.isAllAlbum == true,
      orElse: () => listAlbums.first,
    );
    page = await album!.listMedia(
      take: limit,
    );
    updateList(
      page!.items
          .map(
            (element) => MediaNotifier.fromMedium(
              element,
              pickedMedias,
            ),
          )
          .toList(),
      refresh,
    );
  }

  Future<void> changeAlbum(
    BuildContext context, {
    required Album album,
  }) async {
    controller.dispose();
    controller = ScrollController();
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        getMore(context);
      }
    });
    this.album = album;
    page = await album.listMedia(
      take: limit,
    );
    updateList(
      page!.items
          .map(
            (element) => MediaNotifier.fromMedium(
              element,
              pickedMedias,
            ),
          )
          .toList(),
      true,
    );
  }

  Future<void> getMore(BuildContext context) async {
    if (isNull || isLoading || !hasMore) {
      return;
    }
    isLoading = true;
    var hasNotPermission =
        await Permissions.of(context).getPhotoLibraryPermission();
    if (hasNotPermission) {
      isLoading = false;
      return;
    }
    page = await page!.nextPage();
    updateList(
      page!.items
          .map(
            (element) => MediaNotifier.fromMedium(element),
          )
          .toList(),
      false,
    );
  }

  bool get hasMore => page != null && !page!.isLast;

  bool get isEmpty => list.isEmpty && !isNull;

  bool get isNotEmpty => list.isNotEmpty;

  bool get isNotNull => !isNull;

  bool get isNull => page == null && hasPermission;

  int get length => list.length;

  int get pickedLength => pickedMedias.length;

  bool get pickedIsEmpty => pickedMedias.isEmpty;

  bool get pickedIsNotEmpty => pickedMedias.isNotEmpty;

  bool get pickedIsFull => pickedMedias.length >= pickLimit;

  MediaNotifier elementAt(int index) => list.elementAt(index);

  List<MediaNotifier> get pickedMedias =>
      list.where((element) => element.index >= 0).toList();

  bool pickedExistsById(MediaNotifier media) =>
      pickedMedias.where((element) => element.id == media.id).isNotEmpty;

  bool pickedNotExistsById(MediaNotifier media) =>
      pickedMedias.where((element) => element.id == media.id).isEmpty;

  bool canInsert(
    BuildContext? context, {
    required MediaNotifier media,
  }) {
    if (pickLimit == 1 && pickedMedias.isNotEmpty) {
      pickedClear();
    } else if (context != null && pickedIsFull) {
      context.showSnackBar(
        AppLocalizations.of(context)!.snackbar_upload_limited(10),
        duration: const Duration(seconds: 1),
      );
      return false;
    }
    return true;
  }

  void pickedClear() {
    // ignore: avoid_function_literals_in_foreach_calls
    pickedMedias.forEach((element) {
      element.setIndex(-1);
    });
  }

  void pickedUpdateIndex(MediaNotifier media, int index) {
    media.setIndex(index);
  }

  // void pickedRemoveWhere(bool Function(MediaNotifier) test) {
  //   pickedMedias.where(test);
  //   notifyListeners();
  // }

  void pickedDecrementAfterWhere(int index) {
    pickedMedias.where((element) => element.index > index).forEach((element) {
      element.decerementIndex();
    });
    // notifyListeners();
  }
}
