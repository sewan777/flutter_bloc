import 'package:equatable/equatable.dart';
import '../models/notification_model.dart';

abstract class NotificationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddNotificationEvent extends NotificationEvent {
  final AppNotification notification;

  AddNotificationEvent(this.notification);

  @override
  List<Object> get props => [notification];
}

class RemoveNotificationEvent extends NotificationEvent {
  final String id;

  RemoveNotificationEvent(this.id);

  @override
  List<Object> get props => [id];
}

class MarkNotificationReadEvent extends NotificationEvent {
  final String id;

  MarkNotificationReadEvent(this.id);

  @override
  List<Object> get props => [id];
}

class ClearAllNotificationsEvent extends NotificationEvent {}