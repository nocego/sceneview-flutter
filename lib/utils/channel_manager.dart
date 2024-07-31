import 'package:flutter/services.dart';
import 'constants.dart';

class ChannelManager {
  final MethodChannel _channel;
  final EventChannel _eventChannel;

  ChannelManager(int id)
      : _channel = MethodChannel('${ARConstants.methodChannelName}_$id'),
        _eventChannel = EventChannel('${ARConstants.eventChannelName}_$id');

  Future<T?> invokeMethod<T>(String method, [dynamic arguments]) {
    return _channel.invokeMethod<T>(method, arguments);
  }

  Stream<dynamic> get eventStream => _eventChannel.receiveBroadcastStream();
}
