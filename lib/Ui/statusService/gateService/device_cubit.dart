import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:new_project/Ui/statusService/gateService/device_service.dart';
import 'device_state.dart';

class DeviceCubit extends Cubit<DeviceState> {
  final DeviceService _deviceService;
  Timer? _pollingTimer;

  DeviceCubit(this._deviceService) : super(DeviceInitial());


  Future<void> sendCommand(String command) async {
    emit(DeviceLoading());
    try {
      final sentCommand = await _deviceService.sendCommand(command);
      emit(DeviceCommandSent(sentCommand));
      _startPolling(isCamera: false);
    } catch (e) {
      emit(DeviceError(e.toString(), type: 'statusService'));
    }
  }



  Future<void> sendCameraCommand(String command) async {
    emit(DeviceLoading());
    try {
      final sentCommand = await _deviceService.sendCameraCommand(command);
      emit(DeviceCommandSent(sentCommand));
      _startPolling(isCamera: true);
    } catch (e) {
      emit(DeviceError(e.toString(), type: 'camera'));
    }
  }

  void _startPolling({required bool isCamera}) {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(
      const Duration(seconds: 2),
          (_) => isCamera ? _checkCameraCommandStatus() : _checkCommandStatus(),
    );
  }

  Future<void> _checkCommandStatus() async {
    try {
      final isDone = await _deviceService.isCommandDone();
      if (isDone) {
        _pollingTimer?.cancel();
        emit(DeviceCommandDone(type: 'statusService'));
      }
    } catch (e) {
      _pollingTimer?.cancel();
      emit(DeviceError(e.toString(), type: 'statusService'));
    }
  }

  Future<void> _checkCameraCommandStatus() async {
    try {
      final isDone = await _deviceService.isCameraCommandDone();
      if (isDone) {
        _pollingTimer?.cancel();
        emit(DeviceCommandDone(type: 'camera'));
      }
    } catch (e) {
      _pollingTimer?.cancel();
      emit(DeviceError(e.toString(), type: 'camera'));
    }
  }

  void reset() {
    _pollingTimer?.cancel();
    emit(DeviceInitial());
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    return super.close();
  }
}