// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ProfileState {
  UserModel get myUser => throw _privateConstructorUsedError;
  StreamSubscription<dynamic>? get userSub =>
      throw _privateConstructorUsedError;
  DoctorSettingModel get setting => throw _privateConstructorUsedError;
  List<DaysWeekEnum> get listDayWeek => throw _privateConstructorUsedError;
  int get consultationDurationMinutes => throw _privateConstructorUsedError;
  List<WorkTimeModel> get listTimeSlots => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ProfileStateCopyWith<ProfileState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileStateCopyWith<$Res> {
  factory $ProfileStateCopyWith(
          ProfileState value, $Res Function(ProfileState) then) =
      _$ProfileStateCopyWithImpl<$Res, ProfileState>;
  @useResult
  $Res call(
      {UserModel myUser,
      StreamSubscription<dynamic>? userSub,
      DoctorSettingModel setting,
      List<DaysWeekEnum> listDayWeek,
      int consultationDurationMinutes,
      List<WorkTimeModel> listTimeSlots});
}

/// @nodoc
class _$ProfileStateCopyWithImpl<$Res, $Val extends ProfileState>
    implements $ProfileStateCopyWith<$Res> {
  _$ProfileStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? myUser = null,
    Object? userSub = freezed,
    Object? setting = null,
    Object? listDayWeek = null,
    Object? consultationDurationMinutes = null,
    Object? listTimeSlots = null,
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
      setting: null == setting
          ? _value.setting
          : setting // ignore: cast_nullable_to_non_nullable
              as DoctorSettingModel,
      listDayWeek: null == listDayWeek
          ? _value.listDayWeek
          : listDayWeek // ignore: cast_nullable_to_non_nullable
              as List<DaysWeekEnum>,
      consultationDurationMinutes: null == consultationDurationMinutes
          ? _value.consultationDurationMinutes
          : consultationDurationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      listTimeSlots: null == listTimeSlots
          ? _value.listTimeSlots
          : listTimeSlots // ignore: cast_nullable_to_non_nullable
              as List<WorkTimeModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProfileStateDataImplCopyWith<$Res>
    implements $ProfileStateCopyWith<$Res> {
  factory _$$ProfileStateDataImplCopyWith(_$ProfileStateDataImpl value,
          $Res Function(_$ProfileStateDataImpl) then) =
      __$$ProfileStateDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {UserModel myUser,
      StreamSubscription<dynamic>? userSub,
      DoctorSettingModel setting,
      List<DaysWeekEnum> listDayWeek,
      int consultationDurationMinutes,
      List<WorkTimeModel> listTimeSlots});
}

/// @nodoc
class __$$ProfileStateDataImplCopyWithImpl<$Res>
    extends _$ProfileStateCopyWithImpl<$Res, _$ProfileStateDataImpl>
    implements _$$ProfileStateDataImplCopyWith<$Res> {
  __$$ProfileStateDataImplCopyWithImpl(_$ProfileStateDataImpl _value,
      $Res Function(_$ProfileStateDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? myUser = null,
    Object? userSub = freezed,
    Object? setting = null,
    Object? listDayWeek = null,
    Object? consultationDurationMinutes = null,
    Object? listTimeSlots = null,
  }) {
    return _then(_$ProfileStateDataImpl(
      myUser: null == myUser
          ? _value.myUser
          : myUser // ignore: cast_nullable_to_non_nullable
              as UserModel,
      userSub: freezed == userSub
          ? _value.userSub
          : userSub // ignore: cast_nullable_to_non_nullable
              as StreamSubscription<dynamic>?,
      setting: null == setting
          ? _value.setting
          : setting // ignore: cast_nullable_to_non_nullable
              as DoctorSettingModel,
      listDayWeek: null == listDayWeek
          ? _value._listDayWeek
          : listDayWeek // ignore: cast_nullable_to_non_nullable
              as List<DaysWeekEnum>,
      consultationDurationMinutes: null == consultationDurationMinutes
          ? _value.consultationDurationMinutes
          : consultationDurationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      listTimeSlots: null == listTimeSlots
          ? _value._listTimeSlots
          : listTimeSlots // ignore: cast_nullable_to_non_nullable
              as List<WorkTimeModel>,
    ));
  }
}

/// @nodoc

class _$ProfileStateDataImpl implements ProfileStateData {
  const _$ProfileStateDataImpl(
      {required this.myUser,
      this.userSub,
      required this.setting,
      required final List<DaysWeekEnum> listDayWeek,
      required this.consultationDurationMinutes,
      required final List<WorkTimeModel> listTimeSlots})
      : _listDayWeek = listDayWeek,
        _listTimeSlots = listTimeSlots;

  @override
  final UserModel myUser;
  @override
  final StreamSubscription<dynamic>? userSub;
  @override
  final DoctorSettingModel setting;
  final List<DaysWeekEnum> _listDayWeek;
  @override
  List<DaysWeekEnum> get listDayWeek {
    if (_listDayWeek is EqualUnmodifiableListView) return _listDayWeek;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_listDayWeek);
  }

  @override
  final int consultationDurationMinutes;
  final List<WorkTimeModel> _listTimeSlots;
  @override
  List<WorkTimeModel> get listTimeSlots {
    if (_listTimeSlots is EqualUnmodifiableListView) return _listTimeSlots;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_listTimeSlots);
  }

  @override
  String toString() {
    return 'ProfileState(myUser: $myUser, userSub: $userSub, setting: $setting, listDayWeek: $listDayWeek, consultationDurationMinutes: $consultationDurationMinutes, listTimeSlots: $listTimeSlots)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileStateDataImpl &&
            (identical(other.myUser, myUser) || other.myUser == myUser) &&
            (identical(other.userSub, userSub) || other.userSub == userSub) &&
            (identical(other.setting, setting) || other.setting == setting) &&
            const DeepCollectionEquality()
                .equals(other._listDayWeek, _listDayWeek) &&
            (identical(other.consultationDurationMinutes,
                    consultationDurationMinutes) ||
                other.consultationDurationMinutes ==
                    consultationDurationMinutes) &&
            const DeepCollectionEquality()
                .equals(other._listTimeSlots, _listTimeSlots));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      myUser,
      userSub,
      setting,
      const DeepCollectionEquality().hash(_listDayWeek),
      consultationDurationMinutes,
      const DeepCollectionEquality().hash(_listTimeSlots));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileStateDataImplCopyWith<_$ProfileStateDataImpl> get copyWith =>
      __$$ProfileStateDataImplCopyWithImpl<_$ProfileStateDataImpl>(
          this, _$identity);
}

abstract class ProfileStateData implements ProfileState {
  const factory ProfileStateData(
          {required final UserModel myUser,
          final StreamSubscription<dynamic>? userSub,
          required final DoctorSettingModel setting,
          required final List<DaysWeekEnum> listDayWeek,
          required final int consultationDurationMinutes,
          required final List<WorkTimeModel> listTimeSlots}) =
      _$ProfileStateDataImpl;

  @override
  UserModel get myUser;
  @override
  StreamSubscription<dynamic>? get userSub;
  @override
  DoctorSettingModel get setting;
  @override
  List<DaysWeekEnum> get listDayWeek;
  @override
  int get consultationDurationMinutes;
  @override
  List<WorkTimeModel> get listTimeSlots;
  @override
  @JsonKey(ignore: true)
  _$$ProfileStateDataImplCopyWith<_$ProfileStateDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
