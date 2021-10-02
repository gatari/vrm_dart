import 'dart:io';
import 'dart:typed_data';

import 'package:vrm_dart/vrm_dart.dart';
import 'package:test/test.dart';

void main() {
  test('load', () {
    final bytes = File.fromUri(Uri.file('./test/sample.vrm')).readAsBytesSync();
    final byteData = ByteData.view(bytes.buffer);

    final parser = VrmFileParser(byteData);
    parser.parse();

    expect(parser.vrmMeta, isNotNull);
    print(parser.vrmMeta.toJson());
  });
}
