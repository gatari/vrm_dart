import 'dart:convert';
import 'dart:typed_data';

import 'package:collection/src/iterable_extensions.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vrm_file_parser.g.dart';

final Endian _endian = Endian.little;
final int _glbFileHeaderSize = 12;
final int _glbChunkLengthSize = 4;
final int _glbChunkTypeSize = 4;
final int _glbChunkHeaderSize = _glbChunkLengthSize + _glbChunkTypeSize;
final int _glbBodyHeaderSize = 8;

class VrmFileParser {
  final ByteData _byteData;

  late VrmMeta vrmMeta;
  late Uint8List? thumbnailByteData;

  VrmFileParser(this._byteData);

  void parse() {
    // https://kcoley.github.io/glTF/extensions/1.0/Khronos/KHR_binary_glTF/
    final magic = Uint8List.sublistView(_byteData, 0, 4);
    if (ascii.decode(magic) != 'glTF') {
      throw Exception('this is not glTF');
    }
    final contentLength = _byteData.getUint32(_glbFileHeaderSize, _endian);
    final jsonChunk = Uint8List.view(_byteData.buffer,
        _glbFileHeaderSize + _glbChunkHeaderSize, contentLength);
    final jsonText = utf8.decode(jsonChunk);
    final json = jsonDecode(jsonText) as Map<String, dynamic>;

    final vrmJson = GltfJson.fromJson(json);
    if (vrmJson.extensions.containsKey('VRM')) {
      final vrm = VrmExtension.fromJson(vrmJson.extensions['VRM']);
      vrmMeta = vrm.meta;
    }

    // get thumbnail
    final thumbnailImage = vrmJson.images
        .firstWhereOrNull((element) => element.name == "Thumbnail");
    if (thumbnailImage == null) {
      thumbnailByteData = null;
      return;
    }
    final view = vrmJson.bufferViews[thumbnailImage.bufferView];

    thumbnailByteData = Uint8List.view(
      _byteData.buffer,
      _glbFileHeaderSize +
          _glbChunkHeaderSize +
          contentLength +
          _glbBodyHeaderSize +
          view.byteOffset,
      view.byteLength,
    );
  }
}

@JsonSerializable()
class GltfJson {
  final Map<String, dynamic> extensions;
  final List<GltfImage> images;
  final List<GltfBufferView> bufferViews;

  GltfJson(this.extensions, this.images, this.bufferViews);

  factory GltfJson.fromJson(Map<String, dynamic> json) =>
      _$GltfJsonFromJson(json);

  Map<String, dynamic> toJson() => _$GltfJsonToJson(this);
}

@JsonSerializable()
class VrmExtension {
  final String exporterVersion;
  final String specVersion;
  final VrmMeta meta;

  VrmExtension(this.exporterVersion, this.specVersion, this.meta);

  factory VrmExtension.fromJson(Map<String, dynamic> json) =>
      _$VrmExtensionFromJson(json);

  Map<String, dynamic> toJson() => _$VrmExtensionToJson(this);
}

@JsonSerializable()
class VrmMeta {
  final String version;
  final String author;
  final String contactInformation;
  final String title;
  final String reference;
  final String allowedUserName;
  @JsonKey(name: 'violentUssageName')
  final String violentUsageName;
  @JsonKey(name: 'sexualUssageName')
  final String sexualUsageName;
  @JsonKey(name: 'commercialUssageName')
  final String commercialUsageName;
  final String otherPermissionUrl;
  final String licenseName;
  final String otherLicenseUrl;

  VrmMeta(
      this.version,
      this.author,
      this.contactInformation,
      this.title,
      this.reference,
      this.allowedUserName,
      this.violentUsageName,
      this.sexualUsageName,
      this.commercialUsageName,
      this.otherPermissionUrl,
      this.licenseName,
      this.otherLicenseUrl);

  factory VrmMeta.fromJson(Map<String, dynamic> json) =>
      _$VrmMetaFromJson(json);

  Map<String, dynamic> toJson() => _$VrmMetaToJson(this);
}

@JsonSerializable()
class GltfBufferView {
  final int buffer;
  final int byteOffset;
  final int byteLength;

  GltfBufferView(this.buffer, this.byteOffset, this.byteLength);

  factory GltfBufferView.fromJson(Map<String, dynamic> json) =>
      _$GltfBufferViewFromJson(json);

  Map<String, dynamic> toJson() => _$GltfBufferViewToJson(this);
}

@JsonSerializable()
class GltfImage {
  final String name;
  final int bufferView;
  final String mimeType;

  GltfImage(this.name, this.bufferView, this.mimeType);

  factory GltfImage.fromJson(Map<String, dynamic> json) =>
      _$GltfImageFromJson(json);

  Map<String, dynamic> toJson() => _$GltfImageToJson(this);
}
