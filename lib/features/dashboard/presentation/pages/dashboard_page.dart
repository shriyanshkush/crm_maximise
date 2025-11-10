import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../ bloc/dashboard_bloc.dart';
import '../ bloc/dashboard_event.dart';
import '../ bloc/dashboard_state.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // Replace with user's orgId from login
    context.read<DashboardBloc>().add(LoadDashboardEvent("690f120de27997ac7fbb5075"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),

      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DashboardError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is DashboardLoaded) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildCard('Lead Quality', '${state.quality.summary['totalLeads']} Total Leads'),
                _buildCard('Top Source', state.sources.summary['topSource'] ?? '-'),
                _buildCard('Integrations', '${state.integrations.integrations.length} Connected'),
                _buildCard('Top Performers', '${state.topPerformers['data']?['totalPerformers'] ?? 0}'),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(value, style: const TextStyle(fontSize: 18, color: Colors.blue)),
      ),
    );
  }
}
