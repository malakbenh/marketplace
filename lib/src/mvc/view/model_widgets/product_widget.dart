import 'package:flutter/material.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({super.key, required this.image, required this.title});
  final String image, title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 377, // العرض
      height: 91, // الارتفاع
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
        ),
        color: Colors.white, // لون الخلفية
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment
            .spaceBetween, // توزيع العناصر
        children: [
          Image.asset(
            image,
            // color: Colors.black,
          ),
          // صورة في أقصى اليسار
          const Padding(
            padding: EdgeInsets.all(8.0),
          ),
          // نص في المنتصف
          SizedBox(
            width: 130,
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.45,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // أيقونتان في أقصى اليمين
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // وظيفة أيقونة القلم
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete,
                    color: Colors.red),
                onPressed: () {
                  // وظيفة أيقونة الحذف
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
