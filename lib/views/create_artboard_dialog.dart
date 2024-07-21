import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rend/provider/canvas_provider.dart';
import 'package:rend/widgets/app_buttons.dart';
import 'package:rend/widgets/app_input_number_field.dart';

class CreateArtboardDialog extends StatefulWidget {
  const CreateArtboardDialog({
    super.key,
  });

  @override
  State<CreateArtboardDialog> createState() => _CreateArtboardDialogState();
}

class _CreateArtboardDialogState extends State<CreateArtboardDialog> {
  bool _isLinked = false;
  double? _width = 500;
  double? _height = 500;
  double? _wBy;
  double? _hBy;

  @override
  void initState() {
    super.initState();
  }

  void setWidth(double? v) {
    if (_width == v) return;
    _width = v;
    if (_isLinked && v != null && _hBy != null) {
      setState(() {
        _height = v * _hBy!;
      });
    }
  }

  void setHeight(double? v) {
    if (_height == v) return;
    _height = v;
    if (_isLinked && v != null && _wBy != null) {
      setState(() {
        _width = v * _wBy!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppInputNumberField(
                alwaysShowOutline: true,
                width: 80,
                suffixText: 'W',
                value: _width,
                onSubmitted: setWidth,
                onChanged: setWidth,
              ),
              LinkButton(
                isActive: _isLinked,
                onTap: () {
                  setState(() {
                    _isLinked = !_isLinked;
                  });
                  if (_width != null && _height != null) {
                    _wBy = _width! / _height!;
                    _hBy = _height! / _width!;
                  }
                },
              ),
              AppInputNumberField(
                alwaysShowOutline: true,
                width: 80,
                suffixText: 'H',
                value: _height,
                onSubmitted: setHeight,
                onChanged: setHeight,
              ),
            ],
          ),
          Consumer(builder: (context, ref, _) {
            return AppButton(
              text: 'Create artboard',
              onTap: () {
                if (_width != null && _height != null) {
                  ref.read(canvasStateProvider).addBoard(_width!, _height!);
                }
              },
            );
          })
        ],
      ),
    );
  }
}
