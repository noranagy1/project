
import 'package:new_project/Ui/statusService/gateService/device_command.dart';

abstract class DeviceState {}


class DeviceInitial extends DeviceState {}


class DeviceLoading extends DeviceState {}

class DeviceCommandSent extends DeviceState {
  final DeviceCommand command;
  DeviceCommandSent(this.command);
}
class DeviceCommandDone extends DeviceState {
  final String type;
  DeviceCommandDone({required this.type});
}

class DeviceError extends DeviceState {
  final String message;
  final String type;
  DeviceError(this.message, {this.type = 'statusService'});
}