import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter_application_1/models/song.dart';

class AudioPlayerService {
  static final AudioPlayerService _instance = AudioPlayerService._internal();
  
  factory AudioPlayerService() {
    return _instance;
  }
  
  AudioPlayerService._internal();
  
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  AudioPlayer get audioPlayer => _audioPlayer;
  
  // Initialize the audio service
    Future<void> init() async {
    // Don't initialize JustAudioBackground here as it's already done in main.dart
    
    // Setup audio player
    _audioPlayer.playbackEventStream.listen(
      (event) {},
      onError: (Object e, StackTrace stackTrace) {
        print('A stream error occurred: $e');
      },
    );
  }
  
  // Play a single song
  Future<void> playSong(Song song) async {
    try {
      // Create a MediaItem for the song
      final mediaItem = MediaItem(
        id: song.id.toString(),
        album: song.genre?.name ?? 'Unknown',
        title: song.title,
        artist: song.singer?.name ?? 'Unknown Artist',
        duration: song.duration != null ? Duration(seconds: song.duration!) : null,
        artUri: song.coverImage != null ? Uri.parse(song.coverImage!) : null,
        extras: {'url': song.fileUrl},
      );
      
      // Set the audio source with the media item
      await _audioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.parse(song.fileUrl),
          tag: mediaItem,
        ),
      );
      
      await _audioPlayer.play();
    } catch (e) {
      print('Error loading audio source: $e');
    }
  }
  
  // Play a playlist
  Future<void> playPlaylist(List<Song> songs, int initialIndex) async {
    try {
      // Create a ConcatenatingAudioSource with all songs
      final playlist = ConcatenatingAudioSource(
        children: songs.map((song) {
          return AudioSource.uri(
            Uri.parse(song.fileUrl),
            tag: MediaItem(
              id: song.id.toString(),
              album: song.genre?.name ?? 'Unknown',
              title: song.title,
              artist: song.singer?.name ?? 'Unknown Artist',
              duration: song.duration != null ? Duration(seconds: song.duration!) : null,
              artUri: song.coverImage != null ? Uri.parse(song.coverImage!) : null,
              extras: {'url': song.fileUrl},
            ),
          );
        }).toList(),
      );
      
      // Set the audio source with the playlist
      await _audioPlayer.setAudioSource(playlist, initialIndex: initialIndex);
      
      await _audioPlayer.play();
    } catch (e) {
      print('Error loading playlist: $e');
    }
  }
  
  // Play/Pause toggle
  Future<void> playOrPause() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }
  
  // Skip to next track
  Future<void> next() async {
    await _audioPlayer.seekToNext();
  }
  
  // Skip to previous track
  Future<void> previous() async {
    await _audioPlayer.seekToPrevious();
  }
  
  // Seek to a specific position
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }
  
  // Set looping mode
  Future<void> setLoopMode(LoopMode mode) async {
    await _audioPlayer.setLoopMode(mode);
  }
  
  // Set shuffle mode
  Future<void> setShuffleModeEnabled(bool enabled) async {
    await _audioPlayer.setShuffleModeEnabled(enabled);
  }
  
  // Set playback speed
  Future<void> setSpeed(double speed) async {
    await _audioPlayer.setSpeed(speed);
  }
  
  // Dispose the player
  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}