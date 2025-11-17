import 'package:flutter/material.dart';
import '../models/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onDismiss;
  final VoidCallback onTap;

  const NotificationCard({
    Key? key,
    required this.notification,
    required this.onDismiss,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final canDismiss = !notification.isImportant || notification.isRead;

    return Dismissible(
      key: Key(notification.id),
      direction: canDismiss
          ? DismissDirection.endToStart
          : DismissDirection.none,
      onDismissed: canDismiss ? (_) => onDismiss() : null,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        elevation: notification.isImportant ? 4 : 2,
        color: notification.isRead
            ? null
            : (notification.isImportant
            ? Colors.red.shade50
            : Colors.blue.shade50),
        child: ListTile(
          leading: Icon(
            notification.isImportant
                ? Icons.priority_high
                : Icons.notifications,
            color: notification.isImportant ? Colors.red : Colors.blue,
          ),
          title: Text(
            notification.title,
            style: TextStyle(
              fontWeight:
              notification.isRead ? FontWeight.normal : FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(notification.body),
              const SizedBox(height: 4),
              Text(
                _formatTime(notification.timestamp),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          trailing: notification.isImportant && !notification.isRead
              ? const Icon(Icons.lock, color: Colors.red, size: 20)
              : null,
          onTap: onTap,
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}