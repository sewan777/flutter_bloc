import 'package:equatable/equatable.dart';
import '../models/notification_model.dart';

class NotificationState extends Equatable {
  final List<AppNotification> notifications;

  const NotificationState({this.notifications = const []});

  NotificationState copyWith({List<AppNotification>? notifications}) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
    );
  }

  int get unreadCount =>
      notifications.where((n) => !n.isRead).length;

  @override
  List<Object> get props => [notifications];
}