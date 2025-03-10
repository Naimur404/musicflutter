import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color? backgroundColor;
  final double height;
  final Widget? leading;
  final VoidCallback? onBackPressed;
  
  const CustomAppBar({
    Key? key,
    required this.title,
    this.showBackButton = true,
    this.actions,
    this.centerTitle = false,
    this.backgroundColor,
    this.height = kToolbarHeight + 16,
    this.leading,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(
        horizontal: DEFAULT_PADDING / 2,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? backgroundColor,
        boxShadow: [
          if (backgroundColor != null)
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
        ],
      ),
      child: Row(
        mainAxisAlignment: centerTitle 
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.start,
        children: [
          // Back button or custom leading widget
          if (showBackButton)
            leading ?? IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: onBackPressed ?? () {
                Navigator.pop(context);
              },
            ),
          
          // Title
          if (centerTitle) const Spacer(),
          
          Text(
            title,
            style: const TextStyle(
              fontSize: FONT_SIZE_XLARGE,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          if (centerTitle) 
            Spacer()
          else 
            const Spacer(),
          
          // Actions
          if (actions != null)
            ...actions!,
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class GradientAppBar extends CustomAppBar {
  final List<Color> gradientColors;
  final AlignmentGeometry gradientBegin;
  final AlignmentGeometry gradientEnd;
  
  const GradientAppBar({
    Key? key,
    required String title,
    bool showBackButton = true,
    List<Widget>? actions,
    bool centerTitle = false,
    double height = kToolbarHeight + 16,
    Widget? leading,
    VoidCallback? onBackPressed,
    this.gradientColors = const [primaryColor, secondaryColor],
    this.gradientBegin = Alignment.centerLeft,
    this.gradientEnd = Alignment.centerRight,
  }) : super(
          key: key,
          title: title,
          showBackButton: showBackButton,
          actions: actions,
          centerTitle: centerTitle,
          height: height,
          leading: leading,
          onBackPressed: onBackPressed,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(
        horizontal: DEFAULT_PADDING / 2,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: gradientBegin,
          end: gradientEnd,
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: centerTitle 
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.start,
        children: [
          // Back button or custom leading widget
          if (showBackButton)
            leading ?? IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
              ),
              onPressed: onBackPressed ?? () {
                Navigator.pop(context);
              },
            ),
          
          // Title
          if (centerTitle) const Spacer(),
          
          Text(
            title,
            style: const TextStyle(
              fontSize: FONT_SIZE_XLARGE,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          
          if (centerTitle) 
            const Spacer()
          else 
            const Spacer(),
          
          // Actions
          if (actions != null)
            ...actions!,
        ],
      ),
    );
  }
}