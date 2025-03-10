import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/song.dart';
import 'package:flutter_application_1/config/constants.dart';

class ApiService {
  final String baseUrl;
  final http.Client _client = http.Client();
  
  ApiService({required this.baseUrl});
  
  // Get all songs
  Future<List<Song>> getAllSongs() async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/songs'));
      
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        List<dynamic> jsonResponse = responseBody['data']; // Extract the data array
        return jsonResponse.map((song) => Song.fromJson(song)).toList();
      } else {
        throw Exception('Failed to load songs: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load songs: $e');
    }
  }
  
  // Get song details
  Future<Song> getSongDetails(int id) async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/songs/$id'));
      
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        // Check if the song is nested inside a data property
        var songData = responseBody.containsKey('data') ? responseBody['data'] : responseBody;
        return Song.fromJson(songData);
      } else {
        throw Exception('Failed to load song details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load song details: $e');
    }
  }
  
  // Get song stream URL
  String getSongStreamUrl(int id) {
    return '$baseUrl/songs/$id/stream';
  }
  
  // Search songs
  Future<List<Song>> searchSongs(String query) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/search').replace(
          queryParameters: {'q': query},
        ),
      );
      
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        List<dynamic> jsonResponse = responseBody['data']; // Extract the data array
        return jsonResponse.map((song) => Song.fromJson(song)).toList();
      } else {
        throw Exception('Failed to search songs: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to search songs: $e');
    }
  }
  
  // Get songs by genre
  Future<List<Song>> getSongsByGenre(int genreId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/songs').replace(
          queryParameters: {'genre_id': genreId.toString()},
        ),
      );
      
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        List<dynamic> jsonResponse = responseBody['data']; // Extract the data array
        return jsonResponse.map((song) => Song.fromJson(song)).toList();
      } else {
        throw Exception('Failed to load songs by genre: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load songs by genre: $e');
    }
  }
  
  // Get songs by artist
  Future<List<Song>> getSongsBySinger(int singerId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/songs').replace(
          queryParameters: {'singer_id': singerId.toString()},
        ),
      );
      
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        List<dynamic> jsonResponse = responseBody['data']; // Extract the data array
        return jsonResponse.map((song) => Song.fromJson(song)).toList();
      } else {
        throw Exception('Failed to load songs by singer: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load songs by singer: $e');
    }
  }
}