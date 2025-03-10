import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_application_1/controllers/player_controller.dart';
import 'package:flutter_application_1/models/song.dart';
import 'package:flutter_application_1/services/api_service.dart';
import 'package:flutter_application_1/widgets/common/mini_player.dart';
import 'package:flutter_application_1/widgets/home/featured_carousel.dart';
import 'package:flutter_application_1/widgets/home/genre_list.dart';
import 'package:flutter_application_1/widgets/common/song_tile.dart';
import 'package:flutter_application_1/config/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  List<Song> _recentSongs = [];
  List<Song> _popularSongs = [];
  List<Song> _newReleases = [];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadSongs();
  }
  
  Future<void> _loadSongs() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final ApiService apiService = Provider.of<ApiService>(context, listen: false);
      final songs = await apiService.getAllSongs();
      
      // Just for demo, in real app you would have specific endpoints for these categories
      setState(() {
        _recentSongs = songs.take(10).toList();
        _popularSongs = songs.skip(5).take(10).toList();
        _newReleases = songs.skip(10).take(10).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading songs: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PlayerController playerController = Provider.of<PlayerController>(context);
    final bool hasCurrentSong = playerController.currentSong != null;
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildCustomAppBar(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadSongs,
                child: _isLoading 
                  ? const Center(child: CircularProgressIndicator())
                  : _buildHomeContent(),
              ),
            ),
            // Mini player at bottom if a song is playing
            if (hasCurrentSong) const MiniPlayer(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music_rounded),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
        onTap: (index) {
          // Handle navigation
          if (index == 1) {
            Navigator.pushNamed(context, '/search');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/library');
          } else if (index == 3) {
            Navigator.pushNamed(context, '/settings');
          }
        },
      ),
    );
  }
  
  Widget _buildCustomAppBar() {
    return Container(
      padding: const EdgeInsets.all(DEFAULT_PADDING),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [primaryColor, secondaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.music_note_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Harmonia',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded),
                onPressed: () {
                  // Handle notifications
                },
              ),
              IconButton(
                icon: const Icon(Icons.person_rounded),
                onPressed: () {
                  // Handle profile
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildHomeContent() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 100), // Extra padding for mini player
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Featured songs carousel
          if (_recentSongs.isNotEmpty)
            FeaturedCarousel(songs: _recentSongs),
            
          const SizedBox(height: 24),
          
          // Genres horizontal list
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: DEFAULT_PADDING),
            child: Text(
              'Browse Genres',
              style: TextStyle(
                fontSize: FONT_SIZE_XLARGE,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const GenreList(),
          
          const SizedBox(height: 24),
          
          // Tab bar for different song categories
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: DEFAULT_PADDING),
            child: TabBar(
              controller: _tabController,
              labelColor: primaryColor,
              unselectedLabelColor: secondaryTextColor,
              indicatorColor: primaryColor,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: const [
                Tab(text: 'For You'),
                Tab(text: 'Popular'),
                Tab(text: 'New Releases'),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Tab content
          SizedBox(
            height: 400, // Fixed height for tab content
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSongList(_recentSongs),
                _buildSongList(_popularSongs),
                _buildSongList(_newReleases),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSongList(List<Song> songs) {
    if (songs.isEmpty) {
      return const Center(
        child: Text('No songs available'),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: DEFAULT_PADDING),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        return SongTile(
          song: song,
          onTap: () {
            final PlayerController playerController = 
                Provider.of<PlayerController>(context, listen: false);
            playerController.playSong(song);
            Navigator.pushNamed(context, '/player');
          },
        );
      },
    );
  }
}