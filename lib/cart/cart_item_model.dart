import 'dart:convert';

class LicenseTemplate {
  final int id;
  final String name;
  final dynamic mp3;
  final dynamic wav;
  final dynamic zip;
  final String description;
  final dynamic musicRecording;
  final dynamic liveProfit;
  final dynamic distributeCopies;
  final dynamic audioStreams;
  final dynamic radioBroadcasting;
  final dynamic musicVideos;
  final int availableFilesId;
  final String userId;

  LicenseTemplate({
    required this.id,
    required this.name,
    this.mp3,
    this.wav,
    this.zip,
    required this.description,
    this.musicRecording,
    this.liveProfit,
    this.distributeCopies,
    this.audioStreams,
    this.radioBroadcasting,
    this.musicVideos,
    required this.availableFilesId,
    required this.userId,
  });

  factory LicenseTemplate.fromJson(Map<String, dynamic> json) {
    return LicenseTemplate(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      mp3: json['mp3'],
      wav: json['wav'],
      zip: json['zip'],
      description: json['description'] ?? '',
      musicRecording: json['musicRecording'],
      liveProfit: json['liveProfit'],
      distributeCopies: json['distributeCopies'],
      audioStreams: json['audioStreams'],
      radioBroadcasting: json['radioBroadcasting'],
      musicVideos: json['musicVideos'],
      availableFilesId: json['availableFilesId'] ?? 0,
      userId: json['userId'] ?? '00000000-0000-0000-0000-000000000000',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mp3': mp3,
      'wav': wav,
      'zip': zip,
      'description': description,
      'musicRecording': musicRecording,
      'liveProfit': liveProfit,
      'distributeCopies': distributeCopies,
      'audioStreams': audioStreams,
      'radioBroadcasting': radioBroadcasting,
      'musicVideos': musicVideos,
      'availableFilesId': availableFilesId,
      'userId': userId,
    };
  }

  LicenseTemplate copyWith({
    int? id,
    String? name,
    dynamic mp3,
    dynamic wav,
    dynamic zip,
    String? description,
    dynamic musicRecording,
    dynamic liveProfit,
    dynamic distributeCopies,
    dynamic audioStreams,
    dynamic radioBroadcasting,
    dynamic musicVideos,
    int? availableFilesId,
    String? userId,
  }) {
    return LicenseTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      mp3: mp3 ?? this.mp3,
      wav: wav ?? this.wav,
      zip: zip ?? this.zip,
      description: description ?? this.description,
      musicRecording: musicRecording ?? this.musicRecording,
      liveProfit: liveProfit ?? this.liveProfit,
      distributeCopies: distributeCopies ?? this.distributeCopies,
      audioStreams: audioStreams ?? this.audioStreams,
      radioBroadcasting: radioBroadcasting ?? this.radioBroadcasting,
      musicVideos: musicVideos ?? this.musicVideos,
      availableFilesId: availableFilesId ?? this.availableFilesId,
      userId: userId ?? this.userId,
    );
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class BeatLicense {
  final int id;
  final String beatId;
  final int licenseTemplateId;
  final LicenseTemplate licenseTemplate;
  final String beatmakerId;
  final int price;

  BeatLicense({
    required this.id,
    required this.beatId,
    required this.licenseTemplateId,
    required this.licenseTemplate,
    required this.beatmakerId,
    required this.price,
  });

  factory BeatLicense.fromJson(Map<String, dynamic> json) {
    return BeatLicense(
      id: json['id'] ?? 0,
      beatId: json['beatId'] ?? '',
      licenseTemplateId: json['licenseTemplateId'] ?? 0,
      licenseTemplate: LicenseTemplate.fromJson(json['licenseTemplate'] ?? {}),
      beatmakerId: json['beatmakerId'] ?? '',
      price: json['price'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'beatId': beatId,
      'licenseTemplateId': licenseTemplateId,
      'licenseTemplate': licenseTemplate.toJson(),
      'beatmakerId': beatmakerId,
      'price': price,
    };
  }

  BeatLicense copyWith({
    int? id,
    String? beatId,
    int? licenseTemplateId,
    LicenseTemplate? licenseTemplate,
    String? beatmakerId,
    int? price,
  }) {
    return BeatLicense(
      id: id ?? this.id,
      beatId: beatId ?? this.beatId,
      licenseTemplateId: licenseTemplateId ?? this.licenseTemplateId,
      licenseTemplate: licenseTemplate ?? this.licenseTemplate,
      beatmakerId: beatmakerId ?? this.beatmakerId,
      price: price ?? this.price,
    );
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}