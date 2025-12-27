// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'global_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GlobalState {
  UserModel get myUser => throw _privateConstructorUsedError;
  StreamSubscription<dynamic>? get userSub =>
      throw _privateConstructorUsedError;
  StreamSubscription<dynamic>? get userCompanySub =>
      throw _privateConstructorUsedError;
  StreamSubscription<dynamic>? get doctorSettingSub =>
      throw _privateConstructorUsedError;
  DoctorSettingModel get doctorSetting => throw _privateConstructorUsedError;
  List<UserCompanyModel> get userCompanies =>
      throw _privateConstructorUsedError;
  UserCompanyModel get userCompanySelected =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GlobalStateCopyWith<GlobalState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GlobalStateCopyWith<$Res> {
  factory $GlobalStateCopyWith(
          GlobalState value, $Res Function(GlobalState) then) =
      _$GlobalStateCopyWithImpl<$Res, GlobalState>;
  @useResult
  $Res call(
      {UserModel myUser,
      StreamSubscription<dynamic>? userSub,
      StreamSubscription<dynamic>? userCompanySub,
      StreamSubscription<dynamic>? doctorSettingSub,
      DoctorSettingModel doctorSetting,
      List<UserCompanyModel> userCompanies,
      UserCompanyModel userCompanySelected});
}

/// @nodoc
class _$GlobalStateCopyWithImpl<$Res, $Val extends GlobalState>
    implements $GlobalStateCopyWith<$Res> {
  _$GlobalStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? myUser = null,
    Object? userSub = freezed,
    Object? userCompanySub = freezed,
    Object? doctorSettingSub = freezed,
    Object? doctorSetting = null,
    Object? userCompanies = null,
    Object? userCompanySelected = null,
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
      userCompanySub: freezed == userCompanySub
          ? _value.userCompanySub
          : userCompanySub // ignore: cast_nullable_to_non_nullable
              as StreamSubscription<dynamic>?,
      doctorSettingSub: freezed == doctorSettingSub
          ? _value.doctorSettingSub
          : doctorSettingSub // ignore: cast_nullable_to_non_nullable
              as StreamSubscription<dynamic>?,
      doctorSetting: null == doctorSetting
          ? _value.doctorSetting
          : doctorSetting // ignore: cast_nullable_to_non_nullable
              as DoctorSettingModel,
      userCompanies: null == userCompanies
          ? _value.userCompanies
          : userCompanies // ignore: cast_nullable_to_non_nullable
              as List<UserCompanyModel>,
      userCompanySelected: null == userCompanySelected
          ? _value.userCompanySelected
          : userCompanySelected // ignore: cast_nullable_to_non_nullable
              as UserCompanyModel,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GlobalStateDataImplCopyWith<$Res>
    implements $GlobalStateCopyWith<$Res> {
  factory _$$GlobalStateDataImplCopyWith(_$GlobalStateDataImpl value,
          $Res Function(_$GlobalStateDataImpl) then) =
      __$$GlobalStateDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {UserModel myUser,
      StreamSubscription<dynamic>? userSub,
      StreamSubscription<dynamic>? userCompanySub,
      StreamSubscription<dynamic>? doctorSettingSub,
      DoctorSettingModel doctorSetting,
      List<UserCompanyModel> userCompanies,
      UserCompanyModel userCompanySelected});
}

/// @nodoc
class __$$GlobalStateDataImplCopyWithImpl<$Res>
    extends _$GlobalStateCopyWithImpl<$Res, _$GlobalStateDataImpl>
    implements _$$GlobalStateDataImplCopyWith<$Res> {
  __$$GlobalStateDataImplCopyWithImpl(
      _$GlobalStateDataImpl _value, $Res Function(_$GlobalStateDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? myUser = null,
    Object? userSub = freezed,
    Object? userCompanySub = freezed,
    Object? doctorSettingSub = freezed,
    Object? doctorSetting = null,
    Object? userCompanies = null,
    Object? userCompanySelected = null,
  }) {
    return _then(_$GlobalStateDataImpl(
      myUser: null == myUser
          ? _value.myUser
          : myUser // ignore: cast_nullable_to_non_nullable
              as UserModel,
      userSub: freezed == userSub
          ? _value.userSub
          : userSub // ignore: cast_nullable_to_non_nullable
              as StreamSubscription<dynamic>?,
      userCompanySub: freezed == userCompanySub
          ? _value.userCompanySub
          : userCompanySub // ignore: cast_nullable_to_non_nullable
              as StreamSubscription<dynamic>?,
      doctorSettingSub: freezed == doctorSettingSub
          ? _value.doctorSettingSub
          : doctorSettingSub // ignore: cast_nullable_to_non_nullable
              as StreamSubscription<dynamic>?,
      doctorSetting: null == doctorSetting
          ? _value.doctorSetting
          : doctorSetting // ignore: cast_nullable_to_non_nullable
              as DoctorSettingModel,
      userCompanies: null == userCompanies
          ? _value._userCompanies
          : userCompanies // ignore: cast_nullable_to_non_nullable
              as List<UserCompanyModel>,
      userCompanySelected: null == userCompanySelected
          ? _value.userCompanySelected
          : userCompanySelected // ignore: cast_nullable_to_non_nullable
              as UserCompanyModel,
    ));
  }
}

