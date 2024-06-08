import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppStyles {
  static final titleone = GoogleFonts.poppins(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: const Color(0xff000000),
  );
  static final titletwo = GoogleFonts.inter(
    fontSize: 15,
    letterSpacing: 1.2,
    fontWeight: FontWeight.w400,
    color: const Color(0xff737272),
  );
  static final textStyle16 = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: const Color(0xff000000),
  );
  static const textStyle14 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );
}
