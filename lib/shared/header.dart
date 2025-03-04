import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool hideBackButton;
  final Color backgroundColor;
  final List<Widget>? actions;

  const Header({
    super.key,
    required this.title,
    this.onPressed,
    this.hideBackButton = false,
    this.backgroundColor = Colors.white,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: backgroundColor,
      toolbarHeight: 80,
      scrolledUnderElevation: 0,
      leading:
          hideBackButton
              ? null
              : IconButton(
                onPressed: () {
                  if (onPressed != null) {
                    onPressed!();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.grey[800],
                  size: 18,
                ),
              ),
      title: Text(
        title,
        style: GoogleFonts.sora(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.grey[800],
        ),
        overflow: TextOverflow.ellipsis,
      ),
      centerTitle: true,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
