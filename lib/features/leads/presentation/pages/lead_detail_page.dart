// features/leads/presentation/pages/lead_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/lead_detail/lead_detail_bloc.dart';
import '../bloc/lead_detail/lead_detail_event.dart';
import '../bloc/lead_detail/lead_detail_state.dart';
import '../../models/lead_model.dart';

class LeadDetailPage extends StatefulWidget {
  final String leadId;

  const LeadDetailPage({super.key, required this.leadId});

  @override
  State<LeadDetailPage> createState() => _LeadDetailPageState();
}

class _LeadDetailPageState extends State<LeadDetailPage> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load lead details once page opens
    context.read<LeadDetailBloc>().add(LoadLeadDetailEvent(widget.leadId));
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lead Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<LeadDetailBloc, LeadDetailState>(
        listener: (context, state) {
          if (state is NoteAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Note added successfully')),
            );
            // reload updated details
            context
                .read<LeadDetailBloc>()
                .add(LoadLeadDetailEvent(widget.leadId));
          } else if (state is LeadDetailError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is LeadDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LeadDetailError) {
            return Center(child: Text('❌ ${state.message}'));
          } else if (state is LeadDetailLoaded) {
            final lead = state.lead;
            return _buildLeadDetails(context, lead);
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Widget _buildLeadDetails(BuildContext context, LeadModel lead) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                lead.name,
                style:
                const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Chip(
                label: Text(lead.status.toUpperCase()),
                backgroundColor: Colors.green.shade100,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Client info card
          Card(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Client Information',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const Divider(),
                  _infoRow('Full Name', lead.name),
                  _infoRow('Email Address', lead.email),
                  _infoRow('Phone Number', lead.phone),
                  _infoRow('Lead Source', lead.source),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      // optional: open dialer later
                    },
                    icon: const Icon(Icons.call, color: Colors.white),
                    label: const Text('Call'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Notes Section
          Card(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Notes',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const Divider(),
                  if (lead.notes.isEmpty)
                    const Text('No notes added yet.',
                        style: TextStyle(color: Colors.grey))
                  else
                    Column(
                      children: lead.notes.map((n) {
                        return ListTile(
                          leading: const Icon(Icons.note),
                          title: Text(n['content'] ?? ''),
                          subtitle: Text(n['createdAt'] ?? ''),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _noteController,
                    decoration: InputDecoration(
                      hintText: 'Add a note about this lead...',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      final content = _noteController.text.trim();
                      if (content.isNotEmpty) {
                        context
                            .read<LeadDetailBloc>()
                            .add(AddNoteEvent(widget.leadId, content));
                        _noteController.clear();
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Note'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Timeline Section
          Card(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Timeline',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const Divider(),
                  if (lead.timeline.isEmpty)
                    const Text('No timeline events.',
                        style: TextStyle(color: Colors.grey))
                  else
                    Column(
                      children: lead.timeline.map((t) {
                        return ListTile(
                          leading: const Icon(Icons.history),
                          title: Text(t['title'] ?? 'No title'),
                          subtitle: Text(t['description'] ?? ''),
                          trailing: Text(
                            t['performedAt']?.toString().substring(0, 10) ?? '',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Flexible(child: Text(value, textAlign: TextAlign.end)),
        ],
      ),
    );
  }
}
