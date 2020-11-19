// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('RichText with recognizers without handlers does not throw', (WidgetTester tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: RichText(
          text: TextSpan(text: 'root', children: <InlineSpan>[
            TextSpan(text: 'one', recognizer: TapGestureRecognizer()),
            TextSpan(text: 'two', recognizer: LongPressGestureRecognizer()),
            TextSpan(text: 'three', recognizer: DoubleTapGestureRecognizer()),
          ]),
        ),
      ),
    );

    expect(tester.getSemantics(find.byType(RichText)), matchesSemantics(
      children: <Matcher>[
        matchesSemantics(
          label: 'root',
          hasTapAction: false,
          hasLongPressAction: false,
        ),
        matchesSemantics(
          label: 'one',
          hasTapAction: false,
          hasLongPressAction: false,
        ),
        matchesSemantics(
          label: 'two',
          hasTapAction: false,
          hasLongPressAction: false,
        ),
        matchesSemantics(
          label: 'three',
          hasTapAction: false,
          hasLongPressAction: false,
        ),
      ],
    ));
  });

  testWidgets('RichText with softWrap can break the text or not',
      (WidgetTester tester) async {
    const double fontSize = 16.0;
    await tester.pumpWidget(Center(
      child: Container(
        width: 200,
        child: RichText(
          textDirection: TextDirection.ltr,
          text: const TextSpan(
              text:
                  'softWrap is used to determine whether the text should break '
                  'at soft line breaks.',
              style: TextStyle(fontSize: fontSize)),
          softWrap: false,
        ),
      ),
    ));

    Size size = tester.getSize(find.byType(RichText));
    final double height = size.height;
    expect(height, fontSize);

    await tester.pumpWidget(Center(
      child: Container(
        width: 200,
        child: RichText(
          textDirection: TextDirection.ltr,
          text: const TextSpan(
              text:
                  'softWrap is used to determine whether the text should break '
                  'at soft line breaks.',
              style: TextStyle(fontSize: fontSize)),
          softWrap: true,
        ),
      ),
    ));

    size = tester.getSize(find.byType(RichText));
    final double newHeight = size.height;

    expect(newHeight, greaterThan(height));
  });
}
