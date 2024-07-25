import 'dart:async';
import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rend/objects/art_board.dart';
import 'package:rend/objects/base_object.dart';

final cleanGizmosLevelProviderState = StateProvider<int>((ref) => 0);

final isShiftIsPressedStateProvider = StateProvider<bool>((ref) => false);
final isAltIsPressedStateProvider = StateProvider<bool>((ref) => false);

final canvasStateProvider =
    ChangeNotifierProvider((ref) => AppCanvasNotifier(ref));

class AppCanvasNotifier extends ChangeNotifier {
  final ChangeNotifierProviderRef<Object?> _ref;

  AppCanvasNotifier(this._ref);

  final List<Artboard> _roots = [];

  BaseObject? _selected;

  BaseObject? get selected => _selected;

  List<BaseObject> get roots => _roots;

  void selectObject(BaseObject? obj) {
    if (_selected == obj) return;
    _selected = obj;
    notifyListeners();
  }

  int _getTheHighestId() {
    return _roots.fold(0, (a, b) => a > b.id ? a : b.id);
  }

  Artboard? getBoardById(int id) {
    return _roots.firstWhereOrNull((e) => e.id == id);
  }

  int getBoardIndexById(int id) {
    return _roots.indexWhere((e) => e.id == id);
  }

  void addBoard(double width, double height) {
    final i = _getTheHighestId() + 1;
    _roots.add(
      Artboard.empty(id: i, name: 'Artboard $i', width: width, height: height),
    );
    notifyListeners();
  }

  Offset getBoardActualPosition(BaseObject board) {
    return board.position;
  }

  Timer? _clearGizmoTimeout;

  void _cleanGizmoTimeout(int level) {
    if (_ref.read(cleanGizmosLevelProviderState) != level) {
      _ref.read(cleanGizmosLevelProviderState.notifier).state = level;
    }
    _clearGizmoTimeout?.cancel();
    _clearGizmoTimeout = Timer(const Duration(milliseconds: 500), () {
      _ref.read(cleanGizmosLevelProviderState.notifier).state = 0;
    });
  }

  void updateStrokeWidth(BaseObject object, double width) {
    if (object is Artboard) return;
    object.strokeWidth = width;
    notifyListeners();
    _cleanGizmoTimeout(2);
  }

  void updateStroke(BaseObject object, int index, Color color) {
    if (object is Artboard) return;
    if (index > object.strokes.length - 1) return;
    object.strokes[index] = color;
    if (object.strokeWidth == 0) object.strokeWidth = 1;
    notifyListeners();
    _cleanGizmoTimeout(2);
  }

  void updateFill(BaseObject object, int index, Color color) {
    if (index > object.fills.length - 1) return;
    object.fills[index] = color;
    notifyListeners();
    _cleanGizmoTimeout(1);
  }

  void updatePosition(BaseObject object, Offset delta) {
    final isShift = _ref.read(isShiftIsPressedStateProvider);
    final radians = object.rotation * (math.pi / 180.0);
    final cos = math.cos(radians);
    final sin = math.sin(radians);
    final by = Offset(
      delta.dx * cos - delta.dy * sin,
      delta.dx * sin + delta.dy * cos,
    );
    final x = (object.position.dx + by.dx);
    final y = (object.position.dy + by.dy);
    object.position = Offset(x.roundToDouble(), y.roundToDouble());
    notifyListeners();
  }

  void updateOrigin(BaseObject object, Offset delta) {
    if (object is Artboard) return;
    final x = (object.origin.dx + delta.dx);
    final y = (object.origin.dy + delta.dy);
    object.origin = Offset(x.roundToDouble(), y.roundToDouble());
    notifyListeners();
  }

  bool _isFlipped = false;
  bool? _isFlippedNegative;
  void onDragEnd() {
    _isFlipped = false;
    _isFlippedNegative = null;
  }

  void updateWidthHeight(
    BaseObject object, {
    required double deltaX,
    required double deltaY,
    required bool reverseX,
    required bool reverseY,
  }) {
    _updateWidth(object, deltaX, reverseX);
    _updateHeight(object, deltaY, reverseY);
    notifyListeners();
  }

