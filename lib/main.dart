import 'package:easybit/app/routes/pages.dart';
import 'package:easybit/app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() => runApp(
  GetMaterialApp(
    //unknownRoute: GetPage(name: '/notfound', page: () => UnknownPage()),
    initialRoute: Routes.HOME,
    getPages: pageRoutes.route,
    title: "Auditoria Concorrente",
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      backgroundColor: Color(0xff219653),
      appBarTheme: AppBarTheme(color: Color(0xff6FCF97)),
    ),
  ),
);
