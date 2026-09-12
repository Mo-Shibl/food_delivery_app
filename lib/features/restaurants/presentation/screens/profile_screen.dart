import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';
import '../../../profile/presentation/cubit/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _showTopNotification(BuildContext context, String message, {bool isError = true}) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 20,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 300),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, (1 - value) * -20),
                  child: child,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isError ? AppColors.orangeBase : Colors.green,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyles.paragraph.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileCubit>()..loadProfile(),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoggedOut || state is DeleteAccountSuccess) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.login,
              (route) => false,
            );
          }
          if (state is ChangePasswordSuccess) {
            _showTopNotification(context, 'Password changed successfully', isError: false);
          }
          if (state is ProfileError) {
            _showTopNotification(context, state.message, isError: true);
          }
        },
        builder: (context, state) {
          String email = '';
          String name = '';

          if (state is ProfileLoaded) {
            email = state.email;
            name = email.contains('@') ? email.split('@')[0] : email;
          }

          return Drawer(
            width: 280,
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              height: 852,
              decoration: const BoxDecoration(
                color: AppColors.orangeBase,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(85),
                  bottomLeft: Radius.circular(85),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x40000000),
                    offset: Offset(0, 4),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: state is ProfileLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.white))
                  : Stack(
                      children: [
                        Positioned(
                          left: 33,
                          top: 71,
                          right: 10,
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: AssetImage('assets/icons/pfp.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Text(
                                  name,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: 'League Spartan',
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.font2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 150,
                          bottom: 120,
                          child: ListView(
                            padding: const EdgeInsets.symmetric(horizontal: 35),
                            children: [
                              _buildMenuItem(
                                iconPath: 'assets/icons/Email.svg',
                                label: 'Show Email',
                                onTap: () {
                                  _showEmailDialog(context, email);
                                },
                              ),
                              _buildMenuItem(
                                iconPath: 'assets/icons/Password.svg',
                                label: 'Change Password',
                                onTap: () {
                                  _showChangePasswordDialog(context);
                                },
                              ),
                              _buildMenuItem(
                                iconPath: 'assets/icons/Delete.svg',
                                label: 'Delete Account',
                                onTap: () {
                                  _showDeleteAccountDialog(context);
                                },
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 60,
                          bottom: 50,
                          child: GestureDetector(
                            onTap: () => _showLogoutConfirmation(context),
                            child: Row(
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: AppColors.font2,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'assets/icons/Log Out icon.svg',
                                      width: 14,
                                      height: 14,
                                      colorFilter: const ColorFilter.mode(
                                        AppColors.orangeBase,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                const Text(
                                  'Log Out',
                                  style: TextStyle(
                                    fontFamily: 'League Spartan',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.yellow2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    final profileCubit = context.read<ProfileCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x4FFE4A0C), // rgba(254, 74, 12, 0.31)
      builder: (context) {
        return Container(
          height: 199,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.font2, // background: #F8F8F8
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Stack(
            children: [
              // Are you sure you want to log out?
              Positioned(
                top: 48, // 701 - 653 = 48
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'Are you sure you want to log out?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'League Spartan',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      height: 18 / 20,
                    ),
                  ),
                ),
              ),
              // Cancel Button
              Positioned(
                left: 25,
                top: 120,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 153.29,
                    height: 37,
                    decoration: BoxDecoration(
                      color: AppColors.orange2, // background: #FFDECF
                      borderRadius: BorderRadius.circular(50.2143),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontFamily: 'League Spartan',
                        fontSize: 22.4643,
                        fontWeight: FontWeight.w400,
                        color: AppColors.orangeBase, // color: #E95322
                      ),
                    ),
                  ),
                ),
              ),
              // Yes Button
              Positioned(
                left: 190,
                top: 120,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    profileCubit.logout();
                  },
                  child: Container(
                    width: 153.29,
                    height: 37,
                    decoration: BoxDecoration(
                      color: AppColors.orangeBase, // background: #E95322
                      borderRadius: BorderRadius.circular(50.2143),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Yes, logout',
                      style: TextStyle(
                        fontFamily: 'League Spartan',
                        fontSize: 22.4643,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEmailDialog(BuildContext context, String email) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.font2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        title: Text(
          'User Email',
          style: AppTextStyles.title.copyWith(color: AppColors.font),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your registered email address:',
              style: AppTextStyles.paragraph.copyWith(color: AppColors.font),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.yellow2,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Text(
                email,
                style: AppTextStyles.subtitulo.copyWith(
                  color: AppColors.font,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: PrimaryButton(
              text: 'Close',
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final profileCubit = context.read<ProfileCubit>();

    bool obscureCurrent = true;
    bool obscureNew = true;
    bool obscureConfirm = true;

    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: profileCubit,
        child: BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ChangePasswordSuccess) {
              Navigator.pop(dialogContext);
            }
            if (state is ProfileError) {
              currentPasswordController.clear();
            }
          },
          child: StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                backgroundColor: AppColors.font2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                title: Text(
                  'Change Password',
                  style: AppTextStyles.title.copyWith(color: AppColors.font),
                ),
                content: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Password',
                          style: AppTextStyles.subtitulo.copyWith(
                            color: AppColors.font,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: currentPasswordController,
                          obscureText: obscureCurrent,
                          style: AppTextStyles.paragraph.copyWith(color: AppColors.font),
                          decoration: _buildInputDecoration(
                            'Current Password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscureCurrent ? Icons.visibility_off : Icons.visibility,
                                color: AppColors.font,
                                size: 20,
                              ),
                              onPressed: () => setDialogState(() => obscureCurrent = !obscureCurrent),
                            ),
                          ),
                          validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'New Password',
                          style: AppTextStyles.subtitulo.copyWith(
                            color: AppColors.font,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: newPasswordController,
                          obscureText: obscureNew,
                          style: AppTextStyles.paragraph.copyWith(color: AppColors.font),
                          decoration: _buildInputDecoration(
                            'New Password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscureNew ? Icons.visibility_off : Icons.visibility,
                                color: AppColors.font,
                                size: 20,
                              ),
                              onPressed: () => setDialogState(() => obscureNew = !obscureNew),
                            ),
                          ),
                          validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Confirm New Password',
                          style: AppTextStyles.subtitulo.copyWith(
                            color: AppColors.font,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: confirmPasswordController,
                          obscureText: obscureConfirm,
                          style: AppTextStyles.paragraph.copyWith(color: AppColors.font),
                          decoration: _buildInputDecoration(
                            'Confirm New Password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscureConfirm ? Icons.visibility_off : Icons.visibility,
                                color: AppColors.font,
                                size: 20,
                              ),
                              onPressed: () => setDialogState(() => obscureConfirm = !obscureConfirm),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Required';
                            if (value != newPasswordController.text) return 'Passwords do not match';
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                actionsPadding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                actions: [
                  Center(
                    child: Column(
                      children: [
                        PrimaryButton(
                          text: 'Change',
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context.read<ProfileCubit>().changePassword(
                                    currentPassword: currentPasswordController.text,
                                    newPassword: newPasswordController.text,
                                  );
                            }
                          },
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: Text(
                            'Cancel',
                            style: AppTextStyles.paragraph.copyWith(
                              color: AppColors.orangeBase,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, {Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.paragraph.copyWith(
        color: AppColors.font.withValues(alpha: 0.5),
      ),
      filled: true,
      fillColor: AppColors.yellow2,
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(
          color: AppColors.orangeBase,
          width: 1.5,
        ),
      ),
      errorStyle: AppTextStyles.paragraph.copyWith(
        color: AppColors.orangeBase,
        fontSize: 12,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(
          color: AppColors.orangeBase,
          width: 1.5,
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.font2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        title: Text(
          'Delete Account',
          style: AppTextStyles.title.copyWith(color: AppColors.font),
        ),
        content: Text(
          'Are you sure you want to delete your account? This action cannot be undone and you will be logged out immediately.',
          style: AppTextStyles.paragraph.copyWith(color: AppColors.font),
        ),
        actionsPadding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        actions: [
          Center(
            child: Column(
              children: [
                PrimaryButton(
                  text: 'Cancel',
                  onPressed: () => Navigator.pop(dialogContext),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    context.read<ProfileCubit>().deleteAccount();
                    Navigator.pop(dialogContext);
                  },
                  child: Text(
                    'Delete Account',
                    style: AppTextStyles.paragraph.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String iconPath,
    required String label,
    required VoidCallback onTap,
  }) {
    final bool shouldStack = label != 'Show Email';
    final formattedLabel = shouldStack ? label.replaceAll(' ', '\n') : label;

    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.font2,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      iconPath,
                      width: 16,
                      height: 16,
                      colorFilter: const ColorFilter.mode(
                        AppColors.orangeBase,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: Text(
                    formattedLabel,
                    style: TextStyle(
                      fontFamily: 'League Spartan',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      height: shouldStack ? 1.1 : 1.0,
                      color: AppColors.yellow2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(
          color: Color(0xFFFFD8C7),
          thickness: 1,
          height: 1,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
