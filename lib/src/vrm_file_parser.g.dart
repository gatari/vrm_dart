// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vrm_file_parser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GltfJson _$GltfJsonFromJson(Map<String, dynamic> json) => GltfJson(
      json['extensions'] as Map<String, dynamic>,
      (json['images'] as List<dynamic>)
          .map((e) => GltfImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['bufferViews'] as List<dynamic>)
          .map((e) => GltfBufferView.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GltfJsonToJson(GltfJson instance) => <String, dynamic>{
      'extensions': instance.extensions,
      'images': instance.images.map((e) => e.toJson()).toList(),
      'bufferViews': instance.bufferViews.map((e) => e.toJson()).toList(),
    };

VrmExtension _$VrmExtensionFromJson(Map<String, dynamic> json) => VrmExtension(
      json['exporterVersion'] as String,
      json['specVersion'] as String,
      VrmMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VrmExtensionToJson(VrmExtension instance) =>
    <String, dynamic>{
      'exporterVersion': instance.exporterVersion,
      'specVersion': instance.specVersion,
      'meta': instance.meta.toJson(),
    };

VrmMeta _$VrmMetaFromJson(Map<String, dynamic> json) => VrmMeta(
      json['version'] as String,
      json['author'] as String,
      json['contactInformation'] as String,
      json['title'] as String,
      json['reference'] as String,
      json['allowedUserName'] as String,
      json['violentUssageName'] as String,
      json['sexualUssageName'] as String,
      json['commercialUssageName'] as String,
      json['otherPermissionUrl'] as String,
      json['licenseName'] as String,
      json['otherLicenseUrl'] as String,
    );

Map<String, dynamic> _$VrmMetaToJson(VrmMeta instance) => <String, dynamic>{
      'version': instance.version,
      'author': instance.author,
      'contactInformation': instance.contactInformation,
      'title': instance.title,
      'reference': instance.reference,
      'allowedUserName': instance.allowedUserName,
      'violentUssageName': instance.violentUsageName,
      'sexualUssageName': instance.sexualUsageName,
      'commercialUssageName': instance.commercialUsageName,
      'otherPermissionUrl': instance.otherPermissionUrl,
      'licenseName': instance.licenseName,
      'otherLicenseUrl': instance.otherLicenseUrl,
    };

GltfBufferView _$GltfBufferViewFromJson(Map<String, dynamic> json) =>
    GltfBufferView(
      json['buffer'] as int,
      json['byteOffset'] as int,
      json['byteLength'] as int,
    );

Map<String, dynamic> _$GltfBufferViewToJson(GltfBufferView instance) =>
    <String, dynamic>{
      'buffer': instance.buffer,
      'byteOffset': instance.byteOffset,
      'byteLength': instance.byteLength,
    };

GltfImage _$GltfImageFromJson(Map<String, dynamic> json) => GltfImage(
      json['name'] as String,
      json['bufferView'] as int,
      json['mimeType'] as String,
    );

Map<String, dynamic> _$GltfImageToJson(GltfImage instance) => <String, dynamic>{
      'name': instance.name,
      'bufferView': instance.bufferView,
      'mimeType': instance.mimeType,
    };
