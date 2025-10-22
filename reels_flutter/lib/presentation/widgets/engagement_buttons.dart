import 'package:flutter/material.dart';
import 'package:reels_flutter/domain/entities/video_entity.dart';

/// Vertical engagement buttons column (right side of screen)
///
/// Features:
/// - User profile avatar (with gradient border when viewing)
/// - Like button with animated heart and count
/// - Comment button with count
/// - Share button with count
/// - Product tag button (if products available)
class EngagementButtons extends StatefulWidget {
  final VideoEntity video;
  final VoidCallback onLike;
  final VoidCallback onShare;

  const EngagementButtons({
    super.key,
    required this.video,
    required this.onLike,
    required this.onShare,
  });

  @override
  State<EngagementButtons> createState() => _EngagementButtonsState();
}

class _EngagementButtonsState extends State<EngagementButtons>
    with SingleTickerProviderStateMixin {
  late AnimationController _likeAnimationController;
  late Animation<double> _likeAnimation;

  @override
  void initState() {
    super.initState();
    _likeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _likeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 1.4,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.4,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_likeAnimationController);
  }

  @override
  void dispose() {
    _likeAnimationController.dispose();
    super.dispose();
  }

  void _handleLike() {
    widget.onLike();
    _likeAnimationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Like button
        _buildLikeButton(),
        const SizedBox(height: 24),

        // Share button
        _buildShareButton(),
        const SizedBox(height: 24),

        // More options button
        _buildMoreButton(),
      ],
    );
  }

  Widget _buildLikeButton() {
    return _buildEngagementButton(
      child: AnimatedBuilder(
        animation: _likeAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _likeAnimation.value,
            child: Icon(
              widget.video.isLiked ? Icons.favorite : Icons.favorite_border,
              size: 32,
              color: widget.video.isLiked ? Colors.red : Colors.white,
            ),
          );
        },
      ),
      label: _formatCount(widget.video.likes),
      onTap: _handleLike,
    );
  }

  Widget _buildShareButton() {
    return _buildEngagementButton(
      child: const Icon(Icons.share_outlined, size: 28, color: Colors.white),
      label: _formatCount(widget.video.shares),
      onTap: widget.onShare,
    );
  }

  Widget _buildMoreButton() {
    return _buildEngagementButton(
      child: const Icon(Icons.more_horiz, size: 28, color: Colors.white),
      label: '',
      onTap: () {
        // Show more options
        _showMoreOptionsSheet(context);
      },
    );
  }

  Widget _buildEngagementButton({
    required Widget child,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          child,
          if (label.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                shadows: [
                  Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 4),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  void _showCommentsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade900,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${widget.video.comments} Comments',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Comments section coming soon',
                        style: TextStyle(color: Colors.grey.shade400),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showMoreOptionsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade900,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade700,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              // Comments option
              ListTile(
                leading: const Icon(
                  Icons.comment_outlined,
                  color: Colors.white,
                ),
                title: Text(
                  'Comments (${widget.video.comments})',
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showCommentsSheet(context);
                },
              ),

              // Report option
              ListTile(
                leading: const Icon(Icons.flag_outlined, color: Colors.white),
                title: const Text(
                  'Report',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Handle report
                },
              ),

              // Not Interested option
              ListTile(
                leading: const Icon(Icons.not_interested, color: Colors.white),
                title: const Text(
                  'Not Interested',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Handle not interested
                },
              ),

              // Save option
              ListTile(
                leading: const Icon(
                  Icons.bookmark_outline,
                  color: Colors.white,
                ),
                title: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Handle save
                },
              ),

              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
