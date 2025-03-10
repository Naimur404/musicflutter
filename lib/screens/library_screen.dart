import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/controllers/player_controller.dart';
import 'package:flutter_application_1/widgets/common/mini_player.dart';
import 'package:flutter_application_1/config/constants.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
            // App bar with title
            Padding(
              padding: const EdgeInsets.all(DEFAULT_PADDING),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Your Library',
                    style: TextStyle(
                      fontSize: FONT_SIZE_XLARGE,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.search_rounded),
                    onPressed: () {
                      Navigator.pushNamed(context, '/search');
                    },
                  ),
                ],
              ),
            ),

            // Tab bar
            TabBar(
              controller: _tabController,
              indicatorColor: primaryColor,
              labelColor: primaryColor,
              unselectedLabelColor: secondaryTextColor,
              tabs: const [
                Tab(text: 'Playlists'),
                Tab(text: 'Artists'),
                Tab(text: 'Albums'),
                Tab(text: 'Downloads'),
              ],
            ),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPlaylistsTab(),
                  _buildArtistsTab(),
                  _buildAlbumsTab(),
                  _buildDownloadsTab(),
                ],
              ),
            ),

            // Mini player at bottom if a song is playing
            if (hasCurrentSong) const MiniPlayer(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaylistsTab() {
    return ListView(
      padding: const EdgeInsets.all(DEFAULT_PADDING),
      children: [
        // Create playlist button
        _buildCreatePlaylistButton(),
        
        const SizedBox(height: 24),
        
        // Default playlists
        _buildDefaultPlaylist(
          'Favorites',
          Icons.favorite_rounded,
          'Songs you\'ve liked',
          42,
          const Color(0xFFE91E63),
        ),
        _buildDefaultPlaylist(
          'Recently Played',
          Icons.history_rounded,
          'Songs you\'ve recently played',
          18,
          const Color(0xFF9C27B0),
        ),
        _buildDefaultPlaylist(
          'Most Played',
          Icons.repeat_rounded,
          'Your most played songs',
          35,
          const Color(0xFF2196F3),
        ),
        
        const SizedBox(height: 24),
        
        // User playlists heading
        const Text(
          'Your Playlists',
          style: TextStyle(
            fontSize: FONT_SIZE_LARGE,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // User created playlists (empty state for now)
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 40),
              Icon(
                Icons.playlist_add_rounded,
                size: 80,
                color: Colors.grey[700],
              ),
              const SizedBox(height: 16),
              Text(
                'No playlists yet',
                style: TextStyle(
                  fontSize: FONT_SIZE_LARGE,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Create your first playlist',
                style: TextStyle(
                  fontSize: FONT_SIZE_MEDIUM,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCreatePlaylistButton() {
    return GestureDetector(
      onTap: () {
        // Show create playlist dialog
      },
      child: Container(
        padding: const EdgeInsets.all(DEFAULT_PADDING),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              primaryColor.withOpacity(0.7),
              primaryDarkColor.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create New Playlist',
                  style: TextStyle(
                    fontSize: FONT_SIZE_LARGE,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Add your favorite songs',
                  style: TextStyle(
                    fontSize: FONT_SIZE_MEDIUM,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultPlaylist(
    String name,
    IconData icon,
    String description,
    int songCount,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: cardColor,
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 30,
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(
                fontSize: FONT_SIZE_SMALL,
                color: secondaryTextColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$songCount songs',
              style: const TextStyle(
                fontSize: FONT_SIZE_SMALL,
                color: secondaryTextColor,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () {
          // Navigate to playlist
        },
      ),
    );
  }

  Widget _buildArtistsTab() {
    // Placeholder for artists tab
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.people_rounded,
            size: 80,
            color: Colors.grey[700],
          ),
          const SizedBox(height: 16),
          Text(
            'No followed artists',
            style: TextStyle(
              fontSize: FONT_SIZE_LARGE,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Artists you follow will appear here',
            style: TextStyle(
              fontSize: FONT_SIZE_MEDIUM,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlbumsTab() {
    // Placeholder for albums tab
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.album_rounded,
            size: 80,
            color: Colors.grey[700],
          ),
          const SizedBox(height: 16),
          Text(
            'No saved albums',
            style: TextStyle(
              fontSize: FONT_SIZE_LARGE,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Albums you save will appear here',
            style: TextStyle(
              fontSize: FONT_SIZE_MEDIUM,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadsTab() {
    // Placeholder for downloads tab
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.download_rounded,
            size: 80,
            color: Colors.grey[700],
          ),
          const SizedBox(height: 16),
          Text(
            'No downloaded songs',
            style: TextStyle(
              fontSize: FONT_SIZE_LARGE,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Downloaded songs will appear here',
            style: TextStyle(
              fontSize: FONT_SIZE_MEDIUM,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to songs to download
              Navigator.pushNamed(context, '/home');
            },
            icon: const Icon(Icons.download_rounded),
            label: const Text('Download Songs'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}