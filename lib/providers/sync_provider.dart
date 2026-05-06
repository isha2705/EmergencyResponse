import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:emergency_response/data/repositories/incident_repository.dart';
import 'package:emergency_response/providers/incident_provider.dart';

enum SyncStatus { idle, syncing, synced, error }

final syncStatusProvider =
    AsyncNotifierProvider<SyncNotifier, SyncStatus>(() => SyncNotifier());

class SyncNotifier extends AsyncNotifier<SyncStatus> {
  StreamSubscription? _sub;

  @override
  Future<SyncStatus> build() async {
    _sub?.cancel();
    _sub = Connectivity().onConnectivityChanged.listen((result) async {
      final hasConnection = result != ConnectivityResult.none;
      if (hasConnection) {
        await _doSync();
      }
    });
    ref.onDispose(() => _sub?.cancel());
    return SyncStatus.idle;
  }

  Future<void> manualSync() async {
    await _doSync();
  }

  Future<void> _doSync() async {
    state = const AsyncData(SyncStatus.syncing);
    try {
      final repo = ref.read(incidentRepositoryProvider);
      final unsynced = await repo.getUnsyncedIncidents();
      for (final incident in unsynced) {
        // Simulate network delay
        await Future.delayed(const Duration(milliseconds: 300));
        await repo.markAsSynced(incident.id);
      }
      ref.read(incidentsProvider.notifier).refresh();
      state = const AsyncData(SyncStatus.synced);
      await Future.delayed(const Duration(seconds: 3));
      state = const AsyncData(SyncStatus.idle);
    } catch (_) {
      state = const AsyncData(SyncStatus.error);
    }
  }
}
