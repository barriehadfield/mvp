// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:js_interop';

import 'dart:ui';
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'src/widgets.dart';

@JS()
@staticInterop
class InitialData {
  // Leave empty or include static interop properties
}

// Define an extension to add getters
extension InitialDataExtension on InitialData {
  external String get component; // name of the widget to display
}

class ColorController extends GetxController {
  final squareColor = Colors.red.obs;
  final circleColor = Colors.blue.obs;

  void swapColor() {
    final temp = squareColor.value;
    squareColor.value = circleColor.value;
    circleColor.value = temp;
  }
}

void main() {
  runWidget(MultiViewApp(
    viewBuilder: (BuildContext context) => WidgetChooserApp(),
  ));
}

class WidgetChooserApp extends StatelessWidget {
  WidgetChooserApp({super.key});

  final _colorController = Get.put(ColorController());

  @override
  Widget build(BuildContext context) {
    // Directionality needed by Material widgets
    return Directionality(
      textDirection: TextDirection.ltr,
      child: _viewSelector(context),
    );
  }

  Widget _viewSelector(BuildContext context) {
    final FlutterView view = View.of(context);

    // THIS IS HOW YOU GET THE INITIAL DATA!!!
    final InitialData initialData =
        ui_web.views.getInitialData(view.viewId)! as InitialData;

    // would be better as an enum of components we support
    return switch (initialData.component) {
      'square' => _square(context, initialData),
      'circle' => _circle(context, initialData),
      'swap' => _swap(context, initialData),
      _ => const Center(
          child: Text('Unknown component'),
        ),
    };
  }

  Center _swap(BuildContext context, InitialData initialData) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          _colorController.swapColor();
        },
        child: const Text('Swap Colours'),
      ),
    );
  }

  Widget _square(BuildContext context, InitialData initialData) {
    return Obx(() => Center(
          child: Container(
            width: 100,
            height: 100,
            color: _colorController.squareColor.value,
          ),
        ));
  }

  Widget _circle(BuildContext context, InitialData initialData) {
    return Obx(() => Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: _colorController.circleColor.value,
              shape: BoxShape.circle,
            ),
          ),
        ));
  }
}
