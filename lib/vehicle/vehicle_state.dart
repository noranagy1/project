import 'vehicle_model.dart';

abstract class VehicleState {}

class VehicleInitialState extends VehicleState {}
class VehicleLoadingState extends VehicleState {}

class VehicleSuccessState extends VehicleState {
  final VehicleModel model;
  VehicleSuccessState({required this.model});
}

class VehicleErrorState extends VehicleState {
  final String message;
  VehicleErrorState({required this.message});
}