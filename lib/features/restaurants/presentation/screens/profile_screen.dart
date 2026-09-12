// lib/features/profile/presentation/screens/profile_screen.dart
import 'package:flutter/material.dart';

import '../../../../core/widgets/coming_soon_view.dart';

/// TODO: implement per PDF §4.5 — show email, change password
/// (PUT /api/User/{usercode}), logout (clear session), delete account
/// (DELETE /api/User/{usercode}).
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoonView(title: 'Profile', icon: Icons.person_rounded);
  }
}