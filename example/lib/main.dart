import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vrm_dart_example/app.dart';

void main() {
  runApp(ProviderScope(child: App()));
}
