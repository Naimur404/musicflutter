import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_application_1/models/song.dart';
import 'package:flutter_application_1/config/constants.dart';

class SongTile extends StatelessWidget {
  final Song song;
  final VoidCallback onTap;
  final bool isActive;
  final bool showTrailingMenu;

  const SongTile({
    Key? key,
    required this.song,
    required this.onTap,
    this.isActive = false,
    this.showTrailingMenu = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isActive ? primaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Song cover image
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: song.coverImage != null
                    ? CachedNetworkImage(
                        imageUrl: song.coverImage!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[900],
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[900],
                          child: const Icon(
                            Icons.music_note_rounded,
                            color: Colors.white54,
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.grey[900],
                        child: const Icon(
                          Icons.music_note_rounded,
                          color: Colors.white54,
                        ),
                      ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Song info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: TextStyle(
                      fontSize: FONT_SIZE_MEDIUM,
                      fontWeight: FontWeight.w600,
                      color: isActive ? primaryColor : primaryTextColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (song.singer != null) ...[
                        Expanded(
                          child: Text(
                            song.singer!.name,
                            style: TextStyle(
                              fontSize: FONT_SIZE_SMALL,
                              color: isActive ? primaryColor.withOpacity(0.8) : secondaryTextColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                      if (song.durationFormatted != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          song.durationFormatted!,
                          style: TextStyle(
                            fontSize: FONT_SIZE_SMALL,
                            color: secondaryTextColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            
            // Actions
            if (isActive)
              const Icon(
                Icons.equalizer_rounded,
                color: primaryColor,
                size: 24,
              )
            else if (showTrailingMenu)
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: secondaryTextColor,
                  size: 24,
                ),
                onSelected: (value) {
                  // Handle menu selections
                  switch (value) {
                    case 'play':
                      onTap();
                      break;
                    case 'add_to_playlist':
                      // Add to playlist logic
                      break;
                    case 'download':
                      // Download logic
                      break;
                    case 'share':
                      // Share logic
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem<String>(
                    value: 'play',
                    child: Row(
                      children: [
                        Icon(Icons.play_arrow_rounded, size: 20),
                        SizedBox(width: 8),
                        Text('Play'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'add_to_playlist',
                    child: Row(
                      children: [
                        Icon(Icons.playlist_add_rounded, size: 20),
                        SizedBox(width: 8),
                        Text('Add to playlist'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'download',
                    child: Row(
                      children: [
                        Icon(Icons.download_rounded, size: 20),
                        SizedBox(width: 8),
                        Text('Download'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'share',
                    child: Row(
                      children: [
                        Icon(Icons.share_rounded, size: 20),
                        SizedBox(width: 8),
                        Text('Share'),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}