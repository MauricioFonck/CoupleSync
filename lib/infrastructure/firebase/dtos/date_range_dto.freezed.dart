// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'date_range_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DateRangeDto {

 String get start; String get end;
/// Create a copy of DateRangeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DateRangeDtoCopyWith<DateRangeDto> get copyWith => _$DateRangeDtoCopyWithImpl<DateRangeDto>(this as DateRangeDto, _$identity);

  /// Serializes this DateRangeDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DateRangeDto&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,start,end);

@override
String toString() {
  return 'DateRangeDto(start: $start, end: $end)';
}


}

/// @nodoc
abstract mixin class $DateRangeDtoCopyWith<$Res>  {
  factory $DateRangeDtoCopyWith(DateRangeDto value, $Res Function(DateRangeDto) _then) = _$DateRangeDtoCopyWithImpl;
@useResult
$Res call({
 String start, String end
});




}
/// @nodoc
class _$DateRangeDtoCopyWithImpl<$Res>
    implements $DateRangeDtoCopyWith<$Res> {
  _$DateRangeDtoCopyWithImpl(this._self, this._then);

  final DateRangeDto _self;
  final $Res Function(DateRangeDto) _then;

/// Create a copy of DateRangeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? start = null,Object? end = null,}) {
  return _then(_self.copyWith(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as String,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DateRangeDto].
extension DateRangeDtoPatterns on DateRangeDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DateRangeDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DateRangeDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DateRangeDto value)  $default,){
final _that = this;
switch (_that) {
case _DateRangeDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DateRangeDto value)?  $default,){
final _that = this;
switch (_that) {
case _DateRangeDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String start,  String end)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DateRangeDto() when $default != null:
return $default(_that.start,_that.end);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String start,  String end)  $default,) {final _that = this;
switch (_that) {
case _DateRangeDto():
return $default(_that.start,_that.end);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String start,  String end)?  $default,) {final _that = this;
switch (_that) {
case _DateRangeDto() when $default != null:
return $default(_that.start,_that.end);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DateRangeDto implements DateRangeDto {
  const _DateRangeDto({required this.start, required this.end});
  factory _DateRangeDto.fromJson(Map<String, dynamic> json) => _$DateRangeDtoFromJson(json);

@override final  String start;
@override final  String end;

/// Create a copy of DateRangeDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DateRangeDtoCopyWith<_DateRangeDto> get copyWith => __$DateRangeDtoCopyWithImpl<_DateRangeDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DateRangeDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DateRangeDto&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,start,end);

@override
String toString() {
  return 'DateRangeDto(start: $start, end: $end)';
}


}

/// @nodoc
abstract mixin class _$DateRangeDtoCopyWith<$Res> implements $DateRangeDtoCopyWith<$Res> {
  factory _$DateRangeDtoCopyWith(_DateRangeDto value, $Res Function(_DateRangeDto) _then) = __$DateRangeDtoCopyWithImpl;
@override @useResult
$Res call({
 String start, String end
});




}
/// @nodoc
class __$DateRangeDtoCopyWithImpl<$Res>
    implements _$DateRangeDtoCopyWith<$Res> {
  __$DateRangeDtoCopyWithImpl(this._self, this._then);

  final _DateRangeDto _self;
  final $Res Function(_DateRangeDto) _then;

/// Create a copy of DateRangeDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? start = null,Object? end = null,}) {
  return _then(_DateRangeDto(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as String,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
