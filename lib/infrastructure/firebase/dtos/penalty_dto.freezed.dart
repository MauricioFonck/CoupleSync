// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'penalty_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PenaltyDto {

 String get id; String get title; String get description; String get severity; bool get active; String? get imageId;
/// Create a copy of PenaltyDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PenaltyDtoCopyWith<PenaltyDto> get copyWith => _$PenaltyDtoCopyWithImpl<PenaltyDto>(this as PenaltyDto, _$identity);

  /// Serializes this PenaltyDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PenaltyDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.active, active) || other.active == active)&&(identical(other.imageId, imageId) || other.imageId == imageId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,severity,active,imageId);

@override
String toString() {
  return 'PenaltyDto(id: $id, title: $title, description: $description, severity: $severity, active: $active, imageId: $imageId)';
}


}

/// @nodoc
abstract mixin class $PenaltyDtoCopyWith<$Res>  {
  factory $PenaltyDtoCopyWith(PenaltyDto value, $Res Function(PenaltyDto) _then) = _$PenaltyDtoCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, String severity, bool active, String? imageId
});




}
/// @nodoc
class _$PenaltyDtoCopyWithImpl<$Res>
    implements $PenaltyDtoCopyWith<$Res> {
  _$PenaltyDtoCopyWithImpl(this._self, this._then);

  final PenaltyDto _self;
  final $Res Function(PenaltyDto) _then;

/// Create a copy of PenaltyDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? severity = null,Object? active = null,Object? imageId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,imageId: freezed == imageId ? _self.imageId : imageId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PenaltyDto].
extension PenaltyDtoPatterns on PenaltyDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PenaltyDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PenaltyDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PenaltyDto value)  $default,){
final _that = this;
switch (_that) {
case _PenaltyDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PenaltyDto value)?  $default,){
final _that = this;
switch (_that) {
case _PenaltyDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  String severity,  bool active,  String? imageId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PenaltyDto() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.severity,_that.active,_that.imageId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  String severity,  bool active,  String? imageId)  $default,) {final _that = this;
switch (_that) {
case _PenaltyDto():
return $default(_that.id,_that.title,_that.description,_that.severity,_that.active,_that.imageId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  String severity,  bool active,  String? imageId)?  $default,) {final _that = this;
switch (_that) {
case _PenaltyDto() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.severity,_that.active,_that.imageId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PenaltyDto implements PenaltyDto {
  const _PenaltyDto({required this.id, required this.title, required this.description, required this.severity, required this.active, this.imageId});
  factory _PenaltyDto.fromJson(Map<String, dynamic> json) => _$PenaltyDtoFromJson(json);

@override final  String id;
@override final  String title;
@override final  String description;
@override final  String severity;
@override final  bool active;
@override final  String? imageId;

/// Create a copy of PenaltyDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PenaltyDtoCopyWith<_PenaltyDto> get copyWith => __$PenaltyDtoCopyWithImpl<_PenaltyDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PenaltyDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PenaltyDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.active, active) || other.active == active)&&(identical(other.imageId, imageId) || other.imageId == imageId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,severity,active,imageId);

@override
String toString() {
  return 'PenaltyDto(id: $id, title: $title, description: $description, severity: $severity, active: $active, imageId: $imageId)';
}


}

/// @nodoc
abstract mixin class _$PenaltyDtoCopyWith<$Res> implements $PenaltyDtoCopyWith<$Res> {
  factory _$PenaltyDtoCopyWith(_PenaltyDto value, $Res Function(_PenaltyDto) _then) = __$PenaltyDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, String severity, bool active, String? imageId
});




}
/// @nodoc
class __$PenaltyDtoCopyWithImpl<$Res>
    implements _$PenaltyDtoCopyWith<$Res> {
  __$PenaltyDtoCopyWithImpl(this._self, this._then);

  final _PenaltyDto _self;
  final $Res Function(_PenaltyDto) _then;

/// Create a copy of PenaltyDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? severity = null,Object? active = null,Object? imageId = freezed,}) {
  return _then(_PenaltyDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,imageId: freezed == imageId ? _self.imageId : imageId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
