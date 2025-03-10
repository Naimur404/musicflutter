import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/constants.dart';

class GenreList extends StatelessWidget {
  const GenreList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // List of genres with their respective colors and icons
    final genres = [
      {
        'name': 'Pop',
        'color': const Color(0xFF5D3FD3),
        'icon': Icons.music_note_rounded,
      },
      {
        'name': 'Rock',
        'color': const Color(0xFFE4572E),
        'icon': Icons.electric_bolt,
      },
      {
        'name': 'Hip Hop',
        'color': const Color(0xFF29335C),
        'icon': Icons.headphones_rounded,
      },
      {
        'name': 'Electronic',
        'color': const Color(0xFF00A6ED),
        'icon': Icons.electric_bolt_rounded,
      },
      {
        'name': 'Jazz',
        'color': const Color(0xFFFFAA33),
        'icon': Icons.piano_rounded,
      },
      {
        'name': 'Classical',
        'color': const Color(0xFF9E643C),
        'icon': Icons.music_note_rounded,
      },
      {
        'name': 'R&B',
        'color': const Color(0xFFE84855),
        'icon': Icons.album_rounded,
      },
      {
        'name': 'Country',
        'color': const Color(0xFF61A0AF),
        'icon': Icons.music_note_rounded,
      },
    ];

    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: DEFAULT_PADDING),
        itemCount: genres.length,
        itemBuilder: (context, index) {
          final genre = genres[index];
          return _buildGenreItem(
            context,
            genre['name'] as String,
            genre['color'] as Color,
            genre['icon'] as IconData,
          );
        },
      ),
    );
  }

  Widget _buildGenreItem(
    BuildContext context,
    String name,
    Color color,
    IconData icon,
  ) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          // Genre icon with background
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: color.withOpacity(0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Navigate to genre songs
                  // Navigator.pushNamed(context, '/genre', arguments: name);
                },
                borderRadius: BorderRadius.circular(20),
                child: Icon(
                  icon,
                  size: 40,
                  color: color,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Genre name
          Text(
            name,
            style: const TextStyle(
              fontSize: FONT_SIZE_MEDIUM,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}