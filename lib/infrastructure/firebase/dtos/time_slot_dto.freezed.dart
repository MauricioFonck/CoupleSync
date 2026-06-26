// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'time_slot_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TimeSlotDto {

 int get startMinutes; int get endMinutes;
/// Create a copy of TimeSlotDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimeSlotDtoCopyWith<TimeSlotDto> get copyWith => _$TimeSlotDtoCopyWithImpl<TimeSlotDto>(this as TimeSlotDto, _$identity);

  /// Serializes this TimeSlotDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimeSlotDto&&(identical(other.startMinutes, startMinutes) || other.startMinutes == startMinutes)&&(identical(other.endMinutes, endMinutes) || other.endMinutes == endMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startMinutes,endMinutes);

@override
String toString() {
  return 'TimeSlotDto(startMinutes: $startMinutes, endMinutes: $endMinutes)';
}


}

/// @nodoc
abstract mixin class $TimeSlotDtoCopyWith<$Res>  {
  factory $TimeSlotDtoCopyWith(TimeSlotDto value, $Res Function(TimeSlotDto) _then) = _$TimeSlotDtoCopyWithImpl;
@useResult
$Res call({
 int startMinutes, int endMinutes
});




}
/// @nodoc
class _$TimeSlotDtoCopyWithImpl<$Res>
    implements $TimeSlotDtoCopyWith<$Res> {
  _$TimeSlotDtoCopyWithImpl(this._self, this._then);

  final TimeSlotDto _self;
  final $Res Function(TimeSlotDto) _then;

/// Create a copy of TimeSlotDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startMinutes = null,Object? endMinutes = null,}) {
  return _then(_self.copyWith(
startMinutes: null == startMinutes ? _self.startMinutes : startMinutes // ignore: cast_nullable_to_non_nullable
as int,endMinutes: null == endMinutes ? _self.endMinutes : endMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TimeSlotDto].
extension TimeSlotDtoPatterns on TimeSlotDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimeSlotDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimeSlotDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimeSlotDto value)  $default,){
final _that = this;
switch (_that) {
case _TimeSlotDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimeSlotDto value)?  $default,){
final _that = this;
switch (_that) {
case _TimeSlotDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int startMinutes,  int endMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimeSlotDto() when $default != null:
return $default(_that.startMinutes,_that.endMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int startMinutes,  int endMinutes)  $default,) {final _that = this;
switch (_that) {
case _TimeSlotDto():
return $default(_that.startMinutes,_that.endMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int startMinutes,  int endMinutes)?  $default,) {final _that = this;
switch (_that) {
case _TimeSlotDto() when $default != null:
return $default(_that.startMinutes,_that.endMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TimeSlotDto implements TimeSlotDto {
  const _TimeSlotDto({required this.startMinutes, required this.endMinutes});
  factory _TimeSlotDto.fromJson(Map<String, dynamic> json) => _$TimeSlotDtoFromJson(json);

@override final  int startMinutes;
@override final  int endMinutes;

/// Create a copy of TimeSlotDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimeSlotDtoCopyWith<_TimeSlotDto> get copyWith => __$TimeSlotDtoCopyWithImpl<_TimeSlotDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimeSlotDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimeSlotDto&&(identical(other.startMinutes, startMinutes) || other.startMinutes == startMinutes)&&(identical(other.endMinutes, endMinutes) || other.endMinutes == endMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startMinutes,endMinutes);

@override
String toString() {
  return 'TimeSlotDto(startMinutes: $startMinutes, endMinutes: $endMinutes)';
}


}

/// @nodoc
abstract mixin class _$TimeSlotDtoCopyWith<$Res> implements $TimeSlotDtoCopyWith<$Res> {
  factory _$TimeSlotDtoCopyWith(_TimeSlotDto value, $Res Function(_TimeSlotDto) _then) = __$TimeSlotDtoCopyWithImpl;
@override @useResult
$Res call({
 int startMinutes, int endMinutes
});




}
/// @nodoc
class __$TimeSlotDtoCopyWithImpl<$Res>
    implements _$TimeSlotDtoCopyWith<$Res> {
  __$TimeSlotDtoCopyWithImpl(this._self, this._then);

  final _TimeSlotDto _self;
  final $Res Function(_TimeSlotDto) _then;

/// Create a copy of TimeSlotDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startMinutes = null,Object? endMinutes = null,}) {
  return _then(_TimeSlotDto(
startMinutes: null == startMinutes ? _self.startMinutes : startMinutes // ignore: cast_nullable_to_non_nullable
as int,endMinutes: null == endMinutes ? _self.endMinutes : endMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
