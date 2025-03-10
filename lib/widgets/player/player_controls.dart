import 'package:flutter/material.dart';

class PlayerControls extends StatelessWidget {
  final bool isPlaying;
  final bool isLooping;
  final bool isShuffling;
  final VoidCallback onPlayPause;
  final VoidCallback onSkipNext;
  final VoidCallback onSkipPrevious;
  final VoidCallback onToggleLoopMode;
  final VoidCallback onToggleShuffle;

  const PlayerControls({
    Key? key,
    required this.isPlaying,
    required this.isLooping,
    required this.isShuffling,
    required this.onPlayPause,
    required this.onSkipNext,
    required this.onSkipPrevious,
    required this.onToggleLoopMode,
    required this.onToggleShuffle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Shuffle button
        IconButton(
          icon: Icon(
            Icons.shuffle_rounded,
            color: isShuffling ? Colors.teal : Colors.white70,
            size: 24,
          ),
          onPressed: onToggleShuffle,
        ),
        
        // Previous button
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white24,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.skip_previous_rounded,
              color: Colors.white,
              size: 32,
            ),
            onPressed: onSkipPrevious,
          ),
        ),
        
        // Play/Pause button
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 5,
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(
              isPlaying 
                ? Icons.pause_rounded 
                : Icons.play_arrow_rounded,
              color: Colors.black,
              size: 40,
            ),
            onPressed: onPlayPause,
          ),
        ),
        
        // Next button
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white24,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.skip_next_rounded,
              color: Colors.white,
              size: 32,
            ),
            onPressed: onSkipNext,
          ),
        ),
        
        // Loop button
        IconButton(
          icon: Icon(
            isLooping 
              ? Icons.repeat_one_rounded 
              : Icons.repeat_rounded,
            color: isLooping ? Colors.teal : Colors.white70,
            size: 24,
          ),
          onPressed: onToggleLoopMode,
        ),
      ],
    );
  }
}