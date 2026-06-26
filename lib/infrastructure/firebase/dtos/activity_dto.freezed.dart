// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActivityDto {

 String get id; String get title; String get description; String get category; String get createdBy; bool get active; String get createdAt; String get updatedAt; String? get imageId;
/// Create a copy of ActivityDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityDtoCopyWith<ActivityDto> get copyWith => _$ActivityDtoCopyWithImpl<ActivityDto>(this as ActivityDto, _$identity);

  /// Serializes this ActivityDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.active, active) || other.active == active)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.imageId, imageId) || other.imageId == imageId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,category,createdBy,active,createdAt,updatedAt,imageId);

@override
String toString() {
  return 'ActivityDto(id: $id, title: $title, description: $description, category: $category, createdBy: $createdBy, active: $active, createdAt: $createdAt, updatedAt: $updatedAt, imageId: $imageId)';
}


}

/// @nodoc
abstract mixin class $ActivityDtoCopyWith<$Res>  {
  factory $ActivityDtoCopyWith(ActivityDto value, $Res Function(ActivityDto) _then) = _$ActivityDtoCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, String category, String createdBy, bool active, String createdAt, String updatedAt, String? imageId
});




}
/// @nodoc
class _$ActivityDtoCopyWithImpl<$Res>
    implements $ActivityDtoCopyWith<$Res> {
  _$ActivityDtoCopyWithImpl(this._self, this._then);

  final ActivityDto _self;
  final $Res Function(ActivityDto) _then;

/// Create a copy of ActivityDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? category = null,Object? createdBy = null,Object? active = null,Object? createdAt = null,Object? updatedAt = null,Object? imageId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,imageId: freezed == imageId ? _self.imageId : imageId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivityDto].
extension ActivityDtoPatterns on ActivityDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityDto value)  $default,){
final _that = this;
switch (_that) {
case _ActivityDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityDto value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  String category,  String createdBy,  bool active,  String createdAt,  String updatedAt,  String? imageId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityDto() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.category,_that.createdBy,_that.active,_that.createdAt,_that.updatedAt,_that.imageId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  String category,  String createdBy,  bool active,  String createdAt,  String updatedAt,  String? imageId)  $default,) {final _that = this;
switch (_that) {
case _ActivityDto():
return $default(_that.id,_that.title,_that.description,_that.category,_that.createdBy,_that.active,_that.createdAt,_that.updatedAt,_that.imageId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  String category,  String createdBy,  bool active,  String createdAt,  String updatedAt,  String? imageId)?  $default,) {final _that = this;
switch (_that) {
case _ActivityDto() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.category,_that.createdBy,_that.active,_that.createdAt,_that.updatedAt,_that.imageId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivityDto implements ActivityDto {
  const _ActivityDto({required this.id, required this.title, required this.description, required this.category, required this.createdBy, required this.active, required this.createdAt, required this.updatedAt, this.imageId});
  factory _ActivityDto.fromJson(Map<String, dynamic> json) => _$ActivityDtoFromJson(json);

@override final  String id;
@override final  String title;
@override final  String description;
@override final  String category;
@override final  String createdBy;
@override final  bool active;
@override final  String createdAt;
@override final  String updatedAt;
@override final  String? imageId;

/// Create a copy of ActivityDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityDtoCopyWith<_ActivityDto> get copyWith => __$ActivityDtoCopyWithImpl<_ActivityDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivityDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.active, active) || other.active == active)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.imageId, imageId) || other.imageId == imageId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,category,createdBy,active,createdAt,updatedAt,imageId);

@override
String toString() {
  return 'ActivityDto(id: $id, title: $title, description: $description, category: $category, createdBy: $createdBy, active: $active, createdAt: $createdAt, updatedAt: $updatedAt, imageId: $imageId)';
}


}

/// @nodoc
abstract mixin class _$ActivityDtoCopyWith<$Res> implements $ActivityDtoCopyWith<$Res> {
  factory _$ActivityDtoCopyWith(_ActivityDto value, $Res Function(_ActivityDto) _then) = __$ActivityDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, String category, String createdBy, bool active, String createdAt, String updatedAt, String? imageId
});




}
/// @nodoc
class __$ActivityDtoCopyWithImpl<$Res>
    implements _$ActivityDtoCopyWith<$Res> {
  __$ActivityDtoCopyWithImpl(this._self, this._then);

  final _ActivityDto _self;
  final $Res Function(_ActivityDto) _then;

/// Create a copy of ActivityDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? category = null,Object? createdBy = null,Object? active = null,Object? createdAt = null,Object? updatedAt = null,Object? imageId = freezed,}) {
  return _then(_ActivityDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,imageId: freezed == imageId ? _self.imageId : imageId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
