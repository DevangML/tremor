import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tremor/core/index.dart' show TremorColors;
import 'package:tremor/features/earthquakes/presentation/index.dart'
    show
        EarthquakeBloc,
        EarthquakeCardUiModel,
        EarthquakeErrorState,
        EarthquakeInitialState,
        EarthquakeLoadedState,
        EarthquakeLoadingState,
        EarthquakeState,
        FetchEarthquakesEvent,
        FilterByMagnitudeEvent,
        MagnitudeBadgeWidget,
        TremorFilterBarDelegate;

final class EarthquakeFeedPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TremorColors.background,
      body: BlocBuilder<EarthquakeBloc, EarthquakeState>(
        builder: (context, state) => switch (state) {
          EarthquakeInitialState() => _buildIdleView(context),
          EarthquakeLoadingState() => const Center(
            child: CircularProgressIndicator(color: TremorColors.moderate),
          ),
          EarthquakeLoadedState(:final earthquakes, :final selectedMinMag) =>
              _buildLoadedView(
            context,
            earthquakes,
            selectedMinMag,
          ),
          EarthquakeErrorState(:final message) => _buildErrorView(
            context,
            message,
          ),
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: TremorColors.moderate,
        onPressed: () =>
            context.read<EarthquakeBloc>().add(FetchEarthquakesEvent()),
        child: const Icon(Icons.refresh, color: Colors.black),
      ),
    );
  }

  Widget _buildIdleView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.public, size: 64, color: Colors.white38),
          const SizedBox(height: 16),
          const Text(
            'Tremor Live Monitor',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () =>
                context.read<EarthquakeBloc>().add(FetchEarthquakesEvent()),
            child: const Text('Scan Active Quakes'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedView(
    BuildContext context,
    List<EarthquakeCardUiModel> items,
    double selectedMinMag,
  ) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar.large(
          backgroundColor: TremorColors.background,
          title: Text('Active Tremors', style: TextStyle(color: Colors.white)),
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: TremorFilterBarDelegate(
            selectedMinMag: selectedMinMag,
            onMagnitudeSelected: (mag) => context
                .read<EarthquakeBloc>()
                .add(FilterByMagnitudeEvent(mag)),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          sliver: SliverList.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                color: const Color(0xFF1E1E1E),
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      MagnitudeBadgeWidget(
                        mag: item.rawMag,
                        color: item.severityColor,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.place,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.formattedTime,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: TremorColors.severe,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
