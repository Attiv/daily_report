import 'package:common_utils/common_utils.dart';
import 'package:daily_report/common/const.dart';
import 'package:daily_report/common/transaction.dart';
import 'package:daily_report/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;
import 'package:get_storage/get_storage.dart';

import 'package:responsive_framework/responsive_framework.dart';

void main() async {
  await GetStorage.init();
  GetStorage box = GetStorage();
  if (ObjectUtil.isEmpty(GetStorage().read(kLanguageLanguageCodeKey))) {
    box.write(kLanguageCountryCodeSettingKey, ui.window.locale.countryCode);
    box.write(kLanguageLanguageCodeKey, ui.window.locale.languageCode);
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    GetStorage box = GetStorage();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: Transaction(),
      locale: Locale(
          box.read(kLanguageLanguageCodeKey),
          box.read(
            kLanguageCountryCodeSettingKey,
          )),
      fallbackLocale: const Locale('en', 'US'),
      builder: (context, child) => ResponsiveWrapper.builder(child,
          maxWidth: 800,
          minWidth: 480,
          defaultScale: true,
          breakpoints: [
            ResponsiveBreakpoint.resize(480, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: TABLET),
            ResponsiveBreakpoint.resize(1000, name: DESKTOP),
          ],
          background: Container(color: Color(0xFFF5F5F5))),
      home: Scaffold(
        body: HomePage(),
      ),
    );
  }
}
