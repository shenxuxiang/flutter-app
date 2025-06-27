import 'package:gaimon/gaimon.dart';

class UserTapFeedback {
  static bool _isOk = false;

  static init() async {
    _isOk = await Gaimon.canSupportsHaptic;
  }

  static selection() {
    assert(_isOk, 'Gaimon is not initial');
    Gaimon.selection();
  }

  static error() {
    assert(_isOk, 'Gaimon is not initial');
    Gaimon.error();
  }

  static success() {
    assert(_isOk, 'Gaimon is not initial');
    Gaimon.success();
  }

  static warning() {
    assert(_isOk, 'Gaimon is not initial');
    Gaimon.warning();
  }

  static heavy() {
    assert(_isOk, 'Gaimon is not initial');
    Gaimon.heavy();
  }

  static medium() {
    assert(_isOk, 'Gaimon is not initial');
    Gaimon.medium();
  }

  static light() {
    assert(_isOk, 'Gaimon is not initial');
    Gaimon.light();
  }

  static rigid() {
    assert(_isOk, 'Gaimon is not initial');
    Gaimon.rigid();
  }

  static soft() {
    assert(_isOk, 'Gaimon is not initial');
    Gaimon.soft();
  }
}
