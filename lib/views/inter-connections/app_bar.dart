import 'package:flutter/material.dart';

PreferredSizeWidget buildAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.red,
    title: const Text(
      "DİJİTAL GÜVENLİK",
      style: TextStyle(fontSize: 25, letterSpacing: 1),
    ),
    leading: Builder(
      builder: (BuildContext context) {
        return IconButton(
          icon: const Icon(Icons.menu, size: 40,),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        );
      },
    ),
  );
}
