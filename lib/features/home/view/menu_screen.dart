//ToDo ::Mostafa:: Still have to clean code and make it reusable

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class MenuDrawer extends StatelessWidget {
  final VoidCallback? onProfile;
  final VoidCallback? onMessages;
  final VoidCallback? onCalendar;
  final VoidCallback? onBookmark;
  final VoidCallback? onContact;
  final VoidCallback? onSettings;
  final VoidCallback? onHelp;
  final VoidCallback? onSignOut;

  const MenuDrawer({
    super.key,
    this.onProfile,
    this.onMessages,
    this.onCalendar,
    this.onBookmark,
    this.onContact,
    this.onSettings,
    this.onHelp,
    this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final h = mq.size.height;
    final padH = w * 0.06;
    final gap = h * 0.018;

    return Drawer(
      width: w * 0.78,
      backgroundColor: const Color(0xFFF0F0F0), // رمادي فاتح شبه
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padH * 0.6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: gap),
              // Header: avatar + name
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: const AssetImage(
                      'assets/1.png',
                    ),
                    onBackgroundImageError: (_, __) {},
                  ),
                  SizedBox(width: padH * 0.6),
                  Expanded(
                    child: Text(
                      'Hadeer Mohamed',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              SizedBox(height: gap * 1.6),

              // Menu items
              _MenuItem(
                icon: Icons.person_outline,
                text: 'My Profile',
                onTap: onProfile,
              ),
              _MenuItem(
                icon: Icons.chat_bubble_outline,
                text: 'Massage',
                onTap: onMessages,
                trailing: _Badge(count: 3),
              ),
              _MenuItem(
                icon: Icons.calendar_today_outlined,
                text: 'Calender',
                onTap: onCalendar,
              ),
              _MenuItem(
                icon: Icons.bookmark_border,
                text: 'Bookmark',
                onTap: onBookmark,
              ),
              _MenuItem(
                icon: Icons.mail_outline,
                text: 'Contact Us',
                onTap: onContact,
              ),
              _MenuItem(
                icon: Icons.settings_outlined,
                text: 'Settings',
                onTap: onSettings,
              ),
              _MenuItem(
                icon: Icons.help_outline,
                text: 'Helps & FAQs',
                onTap: onHelp,
              ),

              const Spacer(),

              // Sign Out
              _MenuItem(icon: Icons.logout, text: 'Sign Out', onTap: onSignOut),

              SizedBox(height: gap * 1.2),

              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: w * 0.35,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: gap),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.icon,
    required this.text,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.of(context).maybePop();
        onTap?.call();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: w * 0.02),
        child: Row(
          children: [
            Icon(icon, size: 22, color: Colors.black87),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final int count;
  const _Badge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF2A365),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '$count',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
