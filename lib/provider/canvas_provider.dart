import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rend/objects/art_board.dart';
import 'package:rend/objects/base_object.dart';

final isAltIsPressedStateProvider = StateProvider<bool>((ref) => false);

final canvasStateProvider =
    ChangeNotifierProvider((ref) => AppCanvasNotifier(ref));

class AppCanvasNotifier extends ChangeNotifier {
  final ChangeNotifierProviderRef<Object?> _ref;

  AppCanvasNotifier(this._ref);

  final List<Artboard> _boards = [];

  BaseObject? _selected;

  BaseObject? get selected => _selected;

  List<Artboard> get boards => _boards;

  void selectObject(BaseObject? obj) {
    _selected = obj;
    notifyListeners();
  }

  int _getTheHighestId() {
    return _boards.fold(0, (a, b) => a > b.id ? a : b.id);
  }

  Artboard? getBoardById(int id) {
    return _boards.firstWhereOrNull((e) => e.id == id);
  }

  int getBoardIndexById(int id) {
    return _boards.indexWhere((e) => e.id == id);
  }

  void addBoard(double width, double height) {
    final i = _getTheHighestId() + 1;
    _boards.add(
      Artboard(id: i, name: 'Artboard $i', width: width, height: height),
    );
    notifyListeners();
  }

  Offset getBoardActualPosition(BaseObject board) {
    return Offset(
      board.position.dx + board.width / 2,
      board.position.dy + board.height / 2,
    );
  }

  void updatePosition(BaseObject object, Offset updateBy) {
    final x = (object.position.dx + updateBy.dx);
    final y = (object.position.dy + updateBy.dy);
    object.position = Offset(x.roundToDouble(), y.roundToDouble());
    notifyListeners();
  }

  bool _isFlipped = false;
  bool? _isFlippedNegative;
  void onDragEnd() {
    _isFlipped = false;
    _isFlippedNegative = null;
  }

  void updateHeight(BaseObject object, double deltaY, bool reverse) {
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
            _isFlipped = false;
            _isFlippedNegative = null;
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
      newH += deltaY;
    }
    object.height = newH;
    notifyListeners();
  }

  void updateWidth(BaseObject object, double deltaX, bool reverse) {
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
            _isFlipped = false;
            _isFlippedNegative = null;
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
      newW += deltaX;
    }
    object.width = newW;
    notifyListeners();
  }

  void updateSize(BaseObject object, Offset updateBy) {
    final x = (object.position.dx + updateBy.dx);
    final y = (object.position.dy + updateBy.dy);
    object.position = Offset(x.roundToDouble(), y.roundToDouble());
    notifyListeners();
  }

  bool removeBoardById(int id) {
    final index = getBoardIndexById(id);
    if (index == -1) return false;
    _boards.removeAt(index);
    notifyListeners();
    return true;
  }

  bool deleteObject(Object obj) {
    bool result = false;
    if (obj is Artboard) result = _boards.remove(obj);
    notifyListeners();
    return result;
  }
}
