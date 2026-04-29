import '../repositories/local_task_repository.dart';
import '../services/api_service.dart';
import '../services/database_service.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

class MigrationService {
  final LocalTaskRepository _localRepo = LocalTaskRepository();
  final ApiService _apiService = ApiService();
  final DatabaseService _dbService = DatabaseService();

  Future<bool> migrateToCloud() async {
    try {
      // Upload tasks
      final tasks = await _localRepo.getAllTasksRaw();
      for (final task in tasks) {
        await _apiService.dio.post('/tasks', data: {
          'title': task['title'],
          'description': task['description'],
          'due_at': task['due_at'],
          'recurrence_rule': task['recurrence_rule'] != null
              ? jsonDecode(task['recurrence_rule'] as String)
              : null,
          'recurrence_timezone': task['recurrence_timezone'],
        });
      }

      // Upload task lists
      final taskLists = await _localRepo.getAllTaskListsRaw();
      for (final list in taskLists) {
        await _apiService.dio.post('/task-lists', data: {
          'title': list['title'],
          'description': list['description'],
          'type': list['type'] ?? 'checklist',
          'icon': list['icon'],
          'color': list['color'],
        });
      }

      // Delete local database
      await _dbService.deleteDatabase();
      return true;
    } catch (e) {
      debugPrint('Migration error: $e');
      return false;
    }
  }
}
