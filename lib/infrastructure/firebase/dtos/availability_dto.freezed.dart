// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'availability_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AvailabilityDto {

 String get userId; List<int> get availableWeekdays; Map<String, List<TimeSlotDto>> get slotsByWeekday; List<String> get blockedDates; List<DateRangeDto> get unavailablePeriods;
/// Create a copy of AvailabilityDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AvailabilityDtoCopyWith<AvailabilityDto> get copyWith => _$AvailabilityDtoCopyWithImpl<AvailabilityDto>(this as AvailabilityDto, _$identity);

  /// Serializes this AvailabilityDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AvailabilityDto&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other.availableWeekdays, availableWeekdays)&&const DeepCollectionEquality().equals(other.slotsByWeekday, slotsByWeekday)&&const DeepCollectionEquality().equals(other.blockedDates, blockedDates)&&const DeepCollectionEquality().equals(other.unavailablePeriods, unavailablePeriods));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,const DeepCollectionEquality().hash(availableWeekdays),const DeepCollectionEquality().hash(slotsByWeekday),const DeepCollectionEquality().hash(blockedDates),const DeepCollectionEquality().hash(unavailablePeriods));

@override
String toString() {
  return 'AvailabilityDto(userId: $userId, availableWeekdays: $availableWeekdays, slotsByWeekday: $slotsByWeekday, blockedDates: $blockedDates, unavailablePeriods: $unavailablePeriods)';
}


}

/// @nodoc
abstract mixin class $AvailabilityDtoCopyWith<$Res>  {
  factory $AvailabilityDtoCopyWith(AvailabilityDto value, $Res Function(AvailabilityDto) _then) = _$AvailabilityDtoCopyWithImpl;
@useResult
$Res call({
 String userId, List<int> availableWeekdays, Map<String, List<TimeSlotDto>> slotsByWeekday, List<String> blockedDates, List<DateRangeDto> unavailablePeriods
});




}
/// @nodoc
class _$AvailabilityDtoCopyWithImpl<$Res>
    implements $AvailabilityDtoCopyWith<$Res> {
  _$AvailabilityDtoCopyWithImpl(this._self, this._then);

  final AvailabilityDto _self;
  final $Res Function(AvailabilityDto) _then;

/// Create a copy of AvailabilityDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? availableWeekdays = null,Object? slotsByWeekday = null,Object? blockedDates = null,Object? unavailablePeriods = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,availableWeekdays: null == availableWeekdays ? _self.availableWeekdays : availableWeekdays // ignore: cast_nullable_to_non_nullable
as List<int>,slotsByWeekday: null == slotsByWeekday ? _self.slotsByWeekday : slotsByWeekday // ignore: cast_nullable_to_non_nullable
as Map<String, List<TimeSlotDto>>,blockedDates: null == blockedDates ? _self.blockedDates : blockedDates // ignore: cast_nullable_to_non_nullable
as List<String>,unavailablePeriods: null == unavailablePeriods ? _self.unavailablePeriods : unavailablePeriods // ignore: cast_nullable_to_non_nullable
as List<DateRangeDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [AvailabilityDto].
extension AvailabilityDtoPatterns on AvailabilityDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AvailabilityDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AvailabilityDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AvailabilityDto value)  $default,){
final _that = this;
switch (_that) {
case _AvailabilityDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AvailabilityDto value)?  $default,){
final _that = this;
switch (_that) {
case _AvailabilityDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  List<int> availableWeekdays,  Map<String, List<TimeSlotDto>> slotsByWeekday,  List<String> blockedDates,  List<DateRangeDto> unavailablePeriods)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AvailabilityDto() when $default != null:
return $default(_that.userId,_that.availableWeekdays,_that.slotsByWeekday,_that.blockedDates,_that.unavailablePeriods);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  List<int> availableWeekdays,  Map<String, List<TimeSlotDto>> slotsByWeekday,  List<String> blockedDates,  List<DateRangeDto> unavailablePeriods)  $default,) {final _that = this;
switch (_that) {
case _AvailabilityDto():
return $default(_that.userId,_that.availableWeekdays,_that.slotsByWeekday,_that.blockedDates,_that.unavailablePeriods);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  List<int> availableWeekdays,  Map<String, List<TimeSlotDto>> slotsByWeekday,  List<String> blockedDates,  List<DateRangeDto> unavailablePeriods)?  $default,) {final _that = this;
switch (_that) {
case _AvailabilityDto() when $default != null:
return $default(_that.userId,_that.availableWeekdays,_that.slotsByWeekday,_that.blockedDates,_that.unavailablePeriods);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AvailabilityDto implements AvailabilityDto {
  const _AvailabilityDto({required this.userId, required final  List<int> availableWeekdays, required final  Map<String, List<TimeSlotDto>> slotsByWeekday, required final  List<String> blockedDates, required final  List<DateRangeDto> unavailablePeriods}): _availableWeekdays = availableWeekdays,_slotsByWeekday = slotsByWeekday,_blockedDates = blockedDates,_unavailablePeriods = unavailablePeriods;
  factory _AvailabilityDto.fromJson(Map<String, dynamic> json) => _$AvailabilityDtoFromJson(json);

@override final  String userId;
 final  List<int> _availableWeekdays;
@override List<int> get availableWeekdays {
  if (_availableWeekdays is EqualUnmodifiableListView) return _availableWeekdays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableWeekdays);
}

 final  Map<String, List<TimeSlotDto>> _slotsByWeekday;
@override Map<String, List<TimeSlotDto>> get slotsByWeekday {
  if (_slotsByWeekday is EqualUnmodifiableMapView) return _slotsByWeekday;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_slotsByWeekday);
}

 final  List<String> _blockedDates;
@override List<String> get blockedDates {
  if (_blockedDates is EqualUnmodifiableListView) return _blockedDates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_blockedDates);
}

 final  List<DateRangeDto> _unavailablePeriods;
