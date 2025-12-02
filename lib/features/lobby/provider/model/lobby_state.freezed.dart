// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lobby_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LobbyState {
  double get width => throw _privateConstructorUsedError;
  UserModel get myUser => throw _privateConstructorUsedError;
  int get selectedIndex => throw _privateConstructorUsedError;
  bool get isMenuVisible => throw _privateConstructorUsedError;
  TabController? get tabController => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LobbyStateCopyWith<LobbyState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LobbyStateCopyWith<$Res> {
  factory $LobbyStateCopyWith(
          LobbyState value, $Res Function(LobbyState) then) =
      _$LobbyStateCopyWithImpl<$Res, LobbyState>;
  @useResult
  $Res call(
      {double width,
      UserModel myUser,
      int selectedIndex,
      bool isMenuVisible,
      TabController? tabController});
}

/// @nodoc
class _$LobbyStateCopyWithImpl<$Res, $Val extends LobbyState>
    implements $LobbyStateCopyWith<$Res> {
  _$LobbyStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? width = null,
    Object? myUser = null,
    Object? selectedIndex = null,
    Object? isMenuVisible = null,
    Object? tabController = freezed,
  }) {
    return _then(_value.copyWith(
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      myUser: null == myUser
          ? _value.myUser
          : myUser // ignore: cast_nullable_to_non_nullable
              as UserModel,
      selectedIndex: null == selectedIndex
          ? _value.selectedIndex
          : selectedIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isMenuVisible: null == isMenuVisible
          ? _value.isMenuVisible
          : isMenuVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      tabController: freezed == tabController
          ? _value.tabController
          : tabController // ignore: cast_nullable_to_non_nullable
              as TabController?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LobbyStateDataImplCopyWith<$Res>
    implements $LobbyStateCopyWith<$Res> {
  factory _$$LobbyStateDataImplCopyWith(_$LobbyStateDataImpl value,
          $Res Function(_$LobbyStateDataImpl) then) =
      __$$LobbyStateDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double width,
      UserModel myUser,
      int selectedIndex,
      bool isMenuVisible,
      TabController? tabController});
}

/// @nodoc
class __$$LobbyStateDataImplCopyWithImpl<$Res>
    extends _$LobbyStateCopyWithImpl<$Res, _$LobbyStateDataImpl>
    implements _$$LobbyStateDataImplCopyWith<$Res> {
  __$$LobbyStateDataImplCopyWithImpl(
      _$LobbyStateDataImpl _value, $Res Function(_$LobbyStateDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? width = null,
    Object? myUser = null,
    Object? selectedIndex = null,
    Object? isMenuVisible = null,
    Object? tabController = freezed,
  }) {
    return _then(_$LobbyStateDataImpl(
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      myUser: null == myUser
          ? _value.myUser
          : myUser // ignore: cast_nullable_to_non_nullable
              as UserModel,
      selectedIndex: null == selectedIndex
          ? _value.selectedIndex
          : selectedIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isMenuVisible: null == isMenuVisible
          ? _value.isMenuVisible
          : isMenuVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      tabController: freezed == tabController
          ? _value.tabController
          : tabController // ignore: cast_nullable_to_non_nullable
              as TabController?,
    ));
  }
}

/// @nodoc

class _$LobbyStateDataImpl implements LobbyStateData {
  const _$LobbyStateDataImpl(
      {required this.width,
      required this.myUser,
      required this.selectedIndex,
      required this.isMenuVisible,
      this.tabController});

  @override
  final double width;
  @override
  final UserModel myUser;
  @override
  final int selectedIndex;
  @override
  final bool isMenuVisible;
  @override
  final TabController? tabController;

  @override
  String toString() {
    return 'LobbyState(width: $width, myUser: $myUser, selectedIndex: $selectedIndex, isMenuVisible: $isMenuVisible, tabController: $tabController)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LobbyStateDataImpl &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.myUser, myUser) || other.myUser == myUser) &&
            (identical(other.selectedIndex, selectedIndex) ||
                other.selectedIndex == selectedIndex) &&
            (identical(other.isMenuVisible, isMenuVisible) ||
                other.isMenuVisible == isMenuVisible) &&
            (identical(other.tabController, tabController) ||
                other.tabController == tabController));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, width, myUser, selectedIndex, isMenuVisible, tabController);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LobbyStateDataImplCopyWith<_$LobbyStateDataImpl> get copyWith =>
      __$$LobbyStateDataImplCopyWithImpl<_$LobbyStateDataImpl>(
          this, _$identity);
}

abstract class LobbyStateData implements LobbyState {
  const factory LobbyStateData(
      {required final double width,
      required final UserModel myUser,
      required final int selectedIndex,
      required final bool isMenuVisible,
      final TabController? tabController}) = _$LobbyStateDataImpl;

  @override
  double get width;
  @override
  UserModel get myUser;
  @override
  int get selectedIndex;
  @override
  bool get isMenuVisible;
  @override
  TabController? get tabController;
  @override
  @JsonKey(ignore: true)
  _$$LobbyStateDataImplCopyWith<_$LobbyStateDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
