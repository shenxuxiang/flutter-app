typedef ListenerCallback = void Function([dynamic arguments]);

class EventBus {
  EventBus._();

  final Map<String, Set<ListenerCallback>> _bucket = {};
  static final EventBus _singleton = EventBus._();

  factory EventBus() {
    return _singleton;
  }

  add(String eventName, ListenerCallback callback) {
    if (_bucket[eventName] == null) _bucket[eventName] = <ListenerCallback>{};

    _bucket[eventName]!.add(callback);
  }

  off(String eventName, [ListenerCallback? callback]) {
    if (_bucket[eventName]?.isEmpty ?? true) return;

    final listeners = _bucket[eventName]!;

    if (callback != null) {
      if (listeners.contains(callback)) listeners.remove(callback);
    } else {
      listeners.clear();
    }
  }

  emit(String eventName, [dynamic arguments]) {
    if (_bucket[eventName]?.isEmpty ?? true) return;

    final listeners = _bucket[eventName]!;
    for (final func in listeners) {
      func.call(arguments);
    }
  }
}

final eventBus = EventBus();
