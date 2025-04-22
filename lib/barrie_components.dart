// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:js_interop';

import 'dart:ui';
import 'dart:ui_web' as ui_web;

import 'package:flutter/widgets.dart';

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

void main() {
  runWidget(MultiViewApp(
    viewBuilder: (BuildContext context) => const WidgetChooserApp(),
  ));
}

class WidgetChooserApp extends StatelessWidget {
  const WidgetChooserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return _viewSelector(context);
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
      _ => const Center(
          child: Text('Unknown component'),
        ),
    };
  }

  Center _square(BuildContext context, InitialData initialData) {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        color: const Color(0xFF0000FF), // Blue color
      ),
    );
  }

  Center _circle(BuildContext context, InitialData initialData) {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: const BoxDecoration(
          color: Color(0xFFFF0000), // Red color
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
