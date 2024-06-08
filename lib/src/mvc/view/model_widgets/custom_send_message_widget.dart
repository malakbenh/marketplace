import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:photo_gallery/photo_gallery.dart';

import '../../../tools.dart';
import '../../model/models.dart';
import '../dialogs/image_pickers/multi_image_picker.dart';
import 'custom_text_form_field copy.dart';

class CustomSendMessageWidget extends StatefulWidget {
  const CustomSendMessageWidget({
    super.key,
    required this.chat,
  });

  final Chat chat;

  @override
  State<CustomSendMessageWidget> createState() =>
      _CustomSendMessageWidgetState();
}

class _CustomSendMessageWidgetState extends State<CustomSendMessageWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        12.sp,
        12.sp,
        12.sp,
        MediaQuery.of(context).viewPadding.bottom + 12.sp,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Styles.black.shade500.withOpacity(0.3),
            offset: const Offset(0.0, 2.0),
            blurRadius: 5.0,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              Icons.photo,
              color: context.primary,
              size: 34.sp,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MultiImagePicker(
                    mediumType: MediumType.image,
                    limit: 5,
                    onPick: (medias) async {
                      for (var media in medias) {
                        await sendImageMessage(media);
                      }
                    },
                  ),
                ),
              );
            },
          ),
          12.widthSp,
          Expanded(
            child: CustomTextFormFieldChat(
              controller: _controller,
              hintText: AppLocalizations.of(context)!.message_hint,
              colorBorderOnFocus: false,
              contentPadding: EdgeInsets.symmetric(
                vertical: 12.sp,
                horizontal: 12.sp,
              ),
              fillColor: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .color!
                  .withOpacity(0.3),
              onEditingComplete: sendTextMessage,
              textInputAction: TextInputAction.send,
            ),
          ),
          SizedBox(width: 12.sp),
          ElevatedButton(
            onPressed: sendTextMessage,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 6.sp, horizontal: 12.sp),
              minimumSize: Size(48.sp, 48.sp),
              fixedSize: Size(48.sp, 48.sp),
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.sp),
              ),
            ),
            child: Icon(
              Icons.send,
              size: 22.sp,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> sendImageMessage(MediaNotifier media) async {
    await widget.chat.send(
      Message.toImageMessage(
        chat: widget.chat,
        photoPath: media.file!.path,
        imageAspectRatio: await media.getImageAspectRatio(),
      ),
    );
  }

  void sendTextMessage() {
    if (_controller.text.isEmpty) return;
    widget.chat.send(
      Message.toTextMessage(
        chat: widget.chat,
        message: _controller.text,
      ),
    );
    _controller.text = '';
  }
}