  void updateHeight(BaseObject object, double deltaY, bool reverse) {
    _updateHeight(object, deltaY, reverse);
    notifyListeners();
  }

  void _updateHeight(BaseObject object, double deltaY, bool reverse) {
    bool flipReset = false;
    double newH = object.height + deltaY;
    if (_isFlipped || newH <= 0) {
      if (!_isFlipped) {
        _isFlipped = true;
        _isFlippedNegative = deltaY < 0;
      }
      newH = object.height + deltaY.abs();

      if (_isFlipped && _isFlippedNegative != null) {
        if (_isFlippedNegative! && deltaY > 0) {
          if (object.height - deltaY >= 0) {
            newH = object.height - deltaY;
          } else {
            flipReset = true;
          }
        }
      }
    }
    if (!_ref.read(isAltIsPressedStateProvider)) {
      object.position = Offset(
        object.position.dx,
        reverse
            ? object.position.dy - (deltaY * 0.5)
            : object.position.dy + (deltaY * 0.5),
      );
    } else {
      if (_isFlipped) {
        if (_isFlippedNegative != null &&
            _isFlippedNegative! &&
            deltaY > 0 &&
            object.height - deltaY >= 0) {
          newH -= deltaY.abs();
        } else {
          newH += deltaY.abs();
        }
      } else {
        newH += deltaY;
      }
    }
    if (flipReset) {
      _isFlipped = false;
      _isFlippedNegative = null;
    }
    object.height = newH < 0 ? 0 : newH;
    notifyListeners();
  }

  void updateWidth(BaseObject object, double deltaX, bool reverse) {
    _updateWidth(object, deltaX, reverse);
    notifyListeners();
  }

  void _updateWidth(BaseObject object, double deltaX, bool reverse) {
    bool flipReset = false;
    double newW = object.width + deltaX;
    if (_isFlipped || newW <= 0) {
      if (!_isFlipped) {
        _isFlipped = true;
        _isFlippedNegative = deltaX < 0;
      }
      newW = object.width + deltaX.abs();

      if (_isFlipped && _isFlippedNegative != null) {
        if (_isFlippedNegative! && deltaX > 0) {
          if (object.width - deltaX >= 0) {
            newW = object.width - deltaX;
          } else {
            flipReset = true;
          }
        }
      }
    }
    if (!_ref.read(isAltIsPressedStateProvider)) {
      object.position = Offset(
        reverse
            ? object.position.dx - (deltaX * 0.5)
            : object.position.dx + (deltaX * 0.5),
        object.position.dy,
      );
    } else {
      if (_isFlipped) {
        if (_isFlippedNegative != null &&
            _isFlippedNegative! &&
            deltaX > 0 &&
            object.height - deltaX >= 0) {
          newW -= deltaX.abs();
        } else {
          newW += deltaX.abs();
        }
      } else {
        newW += deltaX;
      }
    }
    if (flipReset) {
      _isFlipped = false;
      _isFlippedNegative = null;
    }
    object.width = newW < 0 ? 0 : newW;
    notifyListeners();
  }

  void updateRotation(BaseObject object, double value) {
    if (object is Artboard) return;
    object.rotation = value;
    notifyListeners();
  }

  void updateRotationBy(BaseObject object, double valueBy) {
    if (object is Artboard) return;
    object.rotation += valueBy;
    notifyListeners();
  }

  void updateSizeBy(BaseObject object, Offset updateBy) {
    final x = (object.position.dx + updateBy.dx);
    final y = (object.position.dy + updateBy.dy);
    object.position = Offset(x.roundToDouble(), y.roundToDouble());
    notifyListeners();
  }

  bool removeBoardById(int id) {
    final index = getBoardIndexById(id);
    if (index == -1) return false;
    _roots.removeAt(index);
    notifyListeners();
    return true;
  }

  bool deleteObject(Object obj) {
    bool result = false;
    if (obj is Artboard) result = _roots.remove(obj);
    notifyListeners();
    return result;
  }
}
