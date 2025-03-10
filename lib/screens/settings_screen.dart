import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/controllers/player_controller.dart';
import 'package:flutter_application_1/widgets/common/mini_player.dart';
import 'package:flutter_application_1/config/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Settings state
  bool _showLyrics = DEFAULT_SHOW_LYRICS;
  bool _downloadOnWifiOnly = DEFAULT_DOWNLOAD_ON_WIFI_ONLY;
  int _audioQuality = DEFAULT_AUDIO_QUALITY;
  final List<String> _audioQualityOptions = ['Low', 'Medium', 'High'];
  bool _darkMode = true;
  double _playbackSpeed = 1.0;
  
  // Loading state
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      setState(() {
        _showLyrics = prefs.getBool('show_lyrics') ?? DEFAULT_SHOW_LYRICS;
        _downloadOnWifiOnly = prefs.getBool('download_on_wifi_only') ?? DEFAULT_DOWNLOAD_ON_WIFI_ONLY;
        _audioQuality = prefs.getInt('audio_quality') ?? DEFAULT_AUDIO_QUALITY;
        _darkMode = prefs.getBool('dark_mode') ?? true;
        _playbackSpeed = prefs.getDouble('playback_speed') ?? 1.0;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading settings: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _saveSettings() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setBool('show_lyrics', _showLyrics);
      await prefs.setBool('download_on_wifi_only', _downloadOnWifiOnly);
      await prefs.setInt('audio_quality', _audioQuality);
      await prefs.setBool('dark_mode', _darkMode);
      await prefs.setDouble('playback_speed', _playbackSpeed);
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings saved successfully'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      print('Error saving settings: $e');
      
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save settings'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
                    'Settings',
                    style: TextStyle(
                      fontSize: FONT_SIZE_XLARGE,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Settings content
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildSettingsContent(),
            ),

            // Mini player at bottom if a song is playing
            if (hasCurrentSong) const MiniPlayer(),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsContent() {
    return ListView(
      padding: const EdgeInsets.all(DEFAULT_PADDING),
      children: [
        // Account section
        _buildSectionHeader('Account'),
        _buildAccountCard(),
        
        const SizedBox(height: 24),
        
        // Playback section
        _buildSectionHeader('Playback'),
        _buildSettingTile(
          title: 'Show Lyrics',
          subtitle: 'Display lyrics while playing songs',
          trailing: Switch(
            value: _showLyrics,
            onChanged: (value) {
              setState(() {
                _showLyrics = value;
              });
              _saveSettings();
            },
          ),
        ),
        _buildSettingTile(
          title: 'Playback Speed',
          subtitle: '${_playbackSpeed.toStringAsFixed(1)}x',
          trailing: DropdownButton<double>(
            value: _playbackSpeed,
            items: [0.5, 0.75, 1.0, 1.25, 1.5, 2.0].map((speed) {
              return DropdownMenuItem<double>(
                value: speed,
                child: Text('${speed.toStringAsFixed(1)}x'),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _playbackSpeed = value;
                });
                _saveSettings();
                
                // Update playback speed if playing
                final playerController = Provider.of<PlayerController>(context, listen: false);
                playerController.setSpeed(value);
              }
            },
            underline: Container(),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Downloads section
        _buildSectionHeader('Downloads'),
        _buildSettingTile(
          title: 'Download on Wi-Fi Only',
          subtitle: 'Only download songs when connected to Wi-Fi',
          trailing: Switch(
            value: _downloadOnWifiOnly,
            onChanged: (value) {
              setState(() {
                _downloadOnWifiOnly = value;
              });
              _saveSettings();
            },
          ),
        ),
        _buildSettingTile(
          title: 'Audio Quality',
          subtitle: _audioQualityOptions[_audioQuality],
          trailing: DropdownButton<int>(
            value: _audioQuality,
            items: [0, 1, 2].map((index) {
              return DropdownMenuItem<int>(
                value: index,
                child: Text(_audioQualityOptions[index]),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _audioQuality = value;
                });
                _saveSettings();
              }
            },
            underline: Container(),
          ),
        ),
        _buildActionTile(
          icon: Icons.delete_outline_rounded,
          title: 'Clear Download Cache',
          subtitle: 'Free up space by clearing downloaded songs',
          onTap: () {
            // Show confirmation dialog
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Clear Download Cache'),
                content: const Text(
                  'Are you sure you want to clear all downloaded songs? '
                  'This action cannot be undone.',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Clear download cache logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Download cache cleared'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Clear'),
                  ),
                ],
              ),
            );
          },
        ),
        
        const SizedBox(height: 24),
        
        // Appearance section
        _buildSectionHeader('Appearance'),
        _buildSettingTile(
          title: 'Dark Mode',
          subtitle: 'Use dark theme throughout the app',
          trailing: Switch(
            value: _darkMode,
            onChanged: (value) {
              setState(() {
                _darkMode = value;
              });
              _saveSettings();
              
              // In a real app, would update theme
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Theme changes will apply after restart'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ),
        
        const SizedBox(height: 24),
        
        // About section
        _buildSectionHeader('About'),
        _buildActionTile(
          icon: Icons.info_outline_rounded,
          title: 'About Harmonia',
          subtitle: 'Version 1.0.0',
          onTap: () {
            // Show about dialog
            showAboutDialog(
              context: context,
              applicationName: 'Harmonia Music',
              applicationVersion: '1.0.0',
              applicationIcon: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [primaryColor, secondaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.music_note_rounded,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(
                    'Harmonia is a music streaming app that lets you enjoy your '
                    'favorite music anywhere, anytime. Even when the app is minimized '
                    'or your screen is locked.',
                  ),
                ),
              ],
            );
          },
        ),
        _buildActionTile(
          icon: Icons.privacy_tip_outlined,
          title: 'Privacy Policy',
          subtitle: 'Read our privacy policy',
          onTap: () {
            // Open privacy policy
          },
        ),
        _buildActionTile(
          icon: Icons.description_outlined,
          title: 'Terms of Service',
          subtitle: 'Read our terms of service',
          onTap: () {
            // Open terms of service
          },
        ),
        
        const SizedBox(height: 32),
        
        // Sign out button
        ElevatedButton(
          onPressed: () {
            // Sign out logic
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text(
            'Sign Out',
            style: TextStyle(
              fontSize: FONT_SIZE_MEDIUM,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        // Extra space at bottom for mini player
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: FONT_SIZE_LARGE,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      ),
    );
  }

  Widget _buildAccountCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile picture
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [primaryColor, secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'A',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Account info
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alex Johnson',
                  style: TextStyle(
                    fontSize: FONT_SIZE_LARGE,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'alex.johnson@example.com',
                  style: TextStyle(
                    fontSize: FONT_SIZE_MEDIUM,
                    color: secondaryTextColor,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Premium Subscription',
                  style: TextStyle(
                    fontSize: FONT_SIZE_SMALL,
                    color: primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          // Edit button
          IconButton(
            icon: const Icon(
              Icons.edit_outlined,
              color: secondaryTextColor,
            ),
            onPressed: () {
              // Edit profile logic
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: FONT_SIZE_SMALL,
            color: secondaryTextColor,
          ),
        ),
        trailing: trailing,
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: Icon(
          icon,
          color: primaryColor,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: FONT_SIZE_SMALL,
            color: secondaryTextColor,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: secondaryTextColor,
        ),
        onTap: onTap,
      ),
    );
  }
}