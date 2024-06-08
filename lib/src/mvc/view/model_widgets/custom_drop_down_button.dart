import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vitafit/src/extensions.dart';

class CustomDropDownButton<T> extends StatelessWidget {
  const CustomDropDownButton({
    Key? key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.getText,
    this.fontSize,
  }) : super(key: key);

  final T value;
  final List<T> items;
  final void Function(T) onChanged;
  final String Function(BuildContext, T) getText;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButton<T>(
          isDense: true,
          isExpanded: false,
          elevation: 0,
          underline: const SizedBox.shrink(),
          style: context.h5b1.copyWith(
            color: Colors.white,
          ),
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10.sp),
          ),
          dropdownColor: Colors.grey[850],
          items: items
              .map(
                (tag) => DropdownMenuItem<T>(
                  value: tag,
                  child: ConstrainedBox(
                    constraints: BoxConstraints.loose(
                      Size(0.5.sw, kToolbarHeight),
                    ),
                    child: Text(
                      getText(context, tag),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value == null) return;
            onChanged(value);
          },
          value: value,
          alignment: Alignment.center,
        ),
      ],
    );
  }
}