@override List<DateRangeDto> get unavailablePeriods {
  if (_unavailablePeriods is EqualUnmodifiableListView) return _unavailablePeriods;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_unavailablePeriods);
}


/// Create a copy of AvailabilityDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AvailabilityDtoCopyWith<_AvailabilityDto> get copyWith => __$AvailabilityDtoCopyWithImpl<_AvailabilityDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AvailabilityDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AvailabilityDto&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other._availableWeekdays, _availableWeekdays)&&const DeepCollectionEquality().equals(other._slotsByWeekday, _slotsByWeekday)&&const DeepCollectionEquality().equals(other._blockedDates, _blockedDates)&&const DeepCollectionEquality().equals(other._unavailablePeriods, _unavailablePeriods));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,const DeepCollectionEquality().hash(_availableWeekdays),const DeepCollectionEquality().hash(_slotsByWeekday),const DeepCollectionEquality().hash(_blockedDates),const DeepCollectionEquality().hash(_unavailablePeriods));

@override
String toString() {
  return 'AvailabilityDto(userId: $userId, availableWeekdays: $availableWeekdays, slotsByWeekday: $slotsByWeekday, blockedDates: $blockedDates, unavailablePeriods: $unavailablePeriods)';
}


}

/// @nodoc
abstract mixin class _$AvailabilityDtoCopyWith<$Res> implements $AvailabilityDtoCopyWith<$Res> {
  factory _$AvailabilityDtoCopyWith(_AvailabilityDto value, $Res Function(_AvailabilityDto) _then) = __$AvailabilityDtoCopyWithImpl;
@override @useResult
$Res call({
 String userId, List<int> availableWeekdays, Map<String, List<TimeSlotDto>> slotsByWeekday, List<String> blockedDates, List<DateRangeDto> unavailablePeriods
});




}
/// @nodoc
class __$AvailabilityDtoCopyWithImpl<$Res>
    implements _$AvailabilityDtoCopyWith<$Res> {
  __$AvailabilityDtoCopyWithImpl(this._self, this._then);

  final _AvailabilityDto _self;
  final $Res Function(_AvailabilityDto) _then;

/// Create a copy of AvailabilityDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? availableWeekdays = null,Object? slotsByWeekday = null,Object? blockedDates = null,Object? unavailablePeriods = null,}) {
  return _then(_AvailabilityDto(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,availableWeekdays: null == availableWeekdays ? _self._availableWeekdays : availableWeekdays // ignore: cast_nullable_to_non_nullable
as List<int>,slotsByWeekday: null == slotsByWeekday ? _self._slotsByWeekday : slotsByWeekday // ignore: cast_nullable_to_non_nullable
as Map<String, List<TimeSlotDto>>,blockedDates: null == blockedDates ? _self._blockedDates : blockedDates // ignore: cast_nullable_to_non_nullable
as List<String>,unavailablePeriods: null == unavailablePeriods ? _self._unavailablePeriods : unavailablePeriods // ignore: cast_nullable_to_non_nullable
as List<DateRangeDto>,
  ));
}


}

// dart format on
