import 'package:equatable/equatable.dart';

class DashboardFilterKeys {
  static const leadStatus = 'lead_status';
  static const agent = 'agent';
  static const leadSource = 'lead_source';
}

class DashboardFilterState extends Equatable {
  /// Example:
  ///  availableFilters = {
  ///    "lead_status": ["new", "closed", "interested"],
  ///    "agent": ["Manvi", "Ravi"]
  ///  }
  final Map<String, List<String>> availableFilters;

  /// Example:
  ///  selectedFilters = {
  ///     "lead_status": {"new", "interested"}
  ///  }
  final Map<String, Set<String>> selectedFilters;

  const DashboardFilterState({
    this.availableFilters = const {},
    this.selectedFilters = const {},
  });

  bool get hasActiveFilters =>
      selectedFilters.values.any((set) => set.isNotEmpty);

  DashboardFilterState copyWith({
    Map<String, List<String>>? availableFilters,
    Map<String, Set<String>>? selectedFilters,
  }) {
    return DashboardFilterState(
      availableFilters: availableFilters ?? this.availableFilters,
      selectedFilters: selectedFilters ?? this.selectedFilters,
    );
  }

  @override
  List<Object?> get props => [
    availableFilters,
    selectedFilters,
  ];
}
