import 'package:new_project/Ui/statusService/gateService/device_command.dart';

abstract class DeviceState {}

class DeviceInitial extends DeviceState {}

// ✅ States منفصلة للـ Gate
class DeviceGateLoading extends DeviceState {}
class DeviceGateCommandSent extends DeviceState {
  final DeviceCommand command;
  DeviceGateCommandSent(this.command);
}

// ✅ States منفصلة للـ Camera
class DeviceCameraLoading extends DeviceState {}
class DeviceCameraCommandSent extends DeviceState {
  final DeviceCommand command;
  DeviceCameraCommandSent(this.command);
}

// ✅ Shared states
class DeviceCommandDone extends DeviceState {
  final String type; // 'gate' أو 'camera'
  DeviceCommandDone({required this.type});
}

class DeviceError extends DeviceState {
  final String message;
  final String type;
  DeviceError(this.message, {this.type = 'gate'});
}