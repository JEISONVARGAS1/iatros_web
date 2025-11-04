// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HomeState {
  UserModel get myUser => throw _privateConstructorUsedError;
  StreamSubscription<dynamic>? get userSub =>
      throw _privateConstructorUsedError;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HomeStateCopyWith<HomeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeStateCopyWith<$Res> {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) then) =
      _$HomeStateCopyWithImpl<$Res, HomeState>;
  @useResult
  $Res call({UserModel myUser, StreamSubscription<dynamic>? userSub});
}

/// @nodoc
class _$HomeStateCopyWithImpl<$Res, $Val extends HomeState>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? myUser = null,
    Object? userSub = freezed,
  }) {
    return _then(_value.copyWith(
      myUser: null == myUser
          ? _value.myUser
          : myUser // ignore: cast_nullable_to_non_nullable
              as UserModel,
      userSub: freezed == userSub
          ? _value.userSub
          : userSub // ignore: cast_nullable_to_non_nullable
              as StreamSubscription<dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HomeStateDataImplCopyWith<$Res>
    implements $HomeStateCopyWith<$Res> {
  factory _$$HomeStateDataImplCopyWith(
          _$HomeStateDataImpl value, $Res Function(_$HomeStateDataImpl) then) =
      __$$HomeStateDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({UserModel myUser, StreamSubscription<dynamic>? userSub});
}

/// @nodoc
class __$$HomeStateDataImplCopyWithImpl<$Res>
    extends _$HomeStateCopyWithImpl<$Res, _$HomeStateDataImpl>
    implements _$$HomeStateDataImplCopyWith<$Res> {
  __$$HomeStateDataImplCopyWithImpl(
      _$HomeStateDataImpl _value, $Res Function(_$HomeStateDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? myUser = null,
    Object? userSub = freezed,
  }) {
    return _then(_$HomeStateDataImpl(
      myUser: null == myUser
          ? _value.myUser
          : myUser // ignore: cast_nullable_to_non_nullable
              as UserModel,
      userSub: freezed == userSub
          ? _value.userSub
          : userSub // ignore: cast_nullable_to_non_nullable
              as StreamSubscription<dynamic>?,
    ));
  }
}

/// @nodoc

class _$HomeStateDataImpl implements HomeStateData {
  const _$HomeStateDataImpl({required this.myUser, this.userSub});

  @override
  final UserModel myUser;
  @override
  final StreamSubscription<dynamic>? userSub;

  @override
  String toString() {
    return 'HomeState(myUser: $myUser, userSub: $userSub)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeStateDataImpl &&
            (identical(other.myUser, myUser) || other.myUser == myUser) &&
            (identical(other.userSub, userSub) || other.userSub == userSub));
  }

  @override
  int get hashCode => Object.hash(runtimeType, myUser, userSub);

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeStateDataImplCopyWith<_$HomeStateDataImpl> get copyWith =>
      __$$HomeStateDataImplCopyWithImpl<_$HomeStateDataImpl>(this, _$identity);
}

abstract class HomeStateData implements HomeState {
  const factory HomeStateData(
      {required final UserModel myUser,
      final StreamSubscription<dynamic>? userSub}) = _$HomeStateDataImpl;

  @override
  UserModel get myUser;
  @override
  StreamSubscription<dynamic>? get userSub;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomeStateDataImplCopyWith<_$HomeStateDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
