part of '../main.dart';

class DraftService {
  static final List<CreatedJob> _drafts = <CreatedJob>[];
  static bool _initialized = false;

  static File get _storageFile {
    final tempDir = Directory.systemTemp.path;
    return File('$tempDir/ev_draft_inspections.json');
  }

  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    try {
      final file = _storageFile;
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.trim().isNotEmpty) {
          final List<dynamic> jsonList = jsonDecode(content) as List<dynamic>;
          _drafts.clear();
          for (final item in jsonList) {
            if (item is Map<String, dynamic>) {
              _drafts.add(CreatedJob.fromJson(item));
            }
          }
        }
      }
    } catch (e) {
      debugPrint('DraftService init error: $e');
    }
  }

  static List<CreatedJob> get drafts {
    if (!_initialized) {
      init();
    }
    return List<CreatedJob>.unmodifiable(_drafts);
  }

  static CreatedJob? getDraftById(String id) {
    try {
      return _drafts.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  static void saveDraft(CreatedJob job) {
    if (!_initialized) {
      init();
    }
    final draftToSave = CreatedJob(
      id: job.id,
      customerName: job.customerName,
      mobileNumber: job.mobileNumber,
      email: job.email,
      address: job.address,
      vehicleNumber: job.vehicleNumber,
      vehicleBrand: job.vehicleBrand,
      vehicleModel: job.vehicleModel,
      vehicleType: job.vehicleType,
      motorNumber: job.motorNumber,
      batteryNumber: job.batteryNumber,
      odometerReading: job.odometerReading,
      registrationDate: job.registrationDate,
      status: job.status.isEmpty ? 'Draft' : job.status,
      scheduleTime: job.scheduleTime.isEmpty ? 'Today, 11:30 AM' : job.scheduleTime,
      location: job.location.isEmpty ? 'EV Care Service Centre' : job.location,
      othersNotes: job.othersNotes,
      isDraft: true,
    );

    final existingIndex = _drafts.indexWhere((d) => d.id == draftToSave.id);
    if (existingIndex >= 0) {
      _drafts[existingIndex] = draftToSave;
    } else {
      _drafts.insert(0, draftToSave);
    }
    _persist();
  }

  static void removeDraft(String id) {
    _drafts.removeWhere((d) => d.id == id);
    _persist();
  }

  static void _persist() {
    try {
      final file = _storageFile;
      final jsonList = _drafts.map((d) => d.toJson()).toList();
      file.writeAsStringSync(jsonEncode(jsonList));
    } catch (e) {
      debugPrint('DraftService persist error: $e');
    }
  }
}
