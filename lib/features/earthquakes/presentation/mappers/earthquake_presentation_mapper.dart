import 'package:tremor/core/index.dart' show TremorColors;
import 'package:tremor/features/earthquakes/domain/index.dart'
    show EarthquakeEntity;
import 'package:tremor/features/earthquakes/presentation/index.dart'
    show EarthquakeCardUiModel;

final class EarthquakePresentationMapper {
  const new();

  EarthquakeCardUiModel toUiModel(EarthquakeEntity entity) {
    return EarthquakeCardUiModel(
      id: entity.id,
      formattedMag: entity.mag.toStringAsFixed(1),
      place: entity.place,
      formattedTime: _formatTime(entity.time),
      severityColor: TremorColors.severityColor(entity.mag),
      rawMag: entity.mag,
    );
  }

  List<EarthquakeCardUiModel> toUiModelList(List<EarthquakeEntity> entities) {
    return entities.map(toUiModel).toList();
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
