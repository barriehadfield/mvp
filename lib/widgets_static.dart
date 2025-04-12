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
  external String get greeting; // Replace 'greeting' with the actual property
}

void main() {
  runWidget(MultiViewApp(
    viewBuilder: (BuildContext context) => const HelloWorld(),
  ));
}

class HelloWorld extends StatelessWidget {
  const HelloWorld({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: _viewSelector(context),
    );
  }

  Widget _viewSelector(BuildContext context) {
    final FlutterView view = View.of(context);

    final InitialData initialData =
        ui_web.views.getInitialData(view.viewId)! as InitialData;

    return switch (View.of(context).viewId) {
      1 => _viewOne(context, initialData),
      2 => _viewTwo(context, initialData),
      _ => const Center(
          child: Text('Unknown view'),
        ),
    };
  }

  Center _viewOne(BuildContext context, InitialData initialData) {
    return Center(
        child: Text(
      'VIEW 1 from View#${View.of(context).viewId}\n'
      'Logical ${MediaQuery.sizeOf(context)}\n'
      'Greeting: ${initialData.greeting}\n'
      'Host Element: ${ui_web.views.getHostElement(View.of(context).viewId)}\n',
    ));
  }

  Center _viewTwo(BuildContext context, InitialData initialData) {
    return Center(
        child: Text(
      'VIEW 2 from View#${View.of(context).viewId}\n'
      'Logical ${MediaQuery.sizeOf(context)}\n'
      'Greeting: ${initialData.greeting}\n'
      'Host Element: ${ui_web.views.getHostElement(View.of(context).viewId)}\n',
    ));
  }
}
