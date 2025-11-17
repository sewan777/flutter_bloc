import 'package:flutter_bloc/flutter_bloc.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(const NotificationState()) {
    on<AddNotificationEvent>((event, emit) {
      final updatedNotifications = [
        event.notification,
        ...state.notifications,
      ];
      emit(state.copyWith(notifications: updatedNotifications));
    });

    on<RemoveNotificationEvent>((event, emit) {
      final updatedNotifications = state.notifications
          .where((notification) => notification.id != event.id)
          .toList();
      emit(state.copyWith(notifications: updatedNotifications));
    });

    on<MarkNotificationReadEvent>((event, emit) {
      final updatedNotifications = state.notifications.map((notification) {
        if (notification.id == event.id) {
          return notification.copyWith(isRead: true);
        }
        return notification;
      }).toList();
      emit(state.copyWith(notifications: updatedNotifications));
    });

    on<ClearAllNotificationsEvent>((event, emit) {
      final onlyImportant = state.notifications
          .where((notification) => notification.isImportant && !notification.isRead)
          .toList();
      emit(state.copyWith(notifications: onlyImportant));
    });
  }
}