import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vitafit/src/mvc/model/models/user_session.dart';
import 'mvc/controller/authentication_wrapper.dart';
import 'mvc/model/models/user_min.dart';
import 'mvc/view/screens.dart';
import 'settings/settings_controller.dart';
import 'tools/styles.dart';

bool showSplashScreen = false;
const Color primary = Color(0xff35a072);
const Color secondary = Color(0xffEE7A53);

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
    required this.userSession,
    required this.currentUser,
  });

  final SettingsController settingsController;
  final UserSession userSession;
  final UserMin currentUser;

  void hideSplashScreen() {
    showSplashScreen = false;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      builder: (context, widget) {
        return AnimatedBuilder(
          animation: settingsController,
          builder: (BuildContext context, Widget? child) {
            return MaterialApp(
              restorationScopeId: 'app',
              debugShowCheckedModeBanner: false,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en', ''), // English, no country code
              ],
              onGenerateTitle: (BuildContext context) =>
                  AppLocalizations.of(context)!.appTitle,
              theme: getLightTheme(),
              themeMode: settingsController.themeMode,
              routes: {
                SearchScreen.pageRoute: (context) => const SearchScreen(),
                ViewAll.pageRaute: (context) => const ViewAll(),
                Profile.pageRoute: (context) => Profile(
                      firstName: '',
                      photoUrl: '',
                      currentUser: currentUser, // Pass currentUser here
                    ),
                SplashPayment.pageRaute: (context) => const SplashPayment(),
                PaymentMethod.pageRaute: (context) => const PaymentMethod(),
                AddCard.pageRoute: (context) => const AddCard(),
                EndPayment.pageRaute: (context) =>
                    EndPayment(userSession: userSession),
                HomePageClient.pageRoute: (context) =>
                    HomePageClient(userSession: userSession),
              },
              locale: settingsController.localeMode,
              home: HomeStore()
              /*AuthenticationWrapper(
                showSplashScreen: showSplashScreen,
                hideSplashScreen: hideSplashScreen,
                settingsController: settingsController,
              ),*/
            );
          },
        );
      },
    );
  }

  ThemeData getLightTheme() {
    ThemeData defaultTheme = ThemeData.light(useMaterial3: false);
    return defaultTheme.copyWith(
      floatingActionButtonTheme:
          defaultTheme.floatingActionButtonTheme.copyWith(
        elevation: 3,
        backgroundColor: primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.sp),
        ),
      ),
      primaryColor: primary,
      colorScheme: defaultTheme.colorScheme.copyWith(
        primary: primary,
        secondary: secondary,
      ),
      scaffoldBackgroundColor: Colors.white,
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      buttonTheme: const ButtonThemeData(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: primary,
        selectionColor: primary.withAlpha(100),
        selectionHandleColor: primary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        titleTextStyle: Styles.poppins(
          fontSize: 16.sp,
          color: Colors.black,
          fontWeight: Styles.semiBold,
        ),
        centerTitle: true,
        elevation: 0,
        actionsIconTheme: const IconThemeData(color: Colors.black),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemStatusBarContrastEnforced: true,
          statusBarColor: Colors.transparent, // only for Android
          statusBarIconBrightness: Brightness.dark, // only for Android
          statusBarBrightness: Brightness.light, // only for iOS
          systemNavigationBarContrastEnforced: true,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
      ),
      textTheme: defaultTheme.textTheme.copyWith(
        displayLarge: const TextStyle(color: Color(0xFF000000)),
        displayMedium: const TextStyle(color: Color(0xFF0C121A)),
        displaySmall: const TextStyle(color: Color(0xFF565656)),
        headlineLarge: const TextStyle(color: Color(0xFFB4B4B4)),
        headlineMedium: const TextStyle(color: Color(0xFFE7E7E7)),
        headlineSmall: const TextStyle(color: Color(0xFFFFFFFF)),
        titleLarge: const TextStyle(color: Color(0xFFFFFFFF)),
      ),
    );
  }
}
