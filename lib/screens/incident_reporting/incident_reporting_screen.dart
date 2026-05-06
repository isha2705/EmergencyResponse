import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:emergency_response/core/constants/app_colors.dart';
import 'package:emergency_response/core/constants/app_strings.dart';
import 'package:emergency_response/core/utils/validators.dart';
import 'package:emergency_response/data/enums/incident_category.dart';
import 'package:emergency_response/data/enums/incident_priority.dart';
import 'package:emergency_response/data/enums/incident_status.dart';
import 'package:emergency_response/data/models/incident.dart';
import 'package:emergency_response/providers/incident_provider.dart';

class IncidentReportingScreen extends ConsumerStatefulWidget {
  const IncidentReportingScreen({super.key});

  @override
  ConsumerState<IncidentReportingScreen> createState() => _IncidentReportingScreenState();
}

class _IncidentReportingScreenState extends ConsumerState<IncidentReportingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _locationController = TextEditingController();

  IncidentCategory _category = IncidentCategory.other;
  IncidentPriority _priority = IncidentPriority.medium;
  bool _isSubmitting = false;

  void _submitIncident() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      final incident = Incident(
        id: const Uuid().v4(),
        title: _titleController.text,
        description: _descController.text,
        category: _category,
        priority: _priority,
        status: IncidentStatus.reported,
        timestamp: DateTime.now(),
        location: _locationController.text,
        isSynced: false,
      );

      await ref.read(incidentsProvider.notifier).addIncident(incident);

      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.reportSuccess),
            backgroundColor: AppColors.statusResolved,
          ),
        );
        context.pop();
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.reportIncident),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: AppStrings.incidentTitle,
                hintText: AppStrings.titleHint,
              ),
              validator: Validators.validateTitle,
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: AppStrings.description,
                hintText: AppStrings.descriptionHint,
                alignLabelWithHint: true,
              ),
              validator: Validators.validateDescription,
            ),
            const SizedBox(height: 16),

            // Category Dropdown
            DropdownButtonFormField<IncidentCategory>(
              value: _category,
              decoration: const InputDecoration(labelText: AppStrings.category),
              items: IncidentCategory.values.map((cat) {
                return DropdownMenuItem(
                  value: cat,
                  child: Row(
                    children: [
                      Icon(cat.icon, color: cat.color, size: 20),
                      const SizedBox(width: 8),
                      Text(cat.displayName),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (val) => setState(() => _category = val!),
            ),
            const SizedBox(height: 24),

            // Priority Selection
            const Text('Priority Level', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: IncidentPriority.values.map((priority) {
                final isSelected = _priority == priority;
                return ChoiceChip(
                  label: Text(priority.displayName),
                  selected: isSelected,
                  selectedColor: priority.color,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    if (selected) setState(() => _priority = priority);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Location
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: AppStrings.location,
                hintText: AppStrings.locationHint,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.my_location),
                  onPressed: () {
                    // MOCK GPS location for demo
                    _locationController.text = 'Lat: 40.7128, Lng: -74.0060';
                  },
                  tooltip: AppStrings.useGps,
                ),
              ),
              validator: Validators.validateLocation,
            ),
            const SizedBox(height: 32),

            // Submit
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitIncident,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: _priority.color, // Adaptive button color
              ),
              child: _isSubmitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(AppStrings.submitReport),
            ),
          ],
        ),
      ),
    );
  }
}
