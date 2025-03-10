import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_application_1/controllers/player_controller.dart';
import 'package:flutter_application_1/models/song.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PlayerController playerController = Provider.of<PlayerController>(context);
    final Song? currentSong = playerController.currentSong;
    
    if (currentSong == null) {
      return const SizedBox.shrink();
    }
    
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/player');
      },
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: playerController.primaryColor.withOpacity(0.9),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Album art
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: currentSong.coverImage != null
                  ? CachedNetworkImage(
                      imageUrl: currentSong.coverImage!,
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
                          color: Colors.white54,
                        ),
                      ),
                    )
                  : Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey[900],
                      child: const Icon(
                        Icons.music_note_rounded,
                        color: Colors.white54,
                      ),
                    ),
            ),
            
            const SizedBox(width: 12),
            
            // Song info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    currentSong.title,
                    style: TextStyle(
                      color: playerController.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentSong.singer?.name ?? 'Unknown Artist',
                    style: TextStyle(
                      color: playerController.textColor.withOpacity(0.7),
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            // Play/Pause button
            IconButton(
              icon: Icon(
                playerController.isPlaying 
                    ? Icons.pause_rounded 
                    : Icons.play_arrow_rounded,
                color: playerController.textColor,
                size: 30,
              ),
              onPressed: playerController.playOrPause,
            ),
            
            // Next button
            IconButton(
              icon: Icon(
                Icons.skip_next_rounded,
                color: playerController.textColor,
                size: 30,
              ),
              onPressed: playerController.next,
            ),
          ],
        ),
      ),
    );
  }
}