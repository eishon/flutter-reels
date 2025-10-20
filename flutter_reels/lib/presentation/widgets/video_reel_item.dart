import 'package:flutter/material.dart';
import 'package:flutter_reels/domain/entities/video_entity.dart';
import 'package:flutter_reels/presentation/widgets/engagement_buttons.dart';
import 'package:flutter_reels/presentation/widgets/video_description.dart';
import 'package:flutter_reels/presentation/widgets/video_player_widget.dart';

/// Full-screen video reel item with overlay controls
///
/// Features:
/// - Full-screen auto-playing video
/// - User avatar and username
/// - Engagement buttons (like, comment, share)
/// - Video description with hashtags
/// - Product tags
class VideoReelItem extends StatefulWidget {
  final VideoEntity video;
  final VoidCallback onLike;
  final VoidCallback onShare;
  final bool isActive;

  const VideoReelItem({
    super.key,
    required this.video,
    required this.onLike,
    required this.onShare,
    this.isActive = false,
  });

  @override
  State<VideoReelItem> createState() => _VideoReelItemState();
}

class _VideoReelItemState extends State<VideoReelItem> {
  bool _isBottomSheetOpen = false;

  @override
  Widget build(BuildContext context) {
    final isVideoActive = widget.isActive && !_isBottomSheetOpen;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Video player
        VideoPlayerWidget(
          videoUrl: widget.video.url,
          isActive: isVideoActive,
        ),

        // Top gradient overlay for better text visibility
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 120,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black54,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Bottom gradient overlay for better text visibility
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 300,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black87,
                  Colors.black54,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Main content overlay
        SafeArea(
          child: Column(
            children: [
              const Spacer(),

              // Bottom content
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 16.0,
                  bottom: 8.0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Video description and user info
                    Expanded(
                      child: VideoDescription(video: widget.video),
                    ),
                    const SizedBox(width: 12),
                    // Engagement buttons
                    EngagementButtons(
                      video: widget.video,
                      onLike: widget.onLike,
                      onShare: widget.onShare,
                    ),
                  ],
                ),
              ),

              // Products button at bottom (if products available)
              if (widget.video.hasProducts)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    bottom: 16.0,
                  ),
                  child: _buildProductsButton(context),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductsButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showProductsSheet(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag,
              color: Colors.grey.shade900,
              size: 22,
            ),
            const SizedBox(width: 10),
            Text(
              'View ${widget.video.productCount} ${widget.video.productCount == 1 ? "Product" : "Products"}',
              style: TextStyle(
                color: Colors.grey.shade900,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProductsSheet(BuildContext context) {
    // Pause video when bottom sheet opens
    setState(() {
      _isBottomSheetOpen = true;
    });

    final productCount = widget.video.products.length;
    final isSingleProduct = productCount == 1;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Header
                  Text(
                    'Products in this video',
                    style: TextStyle(
                      color: Colors.grey.shade900,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Products Grid/List
                  Expanded(
                    child: GridView.builder(
                      controller: scrollController,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isSingleProduct ? 1 : 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        mainAxisExtent: isSingleProduct ? 400 : 350,
                      ),
                      itemCount: widget.video.products.length,
                      itemBuilder: (context, index) {
                        final product = widget.video.products[index];
                        return _buildProductCard(context, product);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      // Resume video when bottom sheet closes
      if (mounted) {
        setState(() {
          _isBottomSheetOpen = false;
        });
      }
    });
  }

  Widget _buildProductCard(BuildContext context, product) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image (Square)
                AspectRatio(
                  aspectRatio: 1.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      image: product.imageUrl.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(product.imageUrl),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: product.imageUrl.isEmpty
                        ? Icon(
                            Icons.image_outlined,
                            size: 48,
                            color: Colors.grey.shade400,
                          )
                        : null,
                  ),
                ),

                // Product Details
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Name (Marquee)
                        SizedBox(
                          height: 18,
                          child: _MarqueeText(
                            text: product.name,
                            style: TextStyle(
                              color: Colors.grey.shade900,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Product Description (3 lines max)
                        Text(
                          product.description,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),

                        // Price
                        Row(
                          children: [
                            Text(
                              '${product.currency}${product.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.grey.shade900,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (product.discountPrice != null) ...[
                              const SizedBox(width: 3),
                              Text(
                                '${product.currency}${product.discountPrice}',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 10,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 5),

                        // Availability
                        Row(
                          children: [
                            Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                color: product.isAvailable
                                    ? Colors.green
                                    : Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              product.isAvailable ? 'In Stock' : 'Out of Stock',
                              style: TextStyle(
                                color: product.isAvailable
                                    ? Colors.green.shade700
                                    : Colors.red.shade700,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),

                        // Go to Product Button (Red Capsule)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle go to product
                              Navigator.pop(context);
                              // TODO: Navigate to product details or open product URL
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Go to Product',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ], // children of outer Column
            ); // Column closing
          }, // builder closing
        ), // LayoutBuilder closing
      ), // Container closing
    ); // ClipRRect closing
  } // method closing
}

/// Marquee text widget for scrolling long text
class _MarqueeText extends StatefulWidget {
  final String text;
  final TextStyle? style;

  const _MarqueeText({
    required this.text,
    this.style,
  });

  @override
  State<_MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<_MarqueeText>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients &&
          _scrollController.position.maxScrollExtent > 0) {
        _startMarquee();
      }
    });
  }

  void _startMarquee() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    while (mounted) {
      if (_scrollController.hasClients) {
        await _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(
            seconds: (widget.text.length * 0.1).clamp(5, 15).toInt(),
          ),
          curve: Curves.linear,
        );
        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return;
        await _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
        await Future.delayed(const Duration(seconds: 1));
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: Text(
        widget.text,
        style: widget.style,
        maxLines: 1,
      ),
    );
  }
}
