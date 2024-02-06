import 'package:flutter/material.dart';

import '../values/values.dart';

class StateLoadingWidget extends StatelessWidget {
  const StateLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.PADDING_16),
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}
