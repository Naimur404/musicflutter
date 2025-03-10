import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_application_1/models/song.dart';
import 'package:flutter_application_1/services/audio_service.dart';
import 'package:palette_generator/palette_generator.dart';

class PlayerController extends ChangeNotifier {
  final AudioPlayerService _audioService = AudioPlayerService();
  
  // Current song being played
  Song? _currentSong;
  Song? get currentSong => _currentSong;
  
  // Current playlist
  List<Song> _playlist = [];
  List<Song> get playlist => _playlist;
  
  // Playback states
  bool get isPlaying => _audioService.audioPlayer.playing;
  bool get isLooping => _audioService.audioPlayer.loopMode != LoopMode.off;
  bool get isShuffling => _audioService.audioPlayer.shuffleModeEnabled;
  
  // Current position and duration
  Duration get position => _audioService.audioPlayer.position;
  Duration get duration => _audioService.audioPlayer.duration ?? Duration.zero;
  
  // Dynamic colors for UI based on album art
  Color _primaryColor = Colors.indigo;
  Color _secondaryColor = Colors.indigoAccent;
  Color _textColor = Colors.white;
  
  Color get primaryColor => _primaryColor;
  Color get secondaryColor => _secondaryColor;
  Color get textColor => _textColor;
  
  // Constructor
  PlayerController() {
    _initStreams();
  }
  
  // Initialize event streams
  void _initStreams() {
    // Listen for position changes
    _audioService.audioPlayer.positionStream.listen((position) {
      notifyListeners();
    });
    
    // Listen for playback state changes
    _audioService.audioPlayer.playerStateStream.listen((state) {
      notifyListeners();
    });
    
    // Listen for current media item changes
    _audioService.audioPlayer.currentIndexStream.listen((index) {
      if (index != null && _playlist.isNotEmpty && index < _playlist.length) {
        _currentSong = _playlist[index];
        _updateColorsFromArtwork();
        notifyListeners();
      }
    });
  }
  
  // Play a single song
  Future<void> playSong(Song song) async {
    _currentSong = song;
    _playlist = [song];
    await _audioService.playSong(song);
    _updateColorsFromArtwork();
    notifyListeners();
  }
  
  // Play a playlist
  Future<void> playPlaylist(List<Song> songs, int initialIndex) async {
    _playlist = songs;
    _currentSong = songs[initialIndex];
    await _audioService.playPlaylist(songs, initialIndex);
    _updateColorsFromArtwork();
    notifyListeners();
  }
  
  // Toggle play/pause
  Future<void> playOrPause() async {
    await _audioService.playOrPause();
    notifyListeners();
  }
  
  // Skip to next track
  Future<void> next() async {
    await _audioService.next();
    notifyListeners();
  }
  
  // Skip to previous track
  Future<void> previous() async {
    await _audioService.previous();
    notifyListeners();
  }
  
  // Seek to a specific position
  Future<void> seek(Duration position) async {
    await _audioService.seek(position);
    notifyListeners();
  }
  
  // Toggle loop mode
  Future<void> toggleLoopMode() async {
    if (_audioService.audioPlayer.loopMode == LoopMode.off) {
      await _audioService.setLoopMode(LoopMode.all);
    } else if (_audioService.audioPlayer.loopMode == LoopMode.all) {
      await _audioService.setLoopMode(LoopMode.one);
    } else {
      await _audioService.setLoopMode(LoopMode.off);
    }
    notifyListeners();
  }
  
  // Toggle shuffle mode
  Future<void> toggleShuffle() async {
    await _audioService.setShuffleModeEnabled(!isShuffling);
    notifyListeners();
  }
  
  // Set playback speed
  Future<void> setSpeed(double speed) async {
    await _audioService.setSpeed(speed);
    notifyListeners();
  }
  
  // Extract colors from artwork for dynamic UI
  Future<void> _updateColorsFromArtwork() async {
    if (_currentSong?.coverImage == null) {
      // Default colors if no artwork
      _primaryColor = Colors.indigo;
      _secondaryColor = Colors.indigoAccent;
      _textColor = Colors.white;
      notifyListeners();
      return;
    }
    
    try {
      final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(
        NetworkImage(_currentSong!.coverImage!),
        maximumColorCount: 20,
      );
      
      // Set primary color
      _primaryColor = paletteGenerator.dominantColor?.color ?? Colors.indigo;
      
      // Set secondary color
      _secondaryColor = paletteGenerator.vibrantColor?.color ?? 
                        paletteGenerator.lightVibrantColor?.color ??
                        _primaryColor.withOpacity(0.7);
      
      // Choose text color based on primary color brightness
      _textColor = _primaryColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
      
      notifyListeners();
    } catch (e) {
      print('Error generating colors from artwork: $e');
    }
  }
  
  // Dispose
  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}