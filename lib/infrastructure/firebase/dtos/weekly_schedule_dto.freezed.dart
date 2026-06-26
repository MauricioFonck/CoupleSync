// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weekly_schedule_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WeeklyScheduleDto {

 String get weekId; List<String> get eventIds; String get generatedAt;
/// Create a copy of WeeklyScheduleDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeeklyScheduleDtoCopyWith<WeeklyScheduleDto> get copyWith => _$WeeklyScheduleDtoCopyWithImpl<WeeklyScheduleDto>(this as WeeklyScheduleDto, _$identity);

  /// Serializes this WeeklyScheduleDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeeklyScheduleDto&&(identical(other.weekId, weekId) || other.weekId == weekId)&&const DeepCollectionEquality().equals(other.eventIds, eventIds)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,weekId,const DeepCollectionEquality().hash(eventIds),generatedAt);

@override
String toString() {
  return 'WeeklyScheduleDto(weekId: $weekId, eventIds: $eventIds, generatedAt: $generatedAt)';
}


}

/// @nodoc
abstract mixin class $WeeklyScheduleDtoCopyWith<$Res>  {
  factory $WeeklyScheduleDtoCopyWith(WeeklyScheduleDto value, $Res Function(WeeklyScheduleDto) _then) = _$WeeklyScheduleDtoCopyWithImpl;
@useResult
$Res call({
 String weekId, List<String> eventIds, String generatedAt
});




}
/// @nodoc
class _$WeeklyScheduleDtoCopyWithImpl<$Res>
    implements $WeeklyScheduleDtoCopyWith<$Res> {
  _$WeeklyScheduleDtoCopyWithImpl(this._self, this._then);

  final WeeklyScheduleDto _self;
  final $Res Function(WeeklyScheduleDto) _then;

/// Create a copy of WeeklyScheduleDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weekId = null,Object? eventIds = null,Object? generatedAt = null,}) {
  return _then(_self.copyWith(
weekId: null == weekId ? _self.weekId : weekId // ignore: cast_nullable_to_non_nullable
as String,eventIds: null == eventIds ? _self.eventIds : eventIds // ignore: cast_nullable_to_non_nullable
as List<String>,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [WeeklyScheduleDto].
extension WeeklyScheduleDtoPatterns on WeeklyScheduleDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeeklyScheduleDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeeklyScheduleDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeeklyScheduleDto value)  $default,){
final _that = this;
switch (_that) {
case _WeeklyScheduleDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeeklyScheduleDto value)?  $default,){
final _that = this;
switch (_that) {
case _WeeklyScheduleDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String weekId,  List<String> eventIds,  String generatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeeklyScheduleDto() when $default != null:
return $default(_that.weekId,_that.eventIds,_that.generatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String weekId,  List<String> eventIds,  String generatedAt)  $default,) {final _that = this;
switch (_that) {
case _WeeklyScheduleDto():
return $default(_that.weekId,_that.eventIds,_that.generatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String weekId,  List<String> eventIds,  String generatedAt)?  $default,) {final _that = this;
switch (_that) {
case _WeeklyScheduleDto() when $default != null:
return $default(_that.weekId,_that.eventIds,_that.generatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeeklyScheduleDto implements WeeklyScheduleDto {
  const _WeeklyScheduleDto({required this.weekId, required final  List<String> eventIds, required this.generatedAt}): _eventIds = eventIds;
  factory _WeeklyScheduleDto.fromJson(Map<String, dynamic> json) => _$WeeklyScheduleDtoFromJson(json);

@override final  String weekId;
 final  List<String> _eventIds;
@override List<String> get eventIds {
  if (_eventIds is EqualUnmodifiableListView) return _eventIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_eventIds);
}

@override final  String generatedAt;

/// Create a copy of WeeklyScheduleDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeeklyScheduleDtoCopyWith<_WeeklyScheduleDto> get copyWith => __$WeeklyScheduleDtoCopyWithImpl<_WeeklyScheduleDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeeklyScheduleDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeeklyScheduleDto&&(identical(other.weekId, weekId) || other.weekId == weekId)&&const DeepCollectionEquality().equals(other._eventIds, _eventIds)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,weekId,const DeepCollectionEquality().hash(_eventIds),generatedAt);

@override
String toString() {
  return 'WeeklyScheduleDto(weekId: $weekId, eventIds: $eventIds, generatedAt: $generatedAt)';
}


}

/// @nodoc
abstract mixin class _$WeeklyScheduleDtoCopyWith<$Res> implements $WeeklyScheduleDtoCopyWith<$Res> {
  factory _$WeeklyScheduleDtoCopyWith(_WeeklyScheduleDto value, $Res Function(_WeeklyScheduleDto) _then) = __$WeeklyScheduleDtoCopyWithImpl;
@override @useResult
$Res call({
 String weekId, List<String> eventIds, String generatedAt
});




}
/// @nodoc
class __$WeeklyScheduleDtoCopyWithImpl<$Res>
    implements _$WeeklyScheduleDtoCopyWith<$Res> {
  __$WeeklyScheduleDtoCopyWithImpl(this._self, this._then);

  final _WeeklyScheduleDto _self;
  final $Res Function(_WeeklyScheduleDto) _then;

/// Create a copy of WeeklyScheduleDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weekId = null,Object? eventIds = null,Object? generatedAt = null,}) {
  return _then(_WeeklyScheduleDto(
weekId: null == weekId ? _self.weekId : weekId // ignore: cast_nullable_to_non_nullable
as String,eventIds: null == eventIds ? _self._eventIds : eventIds // ignore: cast_nullable_to_non_nullable
as List<String>,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
