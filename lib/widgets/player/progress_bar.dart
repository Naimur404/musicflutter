import 'package:flutter/material.dart';

class AudioProgressBar extends StatelessWidget {
  final Duration position;
  final Duration duration;
  final Function(Duration) onSeek;

  const AudioProgressBar({
    Key? key,
    required this.position,
    required this.duration,
    required this.onSeek,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final positionText = _formatDuration(position);
    final durationText = _formatDuration(duration);
    
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4.0,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 8.0,
              disabledThumbRadius: 8.0,
            ),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.white.withOpacity(0.3),
            thumbColor: Colors.white,
            overlayColor: Colors.white.withOpacity(0.2),
          ),
          child: Slider(
            min: 0.0,
            max: duration.inMilliseconds.toDouble() == 0.0 
                ? 1.0 
                : duration.inMilliseconds.toDouble(),
            value: position.inMilliseconds.toDouble().clamp(
              0, 
              duration.inMilliseconds.toDouble() == 0.0 
                  ? 1.0 
                  : duration.inMilliseconds.toDouble(),
            ),
            onChanged: (value) {
              onSeek(Duration(milliseconds: value.toInt()));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                positionText,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              Text(
                durationText,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}