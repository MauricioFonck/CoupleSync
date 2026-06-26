// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scheduling_config_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SchedulingConfigDto {

 int get daysPerWeek; int get activitiesPerDay;
/// Create a copy of SchedulingConfigDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SchedulingConfigDtoCopyWith<SchedulingConfigDto> get copyWith => _$SchedulingConfigDtoCopyWithImpl<SchedulingConfigDto>(this as SchedulingConfigDto, _$identity);

  /// Serializes this SchedulingConfigDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SchedulingConfigDto&&(identical(other.daysPerWeek, daysPerWeek) || other.daysPerWeek == daysPerWeek)&&(identical(other.activitiesPerDay, activitiesPerDay) || other.activitiesPerDay == activitiesPerDay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,daysPerWeek,activitiesPerDay);

@override
String toString() {
  return 'SchedulingConfigDto(daysPerWeek: $daysPerWeek, activitiesPerDay: $activitiesPerDay)';
}


}

/// @nodoc
abstract mixin class $SchedulingConfigDtoCopyWith<$Res>  {
  factory $SchedulingConfigDtoCopyWith(SchedulingConfigDto value, $Res Function(SchedulingConfigDto) _then) = _$SchedulingConfigDtoCopyWithImpl;
@useResult
$Res call({
 int daysPerWeek, int activitiesPerDay
});




}
/// @nodoc
class _$SchedulingConfigDtoCopyWithImpl<$Res>
    implements $SchedulingConfigDtoCopyWith<$Res> {
  _$SchedulingConfigDtoCopyWithImpl(this._self, this._then);

  final SchedulingConfigDto _self;
  final $Res Function(SchedulingConfigDto) _then;

/// Create a copy of SchedulingConfigDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? daysPerWeek = null,Object? activitiesPerDay = null,}) {
  return _then(_self.copyWith(
daysPerWeek: null == daysPerWeek ? _self.daysPerWeek : daysPerWeek // ignore: cast_nullable_to_non_nullable
as int,activitiesPerDay: null == activitiesPerDay ? _self.activitiesPerDay : activitiesPerDay // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SchedulingConfigDto].
extension SchedulingConfigDtoPatterns on SchedulingConfigDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SchedulingConfigDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SchedulingConfigDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SchedulingConfigDto value)  $default,){
final _that = this;
switch (_that) {
case _SchedulingConfigDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SchedulingConfigDto value)?  $default,){
final _that = this;
switch (_that) {
case _SchedulingConfigDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int daysPerWeek,  int activitiesPerDay)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SchedulingConfigDto() when $default != null:
return $default(_that.daysPerWeek,_that.activitiesPerDay);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int daysPerWeek,  int activitiesPerDay)  $default,) {final _that = this;
switch (_that) {
case _SchedulingConfigDto():
return $default(_that.daysPerWeek,_that.activitiesPerDay);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int daysPerWeek,  int activitiesPerDay)?  $default,) {final _that = this;
switch (_that) {
case _SchedulingConfigDto() when $default != null:
return $default(_that.daysPerWeek,_that.activitiesPerDay);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SchedulingConfigDto implements SchedulingConfigDto {
  const _SchedulingConfigDto({required this.daysPerWeek, required this.activitiesPerDay});
  factory _SchedulingConfigDto.fromJson(Map<String, dynamic> json) => _$SchedulingConfigDtoFromJson(json);

@override final  int daysPerWeek;
@override final  int activitiesPerDay;

/// Create a copy of SchedulingConfigDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SchedulingConfigDtoCopyWith<_SchedulingConfigDto> get copyWith => __$SchedulingConfigDtoCopyWithImpl<_SchedulingConfigDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SchedulingConfigDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SchedulingConfigDto&&(identical(other.daysPerWeek, daysPerWeek) || other.daysPerWeek == daysPerWeek)&&(identical(other.activitiesPerDay, activitiesPerDay) || other.activitiesPerDay == activitiesPerDay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,daysPerWeek,activitiesPerDay);

@override
String toString() {
  return 'SchedulingConfigDto(daysPerWeek: $daysPerWeek, activitiesPerDay: $activitiesPerDay)';
}


}

/// @nodoc
abstract mixin class _$SchedulingConfigDtoCopyWith<$Res> implements $SchedulingConfigDtoCopyWith<$Res> {
  factory _$SchedulingConfigDtoCopyWith(_SchedulingConfigDto value, $Res Function(_SchedulingConfigDto) _then) = __$SchedulingConfigDtoCopyWithImpl;
@override @useResult
$Res call({
 int daysPerWeek, int activitiesPerDay
});




}
/// @nodoc
class __$SchedulingConfigDtoCopyWithImpl<$Res>
    implements _$SchedulingConfigDtoCopyWith<$Res> {
  __$SchedulingConfigDtoCopyWithImpl(this._self, this._then);

  final _SchedulingConfigDto _self;
  final $Res Function(_SchedulingConfigDto) _then;

/// Create a copy of SchedulingConfigDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? daysPerWeek = null,Object? activitiesPerDay = null,}) {
  return _then(_SchedulingConfigDto(
daysPerWeek: null == daysPerWeek ? _self.daysPerWeek : daysPerWeek // ignore: cast_nullable_to_non_nullable
as int,activitiesPerDay: null == activitiesPerDay ? _self.activitiesPerDay : activitiesPerDay // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
