import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_application_1/models/song.dart';
import 'package:flutter_application_1/config/constants.dart';

class PlaylistView extends StatelessWidget {
  final List<Song> playlist;
  final int currentSongId;
  final Function(Song) onTap;

  const PlaylistView({
    Key? key,
    required this.playlist,
    required this.currentSongId,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(DEFAULT_PADDING),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Now Playing',
                    style: TextStyle(
                      fontSize: FONT_SIZE_LARGE,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${playlist.length} songs',
                    style: const TextStyle(
                      fontSize: FONT_SIZE_MEDIUM,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.shuffle_rounded,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      // Shuffle playlist
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.repeat_rounded,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      // Toggle repeat mode
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ReorderableListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: DEFAULT_PADDING),
            itemCount: playlist.length,
            onReorder: (oldIndex, newIndex) {
              // Handle playlist reordering
            },
            itemBuilder: (context, index) {
              final song = playlist[index];
              final isCurrentSong = song.id == currentSongId;
              
              return _buildPlaylistItem(
                key: Key('playlist_item_${song.id}'),
                song: song,
                index: index,
                isCurrentSong: isCurrentSong,
              );
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildPlaylistItem({
    required Key key,
    required Song song,
    required int index,
    required bool isCurrentSong,
  }) {
    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isCurrentSong ? primaryColor.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              alignment: Alignment.center,
              child: isCurrentSong
                  ? const Icon(
                      Icons.play_arrow_rounded,
                      color: primaryColor,
                      size: 20,
                    )
                  : Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: FONT_SIZE_MEDIUM,
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
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
          ],
        ),
        title: Text(
          song.title,
          style: TextStyle(
            color: isCurrentSong ? primaryColor : Colors.white,
            fontWeight: isCurrentSong ? FontWeight.bold : FontWeight.normal,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          song.singer?.name ?? 'Unknown Artist',
          style: TextStyle(
            color: isCurrentSong ? primaryColor.withOpacity(0.7) : Colors.white60,
            fontSize: FONT_SIZE_SMALL,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (song.durationFormatted != null)
              Text(
                song.durationFormatted!,
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: FONT_SIZE_SMALL,
                ),
              ),
            const SizedBox(width: 8),
            ReorderableDragStartListener(
              index: index,
              child: const Icon(
                Icons.drag_handle_rounded,
                color: Colors.white60,
                size: 20,
              ),
            ),
          ],
        ),
        onTap: () => onTap(song),
      ),
    );
  }
}