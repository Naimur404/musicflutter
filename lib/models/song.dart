import 'package:flutter_application_1/models/singer.dart';
import 'package:flutter_application_1/models/genre.dart';

class Song {
  final int id;
  final String title;
  final Singer? singer;
  final Genre? genre;
  final String? coverImage;
  final int? duration;
  final String? durationFormatted;
  final String fileUrl;
  
  Song({
    required this.id,
    required this.title,
    this.singer,
    this.genre,
    this.coverImage,
    this.duration,
    this.durationFormatted,
    required this.fileUrl,
  });
  
  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      title: json['title'],
      singer: json['singer'] != null ? Singer.fromJson(json['singer']) : null,
      genre: json['genre'] != null ? Genre.fromJson(json['genre']) : null,
      coverImage: json['cover_image'],
      duration: json['duration'],
      durationFormatted: json['duration_formatted'],
      fileUrl: json['file_url'],
    );
  }
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['title'] = title;
    if (singer != null) {
      data['singer'] = singer!.toJson();
    }
    if (genre != null) {
      data['genre'] = genre!.toJson();
    }
    data['cover_image'] = coverImage;
    data['duration'] = duration;
    data['duration_formatted'] = durationFormatted;
    data['file_url'] = fileUrl;
    return data;
  }
  
  // Create MediaItem for audio_service
  Map<String, dynamic> toMediaItem() {
    return {
      'id': id.toString(),
      'title': title,
      'artist': singer?.name ?? 'Unknown Artist',
      'album': genre?.name ?? 'Unknown Album',
      'artUri': coverImage,
      'duration': duration != null ? Duration(seconds: duration!) : null,
      'extras': {
        'url': fileUrl,
        'songId': id,
      }
    };
  }
}