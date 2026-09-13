import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';

class FilterScreen extends StatefulWidget {
  final double initialMaxPrice;
  const FilterScreen({super.key, required this.initialMaxPrice});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late double _currentMaxPrice;

  @override
  void initState() {
    super.initState();
    _currentMaxPrice = widget.initialMaxPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.font2,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.font),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Filter',
          style: AppTextStyles.title.copyWith(color: AppColors.font),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Price Range',
              style: AppTextStyles.subtitulo.copyWith(color: AppColors.font),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('0 EGP', style: TextStyle(fontFamily: 'League Spartan')),
                Text('${_currentMaxPrice.toStringAsFixed(0)} EGP', 
                    style: const TextStyle(fontFamily: 'League Spartan', fontWeight: FontWeight.bold, color: AppColors.orangeBase)),
                const Text('1000 EGP', style: TextStyle(fontFamily: 'League Spartan')),
              ],
            ),
            Slider(
              value: _currentMaxPrice,
              min: 0,
              max: 1000,
              activeColor: AppColors.orangeBase,
              inactiveColor: AppColors.orange2,
              onChanged: (value) {
                setState(() {
                  _currentMaxPrice = value;
                });
              },
            ),
            const Spacer(),
            Center(
              child: PrimaryButton(
                text: 'Apply Filter',
                onPressed: () => Navigator.pop(context, _currentMaxPrice),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
