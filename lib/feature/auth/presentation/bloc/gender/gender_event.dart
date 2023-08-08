part of 'gender_bloc.dart';

@immutable
abstract class GenderEvent {}

class ChangeGenderEvent extends GenderEvent {
  final Gender newGender;

  ChangeGenderEvent({required this.newGender});
}
