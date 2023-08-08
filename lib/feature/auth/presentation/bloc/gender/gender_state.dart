part of 'gender_bloc.dart';

@immutable
abstract class GenderState {}

class GenderInitial extends GenderState {}

class ChangedGenderState extends GenderState {
  final Gender gender;

  ChangedGenderState({required this.gender});
}
