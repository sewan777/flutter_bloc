import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import '../bloc/notification_state.dart';
import '../widgets/notification_card.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

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
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state.notifications.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No notifications',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
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
                                  .add(RemoveNotificationEvent(notification.id));
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
    );
  }
}