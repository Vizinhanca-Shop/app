import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool hideBackButton;
  final Color backgroundColor;

  const Header({
    super.key,
    required this.title,
    this.onPressed,
    this.hideBackButton = false,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: backgroundColor,
      leadingWidth: MediaQuery.of(context).size.width,
      toolbarHeight: 80,
      scrolledUnderElevation: 0,
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            hideBackButton
                ? const SizedBox(width: 40)
                : SizedBox(
                  width: 40,
                  child: IconButton(
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
                ),
            Flexible(
              child: Text(
                title,
                style: GoogleFonts.sora(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 40),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
