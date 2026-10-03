part of 'loader_bloc.dart';

abstract class LoaderEvent {}

class LoaderInitEvent extends LoaderEvent {}

class LoaderGetLocalDataEvent extends LoaderEvent {
  final Size size;

  LoaderGetLocalDataEvent({required this.size});
}

class UpdateUserLocationEvent extends LoaderEvent {}
