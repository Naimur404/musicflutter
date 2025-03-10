import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/controllers/search_controller.dart' as custom;
import 'package:flutter_application_1/controllers/player_controller.dart';
import 'package:flutter_application_1/services/api_service.dart';
import 'package:flutter_application_1/widgets/common/song_tile.dart';
import 'package:flutter_application_1/widgets/common/mini_player.dart';
import 'package:flutter_application_1/widgets/search/search_bar.dart';
import 'package:flutter_application_1/config/constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
    // Set the API service for the search controller
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final searchController = Provider.of<custom.SearchController>(context, listen: false);
      final apiService = Provider.of<ApiService>(context, listen: false);
      searchController.setApiService(apiService);
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchController = Provider.of<custom.SearchController>(context);
    final playerController = Provider.of<PlayerController>(context);
    final bool hasCurrentSong = playerController.currentSong != null;
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
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
                    'Search',
                    style: TextStyle(
                      fontSize: FONT_SIZE_XLARGE,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            // Custom search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: DEFAULT_PADDING),
              child: CustomSearchBar(
                controller: searchController.textController,
                onChanged: searchController.updateSearchQuery,
                onClear: searchController.clearSearch,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Search results
            Expanded(
              child: searchController.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : searchController.isSearching && searchController.searchResults.isEmpty
                      ? _buildNoResults()
                      : !searchController.isSearching
                          ? _buildSearchSuggestions()
                          : _buildSearchResults(searchController),
            ),
            
            // Mini player at bottom if a song is playing
            if (hasCurrentSong) const MiniPlayer(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: TextStyle(
              fontSize: FONT_SIZE_LARGE,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search term',
            style: TextStyle(
              fontSize: FONT_SIZE_MEDIUM,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSearchSuggestions() {
    // In a real app, these could be trending searches, genres, etc.
    return Padding(
      padding: const EdgeInsets.all(DEFAULT_PADDING),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trending Searches',
            style: TextStyle(
              fontSize: FONT_SIZE_LARGE,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSearchChip('Pop'),
              _buildSearchChip('Rock'),
              _buildSearchChip('Jazz'),
              _buildSearchChip('Classical'),
              _buildSearchChip('Hip Hop'),
              _buildSearchChip('Electronic'),
              _buildSearchChip('Dance'),
              _buildSearchChip('R&B'),
            ],
          ),
          
          const SizedBox(height: 32),
          
          const Text(
            'Recommended Artists',
            style: TextStyle(
              fontSize: FONT_SIZE_LARGE,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSearchChip('Ed Sheeran'),
              _buildSearchChip('Taylor Swift'),
              _buildSearchChip('Drake'),
              _buildSearchChip('Billie Eilish'),
              _buildSearchChip('The Weeknd'),
              _buildSearchChip('Ariana Grande'),
              _buildSearchChip('Post Malone'),
              _buildSearchChip('Dua Lipa'),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildSearchChip(String label) {
    return GestureDetector(
      onTap: () {
        final searchController = Provider.of<SearchController>(context, listen: false);
        searchController.textController.text = label;
        searchController.updateSearchQuery(label);
      },
      child: Chip(
        label: Text(label),
        backgroundColor: surfaceColor,
        labelStyle: const TextStyle(color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      ),
    );
  }
  
  Widget _buildSearchResults(custom.SearchController searchController) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: DEFAULT_PADDING),
      itemCount: searchController.searchResults.length,
      itemBuilder: (context, index) {
        final song = searchController.searchResults[index];
        return SongTile(
          song: song,
          onTap: () {
            final playerController = Provider.of<PlayerController>(context, listen: false);
            playerController.playSong(song);
            Navigator.pushNamed(context, '/player');
          },
        );
      },
    );
  }
}

extension on SearchController {
  get textController => null;

  void updateSearchQuery(String label) {}
}