/// @nodoc

class _$GlobalStateDataImpl implements GlobalStateData {
  const _$GlobalStateDataImpl(
      {required this.myUser,
      this.userSub,
      this.userCompanySub,
      this.doctorSettingSub,
      required this.doctorSetting,
      required final List<UserCompanyModel> userCompanies,
      required this.userCompanySelected})
      : _userCompanies = userCompanies;

  @override
  final UserModel myUser;
  @override
  final StreamSubscription<dynamic>? userSub;
  @override
  final StreamSubscription<dynamic>? userCompanySub;
  @override
  final StreamSubscription<dynamic>? doctorSettingSub;
  @override
  final DoctorSettingModel doctorSetting;
  final List<UserCompanyModel> _userCompanies;
  @override
  List<UserCompanyModel> get userCompanies {
    if (_userCompanies is EqualUnmodifiableListView) return _userCompanies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_userCompanies);
  }

  @override
  final UserCompanyModel userCompanySelected;

  @override
  String toString() {
    return 'GlobalState(myUser: $myUser, userSub: $userSub, userCompanySub: $userCompanySub, doctorSettingSub: $doctorSettingSub, doctorSetting: $doctorSetting, userCompanies: $userCompanies, userCompanySelected: $userCompanySelected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GlobalStateDataImpl &&
            (identical(other.myUser, myUser) || other.myUser == myUser) &&
            (identical(other.userSub, userSub) || other.userSub == userSub) &&
            (identical(other.userCompanySub, userCompanySub) ||
                other.userCompanySub == userCompanySub) &&
            (identical(other.doctorSettingSub, doctorSettingSub) ||
                other.doctorSettingSub == doctorSettingSub) &&
            (identical(other.doctorSetting, doctorSetting) ||
                other.doctorSetting == doctorSetting) &&
            const DeepCollectionEquality()
                .equals(other._userCompanies, _userCompanies) &&
            (identical(other.userCompanySelected, userCompanySelected) ||
                other.userCompanySelected == userCompanySelected));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      myUser,
      userSub,
      userCompanySub,
      doctorSettingSub,
      doctorSetting,
      const DeepCollectionEquality().hash(_userCompanies),
      userCompanySelected);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GlobalStateDataImplCopyWith<_$GlobalStateDataImpl> get copyWith =>
      __$$GlobalStateDataImplCopyWithImpl<_$GlobalStateDataImpl>(
          this, _$identity);
}

abstract class GlobalStateData implements GlobalState {
  const factory GlobalStateData(
          {required final UserModel myUser,
          final StreamSubscription<dynamic>? userSub,
          final StreamSubscription<dynamic>? userCompanySub,
          final StreamSubscription<dynamic>? doctorSettingSub,
          required final DoctorSettingModel doctorSetting,
          required final List<UserCompanyModel> userCompanies,
          required final UserCompanyModel userCompanySelected}) =
      _$GlobalStateDataImpl;

  @override
  UserModel get myUser;
  @override
  StreamSubscription<dynamic>? get userSub;
  @override
  StreamSubscription<dynamic>? get userCompanySub;
  @override
  StreamSubscription<dynamic>? get doctorSettingSub;
  @override
  DoctorSettingModel get doctorSetting;
  @override
  List<UserCompanyModel> get userCompanies;
  @override
  UserCompanyModel get userCompanySelected;
  @override
  @JsonKey(ignore: true)
  _$$GlobalStateDataImplCopyWith<_$GlobalStateDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
