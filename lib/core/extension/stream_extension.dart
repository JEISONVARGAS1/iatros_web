import 'dart:async';

extension ContextExtension on Stream {
  Stream<T> StreamToStream<Y, T>(Function(Y, EventSink<T>) handleData) =>
      this.transform(
        StreamTransformer<Y, T>.fromHandlers(handleData: handleData),
      );
}
