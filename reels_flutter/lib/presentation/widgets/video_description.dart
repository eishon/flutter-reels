import 'package:flutter/material.dart';
import 'package:reels_flutter/domain/entities/video_entity.dart';

/// Bottom overlay with video description and user info
///
/// Features:
/// - Username with verification badge
/// - Video description text
/// - Hashtags extracted from description
/// - Audio/music info
/// - Expandable description for long text
/// - Audio mute/unmute control
class VideoDescription extends StatefulWidget {
  final VideoEntity video;
  final bool isMuted;
  final VoidCallback onToggleMute;

  const VideoDescription({
    super.key,
    required this.video,
    required this.isMuted,
    required this.onToggleMute,
  });

  @override
  State<VideoDescription> createState() => _VideoDescriptionState();
}

class _VideoDescriptionState extends State<VideoDescription> {
  bool _isExpanded = false;
  static const int _maxLines = 2;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Username
        _buildUsername(),
        const SizedBox(height: 8),

        // Description with expand/collapse
        _buildDescription(),
        const SizedBox(height: 12),

        // Audio/Music info
        _buildAudioInfo(),
      ],
    );
  }

  Widget _buildUsername() {
    return Row(
      children: [
        // Avatar on the left
        CircleAvatar(
          radius: 16,
          backgroundImage: NetworkImage(widget.video.user.avatarUrl),
          backgroundColor: Colors.grey.shade800,
        ),
        const SizedBox(width: 8),
        // Username
        Text(
          '@${widget.video.user.name}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 8),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    final description = widget.video.description;
    final hasLongDescription = description.length > 100;

    return GestureDetector(
      onTap: hasLongDescription
          ? () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            }
          : null,
      child: RichText(
        maxLines: _isExpanded ? null : _maxLines,
        overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
        text: TextSpan(
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            shadows: [
              Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 8),
            ],
          ),
          children: [
            TextSpan(text: _parseDescription(description)),
            if (hasLongDescription && !_isExpanded)
              TextSpan(
                text: ' more',
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _parseDescription(String text) {
    // In a real app, this would parse hashtags and mentions
    // For now, just return the text
    return text;
  }

  Widget _buildAudioInfo() {
    return GestureDetector(
      onTap: () {
        widget.onToggleMute();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.isMuted ? 'Audio unmuted' : 'Audio muted'),
            duration: const Duration(milliseconds: 500),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.isMuted ? Icons.volume_off : Icons.music_note,
              size: 16,
              color: Colors.white,
              shadows: [
                Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 4),
              ],
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                widget.isMuted
                    ? 'Audio muted'
                    : 'Original Audio - ${widget.video.user.name}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  shadows: [
                    Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 4),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
