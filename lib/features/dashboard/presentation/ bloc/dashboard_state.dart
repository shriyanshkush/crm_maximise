import 'package:equatable/equatable.dart';
import '../../models/agent_performance_model.dart';
import '../../models/campaign_model.dart';
import '../../models/lead_quality_model.dart';
import '../../models/lead_sources_model.dart';
import '../../models/daily_generation_model.dart';
import '../../models/integrations_status_model.dart';
import '../../models/revenue_growth_model.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final LeadQualityResponse quality;
  final LeadSourcesResponse sources;
  final LeadAnalysisResponse daily;
  final IntegrationsStatusResponse integrations;
  final Map<String, dynamic> topPerformers;
  final AgentPerformanceResponse performance;
  final CampaignResponse campaigns;
  final RevenueGrowthResponse revenueGrowth;


  const DashboardLoaded({
    required this.quality,
    required this.sources,
    required this.daily,
    required this.integrations,
    required this.topPerformers,
    required this.performance,
    required this.campaigns,
    required this.revenueGrowth,
  });

  @override
  List<Object?> get props =>
      [quality, sources, daily, integrations, topPerformers,performance,campaigns,revenueGrowth];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
