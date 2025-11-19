import 'dart:ui' as ui;
import 'package:crm_maximise/features/dashboard/presentation/pages/widgets/dashboard_filter_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../ bloc/dashboard_bloc.dart';
import '../ bloc/dashboard_event.dart';
import '../ bloc/dashboard_state.dart';

import '../ bloc/filter_blocs/dashboard_filter_bloc.dart';
import '../ bloc/filter_blocs/dashboard_filter_event.dart';
import '../ bloc/filter_blocs/dashboard_filter_state.dart';
import '../../models/agent_performance_model.dart';
import '../../models/lead_quality_model.dart';
import '../../models/lead_sources_model.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/lead_status_section.dart';
import 'widgets/LeadSourceCard.dart';
import 'widgets/LeadAnalysisCard.dart';
import 'widgets/agent_performance_section.dart';
import 'widgets/campaign_wise_card.dart';
import 'widgets/growth_card.dart';
import 'widgets/ChannelReportCard.dart';
import '../../../../core/services/pdf_export_service.dart';

class DashboardPage extends StatefulWidget {
  final String orgId;
  const DashboardPage({super.key, required this.orgId});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey _visibleKey = GlobalKey();
  final GlobalKey _hiddenCaptureKey = GlobalKey();

  bool _isCapturing = false;

  String selectedAnalysisView = "weekly";
  String selectedGrowthView = "weekly";

  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(LoadDashboardEvent(widget.orgId));
  }

  // ⭐ PDF Export
  void _exportPdf() async {
    setState(() => _isCapturing = true);

    await PDFExportService.instance.exportFullDashboard(
      captureKey: _hiddenCaptureKey,
      context: context,
    );

    if (mounted) setState(() => _isCapturing = false);
  }

  // ⭐ FILTER BOTTOM SHEET
  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const SizedBox(
        height: 420,
        child: DashboardFilterBottomSheet(),
      ),
    );
  }

  // ===================================================================
  // ⭐ PAGE UI
  // ===================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SafeArea(
        child: BlocListener<DashboardBloc, DashboardState>(
          listener: (context, state) {
            if (state is DashboardLoaded) {
              context.read<DashboardFilterBloc>().add(
                InitializeDashboardFilters(
                  quality: state.quality,
                  performance: state.performance,
                  sources: state.sources,
                ),
              );
            }
          },
          child: BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              if (state is DashboardLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is DashboardError) {
                return Center(child: Text("Error: ${state.message}"));
              }

              if (state is DashboardLoaded) {
                return BlocBuilder<DashboardFilterBloc, DashboardFilterState>(
                  builder: (context, filterState) {
                    // ⭐ 1. Filter Lead Status
                    final filteredQualityItems = _applyLeadStatusFilter(
                        state.quality.quality, filterState);

                    final filteredQuality = LeadQualityResponse(
                      quality: filteredQualityItems,
                      summary: state.quality.summary,
                    );

                    // ⭐ 2. Filter Agents
                    final filteredAgentUsers = _applyAgentFilter(
                        state.performance.users, filterState);

                    final filteredPerformance = AgentPerformanceResponse(
                      users: filteredAgentUsers,
                      organizationTotals:
                      state.performance.organizationTotals,
                    );

                    // ⭐ 3. Filter Lead Sources
                    final filteredSourceItems = _applyLeadSourceFilter(
                        state.sources.sources, filterState);

                    final filteredLeadSources = LeadSourcesResponse(
                      sources: filteredSourceItems,
                      summary: state.sources.summary,
                    );

                    return Stack(
                      children: [
                        // ⭐ Visible Dashboard UI
                        RepaintBoundary(
                          key: _visibleKey,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                DashboardHeader(
                                  onDownload: _exportPdf,
                                  onFilterTap: _openFilterSheet,
                                ),

                                // ⭐ FILTERED DATA USED HERE
                                AgentPerformanceSection(
                                    users: filteredPerformance.users),

                                LeadStatusSection(
                                  quality: filteredQuality.quality,
                                  summary: filteredQuality.summary,
                                ),

                                LeadSourceCard(data: filteredLeadSources),

                                LeadAnalysisCard(
                                  data: state.daily,
                                  view: selectedAnalysisView,
                                  onViewChange: (v) {
                                    setState(() => selectedAnalysisView = v);
                                    context.read<DashboardBloc>().add(
                                      LoadDashboardEvent(
                                        widget.orgId,
                                        view: v,
                                      ),
                                    );
                                  },
                                ),

                                CampaignWiseCard(data: state.campaigns),

                                GrowthCard(
                                  data: state.revenueGrowth,
                                  period: selectedGrowthView,
                                  onPeriodChanged: (p) {
                                    setState(() => selectedGrowthView = p);
                                    context.read<DashboardBloc>().add(
                                      LoadRevenueGrowthEvent(
                                        widget.orgId,
                                        period: p,
                                      ),
                                    );
                                  },
                                ),

                                ChannelReportCard(data: state.integrations),
                                const SizedBox(height: 80),
                              ],
                            ),
                          ),
                        ),

                        // ⭐ Hidden Dashboard for PDF
                        if (_isCapturing)
                          Positioned(
                            left: -5000,
                            top: 0,
                            child: RepaintBoundary(
                              key: _hiddenCaptureKey,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                color: const Color(0xFFF8F9FB),
                                child: Column(
                                  children: [
                                    DashboardHeader(onDownload: () {}, onFilterTap: () {  },),

                                    AgentPerformanceSection(
                                        users: filteredPerformance.users),

                                    LeadStatusSection(
                                      quality: filteredQuality.quality,
                                      summary: filteredQuality.summary,
                                    ),

                                    LeadSourceCard(data: filteredLeadSources),

                                    LeadAnalysisCard(
                                      data: state.daily,
                                      view: selectedAnalysisView,
                                      onViewChange: (v) {},
                                    ),

                                    CampaignWiseCard(data: state.campaigns),

                                    GrowthCard(
                                      data: state.revenueGrowth,
                                      period: selectedGrowthView,
                                      onPeriodChanged: (p) {},
                                    ),

                                    ChannelReportCard(data: state.integrations),
                                    const SizedBox(height: 80),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------------
  // ⭐ FILTER HELPERS
  // ------------------------------------------------------------------

  List<LeadQualityItem> _applyLeadStatusFilter(
      List<LeadQualityItem> items, DashboardFilterState filterState) {
    final selected = filterState.selectedFilters[DashboardFilterKeys.leadStatus];
    if (selected == null || selected.isEmpty) return items;
    return items.where((e) => selected.contains(e.name)).toList();
  }

  List<AgentUser> _applyAgentFilter(
      List<AgentUser> users, DashboardFilterState filterState) {
    final selected = filterState.selectedFilters[DashboardFilterKeys.agent];
    if (selected == null || selected.isEmpty) return users;
    return users.where((u) => selected.contains(u.name)).toList();
  }

  List<LeadSourceItem> _applyLeadSourceFilter(
      List<LeadSourceItem> sources, DashboardFilterState filterState) {
    final selected =
    filterState.selectedFilters[DashboardFilterKeys.leadSource];
    if (selected == null || selected.isEmpty) return sources;
    return sources.where((s) => selected.contains(s.source)).toList();
  }
}
