// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'confirmation_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConfirmationDto {

 String get userId; String get activityId; String get status;
/// Create a copy of ConfirmationDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConfirmationDtoCopyWith<ConfirmationDto> get copyWith => _$ConfirmationDtoCopyWithImpl<ConfirmationDto>(this as ConfirmationDto, _$identity);

  /// Serializes this ConfirmationDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConfirmationDto&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.activityId, activityId) || other.activityId == activityId)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,activityId,status);

@override
String toString() {
  return 'ConfirmationDto(userId: $userId, activityId: $activityId, status: $status)';
}


}

/// @nodoc
abstract mixin class $ConfirmationDtoCopyWith<$Res>  {
  factory $ConfirmationDtoCopyWith(ConfirmationDto value, $Res Function(ConfirmationDto) _then) = _$ConfirmationDtoCopyWithImpl;
@useResult
$Res call({
 String userId, String activityId, String status
});




}
/// @nodoc
class _$ConfirmationDtoCopyWithImpl<$Res>
    implements $ConfirmationDtoCopyWith<$Res> {
  _$ConfirmationDtoCopyWithImpl(this._self, this._then);

  final ConfirmationDto _self;
  final $Res Function(ConfirmationDto) _then;

/// Create a copy of ConfirmationDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? activityId = null,Object? status = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,activityId: null == activityId ? _self.activityId : activityId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ConfirmationDto].
extension ConfirmationDtoPatterns on ConfirmationDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConfirmationDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConfirmationDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConfirmationDto value)  $default,){
final _that = this;
switch (_that) {
case _ConfirmationDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConfirmationDto value)?  $default,){
final _that = this;
switch (_that) {
case _ConfirmationDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String activityId,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConfirmationDto() when $default != null:
return $default(_that.userId,_that.activityId,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String activityId,  String status)  $default,) {final _that = this;
switch (_that) {
case _ConfirmationDto():
return $default(_that.userId,_that.activityId,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String activityId,  String status)?  $default,) {final _that = this;
switch (_that) {
case _ConfirmationDto() when $default != null:
return $default(_that.userId,_that.activityId,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConfirmationDto implements ConfirmationDto {
  const _ConfirmationDto({required this.userId, required this.activityId, required this.status});
  factory _ConfirmationDto.fromJson(Map<String, dynamic> json) => _$ConfirmationDtoFromJson(json);

@override final  String userId;
@override final  String activityId;
@override final  String status;

/// Create a copy of ConfirmationDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConfirmationDtoCopyWith<_ConfirmationDto> get copyWith => __$ConfirmationDtoCopyWithImpl<_ConfirmationDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConfirmationDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConfirmationDto&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.activityId, activityId) || other.activityId == activityId)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,activityId,status);

@override
String toString() {
  return 'ConfirmationDto(userId: $userId, activityId: $activityId, status: $status)';
}


}

/// @nodoc
abstract mixin class _$ConfirmationDtoCopyWith<$Res> implements $ConfirmationDtoCopyWith<$Res> {
  factory _$ConfirmationDtoCopyWith(_ConfirmationDto value, $Res Function(_ConfirmationDto) _then) = __$ConfirmationDtoCopyWithImpl;
@override @useResult
$Res call({
 String userId, String activityId, String status
});




}
/// @nodoc
class __$ConfirmationDtoCopyWithImpl<$Res>
    implements _$ConfirmationDtoCopyWith<$Res> {
  __$ConfirmationDtoCopyWithImpl(this._self, this._then);

  final _ConfirmationDto _self;
  final $Res Function(_ConfirmationDto) _then;

/// Create a copy of ConfirmationDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? activityId = null,Object? status = null,}) {
  return _then(_ConfirmationDto(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,activityId: null == activityId ? _self.activityId : activityId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
