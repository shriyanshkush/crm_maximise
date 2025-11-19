import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_filter_event.dart';
import 'dashboard_filter_state.dart';

class DashboardFilterBloc
    extends Bloc<DashboardFilterEvent, DashboardFilterState> {
  DashboardFilterBloc() : super(const DashboardFilterState()) {
    on<InitializeDashboardFilters>(_onInitFilters);
    on<ToggleFilterValue>(_onToggleFilter);
    on<ClearAllFilters>(_onClearAllFilters);
  }

  // ----------------------------------------------------------
  // 1️⃣ INITIALIZE FILTER OPTIONS (called once when dashboard loads)
  // ----------------------------------------------------------
  void _onInitFilters(
      InitializeDashboardFilters event,
      Emitter<DashboardFilterState> emit,
      ) {
    final leadStatuses = event.quality.quality
        .map((e) => e.name.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList()
      ..sort(); // alphabetic

    final agents = event.performance.users
        .map((u) => u.name.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList()
      ..sort();

    final sources = event.sources.sources
        .map((s) => s.source.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList()
      ..sort();

    final available = {
      DashboardFilterKeys.leadStatus: leadStatuses,
      DashboardFilterKeys.agent: agents,
      DashboardFilterKeys.leadSource: sources,
    };

    emit(state.copyWith(availableFilters: available));
  }

  // ----------------------------------------------------------
  // 2️⃣ TOGGLE VALUE INSIDE A FILTER GROUP
  // ----------------------------------------------------------
  void _onToggleFilter(
      ToggleFilterValue event,
      Emitter<DashboardFilterState> emit,
      ) {
    final selected = Map<String, Set<String>>.from(state.selectedFilters);

    // Deep copy the set if exists
    final currentSet = Set<String>.from(selected[event.filterKey] ?? {});

    if (currentSet.contains(event.value)) {
      currentSet.remove(event.value);
    } else {
      currentSet.add(event.value);
    }

    if (currentSet.isEmpty) {
      selected.remove(event.filterKey);
    } else {
      selected[event.filterKey] = currentSet;
    }

    emit(state.copyWith(selectedFilters: selected));
  }

  // ----------------------------------------------------------
  // 3️⃣ CLEAR ALL FILTERS
  // ----------------------------------------------------------
  void _onClearAllFilters(
      ClearAllFilters event,
      Emitter<DashboardFilterState> emit,
      ) {
    emit(state.copyWith(selectedFilters: {}));
  }
}
