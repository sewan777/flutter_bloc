import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import '../bloc/notification_state.dart';
import '../widgets/notification_card.dart';
import '../models/notification_model.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  Future<void> _playNotificationSound(bool isImportant) async {
    try {
      final player = AudioPlayer();
      if (isImportant) {
        await player.play(AssetSource('sounds/alert.mp3'));
      } else {
        await player.play(AssetSource('sounds/notification.mp3'));
      }
    } catch (e) {
      print('Error playing notification sound: $e');
    }
  }

  void _showSystemNotification(BuildContext context, AppNotification notification) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    // Play notification sound
    _playNotificationSound(notification.isImportant);

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 8,
        right: 8,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, -50 * (1 - value)),
                child: Opacity(
                  opacity: value.clamp(0.0, 1.0),
                  child: child,
                ),
              );
            },
            onEnd: () {
              Future.delayed(const Duration(seconds: 4), () {
                try {
                  if (overlayEntry.mounted) {
                    overlayEntry.remove();
                  }
                } catch (e) {
                  // Overlay already removed
                }
              });
            },
            child: GestureDetector(
              onTap: () {
                overlayEntry.remove();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationScreen(),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: notification.isImportant
                      ? Colors.red.shade50
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: notification.isImportant
                            ? Colors.red.shade100
                            : Colors.blue.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        notification.isImportant
                            ? Icons.priority_high
                            : Icons.notifications,
                        color: notification.isImportant
                            ? Colors.red.shade700
                            : Colors.blue.shade700,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  notification.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                'now',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            notification.body,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
  }

  void _sendTestNotification(BuildContext context, {required bool isImportant}) {
    final notification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: isImportant ? '⚠️ Important Notification' : '📢 Regular Notification',
      body: isImportant
          ? 'This is an urgent message that requires your attention!'
          : 'This is a regular notification message.',
      isImportant: isImportant,
      timestamp: DateTime.now(),
      isRead: false,
    );

    context.read<NotificationBloc>().add(AddNotificationEvent(notification));

    // Show system-style notification
    _showSystemNotification(context, notification);
  }

  void _sendCustomNotification(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final titleController = TextEditingController();
        final bodyController = TextEditingController();
        bool isImportant = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Send Custom Notification'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.title),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: bodyController,
                      decoration: const InputDecoration(
                        labelText: 'Message',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.message),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Mark as Important'),
                      subtitle: const Text('Important notifications cannot be dismissed until read'),
                      value: isImportant,
                      onChanged: (value) {
                        setState(() {
                          isImportant = value;
                        });
                      },
                      activeColor: Colors.red,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty &&
                        bodyController.text.isNotEmpty) {
                      final notification = AppNotification(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: titleController.text,
                        body: bodyController.text,
                        isImportant: isImportant,
                        timestamp: DateTime.now(),
                        isRead: false,
                      );

                      // Use the original context from NotificationScreen
                      context.read<NotificationBloc>().add(
                        AddNotificationEvent(notification),
                      );

                      Navigator.pop(dialogContext);

                      // Show system-style notification
                      _showSystemNotification(context, notification);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill in all fields'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text('Send'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _sendBulkNotifications(BuildContext context) {
    final notifications = [
      AppNotification(
        id: '${DateTime.now().millisecondsSinceEpoch}_1',
        title: '📋 Task Reminder',
        body: 'You have 5 pending tasks to complete today',
        isImportant: false,
        timestamp: DateTime.now(),
      ),
      AppNotification(
        id: '${DateTime.now().millisecondsSinceEpoch}_2',
        title: '🎉 Achievement Unlocked',
        body: 'You completed 10 tasks this week!',
        isImportant: false,
        timestamp: DateTime.now(),
      ),
      AppNotification(
        id: '${DateTime.now().millisecondsSinceEpoch}_3',
        title: '⏰ Deadline Alert',
        body: 'Project deadline is tomorrow at 5 PM',
        isImportant: true,
        timestamp: DateTime.now(),
      ),
    ];

    // Add all notifications to bloc
    for (var notification in notifications) {
      context.read<NotificationBloc>().add(AddNotificationEvent(notification));
    }

    // Show them one by one with delay
    for (int i = 0; i < notifications.length; i++) {
      Future.delayed(Duration(milliseconds: i * 500), () {
        _showSystemNotification(context, notifications[i]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              context.read<NotificationBloc>().add(ClearAllNotificationsEvent());
            },
            tooltip: 'Clear all non-important',
          ),
        ],
      ),
      body: Column(
        children: [
          // Test Notification Buttons Section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.science, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      'Test Notifications',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // First Row - Regular and Important
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _sendTestNotification(
                          context,
                          isImportant: false,
                        ),
                        icon: const Icon(Icons.notifications),
                        label: const Text('Regular'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _sendTestNotification(
                          context,
                          isImportant: true,
                        ),
                        icon: const Icon(Icons.priority_high),
                        label: const Text('Important'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Second Row - Custom and Bulk
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _sendCustomNotification(context),
                        icon: const Icon(Icons.edit),
                        label: const Text('Custom'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _sendBulkNotifications(context),
                        icon: const Icon(Icons.send_and_archive),
                        label: const Text('Bulk (3)'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Notifications List
          Expanded(
            child: BlocBuilder<NotificationBloc, NotificationState>(
              builder: (context, state) {
                if (state.notifications.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_none,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No notifications',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try sending a test notification above',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: state.notifications.length,
                  itemBuilder: (context, index) {
                    final notification = state.notifications[index];

                    return NotificationCard(
                      notification: notification,
                      onDismiss: () {
                        context
                            .read<NotificationBloc>()
                            .add(RemoveNotificationEvent(notification.id));
                      },
                      onTap: () {
                        if (notification.isImportant && !notification.isRead) {
                          context
                              .read<NotificationBloc>()
                              .add(MarkNotificationReadEvent(notification.id));

                          // Show dialog for important notifications
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text(notification.title),
                              content: Text(notification.body),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    context
                                        .read<NotificationBloc>()
                                        .add(RemoveNotificationEvent(
                                        notification.id));
                                  },
                                  child: const Text('Dismiss'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}