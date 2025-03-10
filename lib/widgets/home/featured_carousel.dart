import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/models/song.dart';
import 'package:flutter_application_1/controllers/player_controller.dart';
import 'package:flutter_application_1/config/constants.dart';

class FeaturedCarousel extends StatefulWidget {
  final List<Song> songs;
  
  const FeaturedCarousel({
    Key? key,
    required this.songs,
  }) : super(key: key);

  @override
  State<FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<FeaturedCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  
  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.8,
    );
    
    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: DEFAULT_PADDING),
          child: Text(
            'Featured',
            style: TextStyle(
              fontSize: FONT_SIZE_XLARGE,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 260,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.songs.length,
            itemBuilder: (context, index) {
              final isActive = index == _currentPage;
              return _buildCarouselItem(widget.songs[index], isActive);
            },
          ),
        ),
        const SizedBox(height: 16),
        _buildIndicators(),
      ],
    );
  }
  
  Widget _buildCarouselItem(Song song, bool isActive) {
    final double margin = isActive ? 10 : 20;
    
    return AnimatedContainer(
      duration: ANIMATION_DURATION_SHORT,
      curve: Curves.easeOutQuint,
      margin: EdgeInsets.symmetric(
        vertical: margin,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isActive ? 0.3 : 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background image
            Positioned.fill(
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
                          size: 50,
                          color: Colors.white54,
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.grey[900],
                      child: const Icon(
                        Icons.music_note_rounded,
                        size: 50,
                        color: Colors.white54,
                      ),
                    ),
            ),
            
            // Gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                    stops: const [0.5, 1.0],
                  ),
                ),
              ),
            ),
            
            // Content
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: FONT_SIZE_XLARGE,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    song.singer?.name ?? 'Unknown Artist',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: FONT_SIZE_MEDIUM,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Play button
                      ElevatedButton(
                        onPressed: () {
                          final PlayerController playerController = 
                              Provider.of<PlayerController>(context, listen: false);
                          playerController.playSong(song);
                          Navigator.pushNamed(context, '/player');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.play_arrow_rounded, size: 20),
                            SizedBox(width: 4),
                            Text('Play'),
                          ],
                        ),
                      ),
                      
                      // Duration
                      if (song.durationFormatted != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 16,
                                color: Colors.white70,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                song.durationFormatted!,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: FONT_SIZE_SMALL,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.songs.length,
        (index) => AnimatedContainer(
          duration: ANIMATION_DURATION_SHORT,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: index == _currentPage ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: index == _currentPage 
                ? primaryColor 
                : Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}