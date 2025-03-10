import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_application_1/models/song.dart';
import 'package:flutter_application_1/controllers/player_controller.dart';
import 'package:flutter_application_1/config/constants.dart';

class SearchResults extends StatelessWidget {
  final List<Song> results;
  final String query;
  
  const SearchResults({
    Key? key,
    required this.results,
    required this.query,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return _buildEmptyResults();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(DEFAULT_PADDING),
          child: Text(
            'Results for "$query"',
            style: const TextStyle(
              fontSize: FONT_SIZE_LARGE,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        // Filter tabs
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: DEFAULT_PADDING),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All', true),
                _buildFilterChip('Songs', false),
                _buildFilterChip('Artists', false),
                _buildFilterChip('Albums', false),
                _buildFilterChip('Playlists', false),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Best match section
        if (results.isNotEmpty)
          _buildBestMatch(context, results.first),
        
        const SizedBox(height: 24),
        
        // All results section
        Expanded(
          child: _buildAllResults(context),
        ),
      ],
    );
  }
  
  Widget _buildEmptyResults() {
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
            'No results found for "$query"',
            style: TextStyle(
              fontSize: FONT_SIZE_LARGE,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try different keywords or check spelling',
            style: TextStyle(
              fontSize: FONT_SIZE_MEDIUM,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          // Filter functionality would be implemented here
        },
        backgroundColor: surfaceColor,
        selectedColor: primaryColor,
        checkmarkColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.grey,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
  
  Widget _buildBestMatch(BuildContext context, Song song) {
    return Container(
      padding: const EdgeInsets.all(DEFAULT_PADDING),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Best Match',
            style: TextStyle(
              fontSize: FONT_SIZE_MEDIUM,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {
              final playerController = Provider.of<PlayerController>(context, listen: false);
              playerController.playSong(song);
              Navigator.pushNamed(context, '/player');
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  // Song cover image
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                    child: song.coverImage != null
                        ? CachedNetworkImage(
                            imageUrl: song.coverImage!,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[900],
                              width: 120,
                              height: 120,
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[900],
                              width: 120,
                              height: 120,
                              child: const Icon(
                                Icons.music_note_rounded,
                                size: 40,
                                color: Colors.white54,
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.grey[900],
                            width: 120,
                            height: 120,
                            child: const Icon(
                              Icons.music_note_rounded,
                              size: 40,
                              color: Colors.white54,
                            ),
                          ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Song details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song.title,
                          style: const TextStyle(
                            fontSize: FONT_SIZE_LARGE,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          song.singer?.name ?? 'Unknown Artist',
                          style: const TextStyle(
                            fontSize: FONT_SIZE_MEDIUM,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            if (song.genre != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: surfaceColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  song.genre!.name,
                                  style: const TextStyle(
                                    fontSize: FONT_SIZE_SMALL,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            const SizedBox(width: 8),
                            if (song.durationFormatted != null)
                              Text(
                                song.durationFormatted!,
                                style: const TextStyle(
                                  fontSize: FONT_SIZE_SMALL,
                                  color: Colors.grey,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Play button
                  IconButton(
                    icon: const Icon(
                      Icons.play_circle_fill_rounded,
                      size: 48,
                      color: primaryColor,
                    ),
                    onPressed: () {
                      final playerController = Provider.of<PlayerController>(context, listen: false);
                      playerController.playSong(song);
                      Navigator.pushNamed(context, '/player');
                    },
                  ),
                  
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAllResults(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(DEFAULT_PADDING),
      itemCount: results.length,
      itemBuilder: (context, index) {
        // Skip the first item as it's already shown as best match
        if (index == 0) return const SizedBox.shrink();
        
        final song = results[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: song.coverImage != null
                ? CachedNetworkImage(
                    imageUrl: song.coverImage!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[900],
                      width: 50,
                      height: 50,
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[900],
                      width: 50,
                      height: 50,
                      child: const Icon(
                        Icons.music_note_rounded,
                        size: 24,
                        color: Colors.white54,
                      ),
                    ),
                  )
                : Container(
                    color: Colors.grey[900],
                    width: 50,
                    height: 50,
                    child: const Icon(
                      Icons.music_note_rounded,
                      size: 24,
                      color: Colors.white54,
                    ),
                  ),
          ),
          title: Text(
            song.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            song.singer?.name ?? 'Unknown Artist',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: FONT_SIZE_SMALL,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.more_vert_rounded,
              color: Colors.grey,
            ),
            onPressed: () {
              // Show options menu
            },
          ),
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