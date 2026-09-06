import 'package:flutter/material.dart';
import 'package:tremor/core/index.dart' show TremorColors;

class TremorFilterBarWidget extends StatelessWidget {
  const new({
    required this.selectedMinMag,
    required this.onMagnitudeSelected,
    super.key,
  });

  final double selectedMinMag;
  final ValueChanged<double> onMagnitudeSelected;

  @override
  Widget build(BuildContext context) {
    const options = [
      (label: 'All (2.0+)', val: 2),
      (label: '3.0+', val: 3),
      (label: '5.0+ (Severe)', val: 5),
    ];

    return Container(
      height: 56,
      color: TremorColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (final opt in options)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(opt.label),
                selected: selectedMinMag == opt.val,
                selectedColor: TremorColors.moderate,
                onSelected: (selected) {
                  if (selected) {
                    onMagnitudeSelected(opt.val.toDouble());
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}

class TremorFilterBarDelegate extends SliverPersistentHeaderDelegate {
  const new({
    required this.selectedMinMag,
    required this.onMagnitudeSelected,
  });

  final double selectedMinMag;
  final ValueChanged<double> onMagnitudeSelected;

  @override
  double get minExtent => 56;

  @override
  double get maxExtent => 56;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return TremorFilterBarWidget(
      selectedMinMag: selectedMinMag,
      onMagnitudeSelected: onMagnitudeSelected,
    );
  }

  @override
  bool shouldRebuild(covariant TremorFilterBarDelegate oldDelegate) {
    return oldDelegate.selectedMinMag != selectedMinMag;
  }
}
