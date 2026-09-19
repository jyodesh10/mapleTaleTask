part of 'nav_cubit.dart';

sealed class NavState extends Equatable {
  const NavState();

  @override
  List<Object> get props => [];
}

final class NavInitial extends NavState {}
