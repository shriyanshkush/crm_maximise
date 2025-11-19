import 'package:equatable/equatable.dart';
import '../../../models/agent_performance_model.dart';
import '../../../models/lead_quality_model.dart';
import '../../../models/lead_sources_model.dart';

abstract class DashboardFilterEvent extends Equatable {
  const DashboardFilterEvent();
  @override
  List<Object?> get props => [];
}

class InitializeDashboardFilters extends DashboardFilterEvent {
  final LeadQualityResponse quality;
  final AgentPerformanceResponse performance;
  final LeadSourcesResponse sources;

  const InitializeDashboardFilters({
    required this.quality,
    required this.performance,
    required this.sources,
  });

  @override
  List<Object?> get props => [quality, performance, sources];
}

class ToggleFilterValue extends DashboardFilterEvent {
  final String filterKey;
  final String value;

  const ToggleFilterValue({required this.filterKey, required this.value});

  @override
  List<Object?> get props => [filterKey, value];
}

class ClearAllFilters extends DashboardFilterEvent {
  const ClearAllFilters();
}
