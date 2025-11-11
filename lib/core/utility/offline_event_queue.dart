import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class QueuedEvent {
  QueuedEvent({
    required this.eventName,
    required this.properties,
    required this.createdAt,
  });

  final String eventName;
  final Map<String, dynamic> properties;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'event_name': eventName,
        'created_at': createdAt.toIso8601String(),
        'properties': properties,
      };

  static QueuedEvent? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final name = json['event_name']?.toString();
    final createdAtRaw = json['created_at']?.toString();
    final propsRaw = json['properties'];
    if (name == null || createdAtRaw == null || propsRaw is! Map) {
      return null;
    }
    return QueuedEvent(
      eventName: name,
      properties: Map<String, dynamic>.from(propsRaw),
      createdAt: DateTime.tryParse(createdAtRaw) ?? DateTime.now(),
    );
  }
}

/// Simple persistent queue to keep analytics events until connectivity is restored.
class OfflineEventQueue {
  OfflineEventQueue();

  Future<File> _resolveFile() async {
    final dir = await getApplicationSupportDirectory();
    final file = File('${dir.path}/mixpanel_event_queue.json');
    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsString('[]');
    }
    return file;
  }

  Future<List<QueuedEvent>> _readAll() async {
    try {
      final file = await _resolveFile();
      final content = await file.readAsString();
      final data = jsonDecode(content);
      if (data is List) {
        return data
            .map((entry) {
              if (entry is Map<String, dynamic>) {
                return QueuedEvent.fromJson(entry);
              }
              if (entry is Map) {
                return QueuedEvent.fromJson(
                  Map<String, dynamic>.from(entry.cast<String, dynamic>()),
                );
              }
              return null;
            })
            .whereType<QueuedEvent>()
            .toList();
      }
    } catch (_) {}
    return <QueuedEvent>[];
  }

  Future<void> _writeAll(List<QueuedEvent> events) async {
    final file = await _resolveFile();
    final payload = jsonEncode(events.map((e) => e.toJson()).toList());
    await file.writeAsString(payload, flush: true);
  }

  Future<void> enqueue(QueuedEvent event) async {
    final events = await _readAll();
    events.add(event);
    await _writeAll(events);
  }

  Future<List<QueuedEvent>> drain() async {
    final events = await _readAll();
    await _writeAll(<QueuedEvent>[]);
    return events;
  }

  Future<void> replace(List<QueuedEvent> events) async {
    await _writeAll(events);
  }
}
