import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ bloc/filter_blocs/dashboard_filter_bloc.dart';
import '../../ bloc/filter_blocs/dashboard_filter_event.dart';
import '../../ bloc/filter_blocs/dashboard_filter_state.dart';

class DashboardFilterBottomSheet extends StatelessWidget {
  const DashboardFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardFilterBloc, DashboardFilterState>(
      builder: (context, state) {
        final available = state.availableFilters;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ---------- HEADER ----------
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  // IconButton(
                  //   icon: const Icon(Icons.close),
                  //   onPressed: () => Navigator.pop(context),
                  // ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F2), // light grey background
                        shape: BoxShape.circle,        // makes it round
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  const Expanded(
                    child: Center(
                      child: Text(
                        "Filter by",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: state.hasActiveFilters
                        ? () {
                      context
                          .read<DashboardFilterBloc>()
                          .add(const ClearAllFilters());
                    }
                        : null,
                    child: Text(
                      "Reset",
                      style: TextStyle(
                        color: state.hasActiveFilters
                            ? Colors.red
                            : Colors.grey.shade400,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // ---------- FILTER GROUPS ----------
            Expanded(
              child: ListView(
                children: [
                  _filterGroupTile(
                    context,
                    title: "Lead Status",
                    filterKey: DashboardFilterKeys.leadStatus,
                    hasOptions:
                    (available[DashboardFilterKeys.leadStatus] ?? []).isNotEmpty,
                  ),
                  _filterGroupTile(
                    context,
                    title: "Agent",
                    filterKey: DashboardFilterKeys.agent,
                    hasOptions:
                    (available[DashboardFilterKeys.agent] ?? []).isNotEmpty,
                  ),
                  _filterGroupTile(
                    context,
                    title: "Lead Source",
                    filterKey: DashboardFilterKeys.leadSource,
                    hasOptions:
                    (available[DashboardFilterKeys.leadSource] ?? []).isNotEmpty,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _filterGroupTile(
      BuildContext context, {
        required String title,
        required String filterKey,
        required bool hasOptions,
      }) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: hasOptions
          ? () {
        final state = context.read<DashboardFilterBloc>().state;
        final options = state.availableFilters[filterKey] ?? [];

        Navigator.of(context).push(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => _SubFilterSheet(
              title: title,
              filterKey: filterKey,
              options: options,
            ),
          ),
        );
      }
          : null,
    );
  }
}

class _SubFilterSheet extends StatefulWidget {
  final String title;
  final String filterKey;
  final List<String> options;

  const _SubFilterSheet({
    super.key,
    required this.title,
    required this.filterKey,
    required this.options,
  });

  @override
  State<_SubFilterSheet> createState() => _SubFilterSheetState();
}

class _SubFilterSheetState extends State<_SubFilterSheet> {
  String _search = "";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardFilterBloc, DashboardFilterState>(
      builder: (context, state) {
        final selected = state.selectedFilters[widget.filterKey] ?? <String>{};

        final filtered = widget.options
            .where(
              (e) => e.toLowerCase().contains(_search.toLowerCase()),
        )
            .toList();

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                // ---------- HEADER ----------
                Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F2F2),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.arrow_back_ios_new, size: 14, color: Colors.black87),
                              SizedBox(width: 4),
                              Text("Filter by"),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                // ---------- SEARCH ----------
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      isDense: true,
                    ),
                    onChanged: (value) {
                      setState(() => _search = value);
                    },
                  ),
                ),

                const Divider(height: 1),

                // ---------- OPTIONS ----------
                Expanded(
                  child: ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (_, index) {
                      final value = filtered[index];
                      final isSelected = selected.contains(value);

                      return CheckboxListTile(
                        value: isSelected,
                        title: Text(value),
                        onChanged: (_) {
                          context.read<DashboardFilterBloc>().add(
                            ToggleFilterValue(
                              filterKey: widget.filterKey,
                              value: value,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

