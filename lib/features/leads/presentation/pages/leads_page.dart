import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/leads_bloc.dart';
import '../bloc/leads_event.dart';
import '../bloc/leads_state.dart';
import '../../models/lead_model.dart';

class LeadsPage extends StatefulWidget {
  const LeadsPage({super.key});

  @override
  State<LeadsPage> createState() => _LeadsPageState();
}

class _LeadsPageState extends State<LeadsPage> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _sourceCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<LeadsBloc>().add(const LoadLeadsEvent());
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _sourceCtrl.dispose();
    super.dispose();
  }

  void _showAddLeadDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Lead'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
              const SizedBox(height: 8),
              TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
              const SizedBox(height: 8),
              TextField(controller: _phoneCtrl, decoration: const InputDecoration(labelText: 'Phone')),
              const SizedBox(height: 8),
              TextField(controller: _sourceCtrl, decoration: const InputDecoration(labelText: 'Source')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final name = _nameCtrl.text.trim();
              final email = _emailCtrl.text.trim();
              final phone = _phoneCtrl.text.trim();
              final source = _sourceCtrl.text.trim().isEmpty ? 'website' : _sourceCtrl.text.trim();

              context.read<LeadsBloc>().add(CreateLeadEvent(name: name, email: email, phone: phone, source: source));
              Navigator.pop(ctx);
            },
            child: const Text('Add Lead'),
          ),
        ],
      ),
    );
  }

  Widget _leadTile(LeadModel lead) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(child: Text(lead.name.isNotEmpty ? lead.name[0].toUpperCase() : '?')),
        title: Text(lead.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(lead.email),
            const SizedBox(height: 4),
            Text(lead.phone),
            const SizedBox(height: 4),
            Row(children: [Chip(label: Text(lead.source)), const SizedBox(width: 8), Chip(label: Text(lead.status))]),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Leads'),
        actions: [
          IconButton(onPressed: () => _showAddLeadDialog(), icon: const Icon(Icons.add)),
          IconButton(onPressed: () => context.read<LeadsBloc>().add(RefreshLeadsEvent()), icon: const Icon(Icons.refresh)),
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'export') {
                context.read<LeadsBloc>().add(const ExportCsvEvent());
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'export', child: Text('Export CSV')),
            ],
          ),
        ],
      ),
      body: BlocConsumer<LeadsBloc, LeadsState>(
        listener: (context, state) {
          if (state is LeadsError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is LeadCreated) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lead created')));
          } else if (state is CsvExported) {
            // For demo we just show length
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('CSV exported (${state.csvContent.length} chars)')));
          }
        },
        builder: (context, state) {
          if (state is LeadsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LeadsLoaded) {
            final leads = state.leads;
            return RefreshIndicator(
              onRefresh: () async {
                context.read<LeadsBloc>().add(const LoadLeadsEvent());
              },
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  // summary cards
                  Row(
                    children: [
                      Expanded(child: Card(child: Padding(padding: const EdgeInsets.all(12), child: Text('Total Leads: ${state.statistics['organization']?['totalLeads'] ?? 0}')))),
                      const SizedBox(width: 8),
                      Expanded(child: Card(child: Padding(padding: const EdgeInsets.all(12), child: Text('Duplicate: ${state.statistics['organization']?['duplicateLeads'] ?? 0}')))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // leads list
                  ...leads.map((l) => _leadTile(l)).toList(),
                  const SizedBox(height: 12),
                  // pagination info
                  Text('Page: ${state.pagination['page'] ?? 1} • Total: ${state.pagination['total'] ?? leads.length}'),
                ],
              ),
            );
          } else if (state is LeadsError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
