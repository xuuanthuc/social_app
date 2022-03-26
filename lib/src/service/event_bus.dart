import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

class OnMessageNoticeClickedEvent{
  Map<String, dynamic> data;
  OnMessageNoticeClickedEvent(this.data);
}

class OnPostNoticeClickedEvent{
  Map<String, dynamic> data;
  OnPostNoticeClickedEvent(this.data);
}

class OnFollowNoticeClickedEvent{
  Map<String, dynamic> data;
  OnFollowNoticeClickedEvent(this.data);
}