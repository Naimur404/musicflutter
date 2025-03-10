import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_application_1/controllers/player_controller.dart';
import 'package:flutter_application_1/models/song.dart';
import 'package:flutter_application_1/widgets/player/player_controls.dart';
import 'package:flutter_application_1/widgets/player/progress_bar.dart';
import 'package:flutter_application_1/widgets/player/playlist_view.dart';
import 'package:flutter_application_1/config/constants.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({Key? key}) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showPlaylist = false;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final PlayerController playerController = Provider.of<PlayerController>(context);
    final Song? currentSong = playerController.currentSong;
    
    if (currentSong == null) {
      return const Scaffold(
        body: Center(
          child: Text('No song is currently playing'),
        ),
      );
    }
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              playerController.primaryColor.withOpacity(0.8),
              playerController.primaryColor.withOpacity(0.5),
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: _showPlaylist 
                  ? PlaylistView(
                      playlist: playerController.playlist,
                      currentSongId: currentSong.id,
                      onTap: (Song song) {
                        playerController.playSong(song);
                      },
                    )
                  : _buildNowPlayingContent(context, currentSong, playerController),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DEFAULT_PADDING,
        vertical: DEFAULT_PADDING / 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 28,
            ),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Text(
            _showPlaylist ? 'Playlist' : 'Now Playing',
            style: const TextStyle(
              fontSize: FONT_SIZE_LARGE,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          IconButton(
            icon: Icon(
              _showPlaylist ? Icons.music_note_rounded : Icons.queue_music_rounded,
              size: 24,
            ),
            color: Colors.white,
            onPressed: () {
              setState(() {
                _showPlaylist = !_showPlaylist;
              });
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildNowPlayingContent(
    BuildContext context, 
    Song song, 
    PlayerController playerController
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: DEFAULT_PADDING),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          
          // Album Art with reflection effect
          _buildAlbumArt(song),
          
          const SizedBox(height: 40),
          
          // Song Information
          Text(
            song.title,
            style: const TextStyle(
              fontSize: FONT_SIZE_XXLARGE,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            song.singer?.name ?? 'Unknown Artist',
            style: const TextStyle(
              fontSize: FONT_SIZE_LARGE,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 40),
          
          // Progress Bar
          AudioProgressBar(
            position: playerController.position,
            duration: playerController.duration,
            onSeek: playerController.seek,
          ),
          
          const SizedBox(height: 30),
          
          // Player Controls
          PlayerControls(
            isPlaying: playerController.isPlaying,
            isLooping: playerController.isLooping,
            isShuffling: playerController.isShuffling,
            onPlayPause: playerController.playOrPause,
            onSkipNext: playerController.next,
            onSkipPrevious: playerController.previous,
            onToggleLoopMode: playerController.toggleLoopMode,
            onToggleShuffle: playerController.toggleShuffle,
          ),
          
          const SizedBox(height: 30),
          
          // Lyrics/Details tabs
          _buildTabs(),
          
          const SizedBox(height: 20),
          
          // Tab content
          SizedBox(
            height: 200,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLyricsTab(),
                _buildDetailsTab(song),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAlbumArt(Song song) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 30,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main album art
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: song.coverImage != null
                ? CachedNetworkImage(
                    imageUrl: song.coverImage!,
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.width * 0.7,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[900],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[900],
                      child: const Icon(
                        Icons.music_note_rounded,
                        size: 50,
                        color: Colors.white54,
                      ),
                    ),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.width * 0.7,
                    color: Colors.grey[900],
                    child: const Icon(
                      Icons.music_note_rounded,
                      size: 50,
                      color: Colors.white54,
                    ),
                  ),
          ),
          
          // Reflection effect (blurred and faded version of album art)
          if (song.coverImage != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
              child: Opacity(
                opacity: 0.3,
                child: Transform.scale(
                  scaleY: -0.2, // Flip and scale down
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 30,
                    width: MediaQuery.of(context).size.width * 0.7,
                    foregroundDecoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                      ),
                    ),
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                        child: CachedNetworkImage(
                          imageUrl: song.coverImage!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildTabs() {
    return TabBar(
      controller: _tabController,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white60,
      indicatorColor: Colors.white,
      indicatorSize: TabBarIndicatorSize.label,
      tabs: const [
        Tab(text: 'Lyrics'),
        Tab(text: 'Details'),
      ],
    );
  }
  
  Widget _buildLyricsTab() {
    // In a real app, you'd fetch lyrics from an API or database
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: const Text(
          'Lyrics not available for this song.\n\n'
          'In a real app, you would display the actual lyrics here, '
          'possibly with time synchronization to highlight the current line.',
          style: TextStyle(
            color: Colors.white70,
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
  
  Widget _buildDetailsTab(Song song) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailItem('Song', song.title),
          _buildDetailItem('Artist', song.singer?.name ?? 'Unknown Artist'),
          _buildDetailItem('Genre', song.genre?.name ?? 'Unknown Genre'),
          _buildDetailItem('Duration', song.durationFormatted ?? 'Unknown'),
        ],
      ),
    );
  }
  
  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              color: Colors.white60,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}