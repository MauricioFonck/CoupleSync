// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_blob_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MediaBlobDto {

 String get id; String get base64; String get mime; int get width; int get height; int get byteSize; String get createdBy; String get createdAt;
/// Create a copy of MediaBlobDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaBlobDtoCopyWith<MediaBlobDto> get copyWith => _$MediaBlobDtoCopyWithImpl<MediaBlobDto>(this as MediaBlobDto, _$identity);

  /// Serializes this MediaBlobDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaBlobDto&&(identical(other.id, id) || other.id == id)&&(identical(other.base64, base64) || other.base64 == base64)&&(identical(other.mime, mime) || other.mime == mime)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.byteSize, byteSize) || other.byteSize == byteSize)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,base64,mime,width,height,byteSize,createdBy,createdAt);

@override
String toString() {
  return 'MediaBlobDto(id: $id, base64: $base64, mime: $mime, width: $width, height: $height, byteSize: $byteSize, createdBy: $createdBy, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $MediaBlobDtoCopyWith<$Res>  {
  factory $MediaBlobDtoCopyWith(MediaBlobDto value, $Res Function(MediaBlobDto) _then) = _$MediaBlobDtoCopyWithImpl;
@useResult
$Res call({
 String id, String base64, String mime, int width, int height, int byteSize, String createdBy, String createdAt
});




}
/// @nodoc
class _$MediaBlobDtoCopyWithImpl<$Res>
    implements $MediaBlobDtoCopyWith<$Res> {
  _$MediaBlobDtoCopyWithImpl(this._self, this._then);

  final MediaBlobDto _self;
  final $Res Function(MediaBlobDto) _then;

/// Create a copy of MediaBlobDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? base64 = null,Object? mime = null,Object? width = null,Object? height = null,Object? byteSize = null,Object? createdBy = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,base64: null == base64 ? _self.base64 : base64 // ignore: cast_nullable_to_non_nullable
as String,mime: null == mime ? _self.mime : mime // ignore: cast_nullable_to_non_nullable
as String,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,byteSize: null == byteSize ? _self.byteSize : byteSize // ignore: cast_nullable_to_non_nullable
as int,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MediaBlobDto].
extension MediaBlobDtoPatterns on MediaBlobDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaBlobDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaBlobDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaBlobDto value)  $default,){
final _that = this;
switch (_that) {
case _MediaBlobDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaBlobDto value)?  $default,){
final _that = this;
switch (_that) {
case _MediaBlobDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String base64,  String mime,  int width,  int height,  int byteSize,  String createdBy,  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MediaBlobDto() when $default != null:
return $default(_that.id,_that.base64,_that.mime,_that.width,_that.height,_that.byteSize,_that.createdBy,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String base64,  String mime,  int width,  int height,  int byteSize,  String createdBy,  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _MediaBlobDto():
return $default(_that.id,_that.base64,_that.mime,_that.width,_that.height,_that.byteSize,_that.createdBy,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String base64,  String mime,  int width,  int height,  int byteSize,  String createdBy,  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _MediaBlobDto() when $default != null:
return $default(_that.id,_that.base64,_that.mime,_that.width,_that.height,_that.byteSize,_that.createdBy,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MediaBlobDto implements MediaBlobDto {
  const _MediaBlobDto({required this.id, required this.base64, required this.mime, required this.width, required this.height, required this.byteSize, required this.createdBy, required this.createdAt});
  factory _MediaBlobDto.fromJson(Map<String, dynamic> json) => _$MediaBlobDtoFromJson(json);

@override final  String id;
@override final  String base64;
@override final  String mime;
@override final  int width;
@override final  int height;
@override final  int byteSize;
@override final  String createdBy;
@override final  String createdAt;

/// Create a copy of MediaBlobDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaBlobDtoCopyWith<_MediaBlobDto> get copyWith => __$MediaBlobDtoCopyWithImpl<_MediaBlobDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MediaBlobDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaBlobDto&&(identical(other.id, id) || other.id == id)&&(identical(other.base64, base64) || other.base64 == base64)&&(identical(other.mime, mime) || other.mime == mime)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.byteSize, byteSize) || other.byteSize == byteSize)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,base64,mime,width,height,byteSize,createdBy,createdAt);

@override
String toString() {
  return 'MediaBlobDto(id: $id, base64: $base64, mime: $mime, width: $width, height: $height, byteSize: $byteSize, createdBy: $createdBy, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$MediaBlobDtoCopyWith<$Res> implements $MediaBlobDtoCopyWith<$Res> {
  factory _$MediaBlobDtoCopyWith(_MediaBlobDto value, $Res Function(_MediaBlobDto) _then) = __$MediaBlobDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String base64, String mime, int width, int height, int byteSize, String createdBy, String createdAt
});




}
/// @nodoc
class __$MediaBlobDtoCopyWithImpl<$Res>
    implements _$MediaBlobDtoCopyWith<$Res> {
  __$MediaBlobDtoCopyWithImpl(this._self, this._then);

  final _MediaBlobDto _self;
  final $Res Function(_MediaBlobDto) _then;

/// Create a copy of MediaBlobDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? base64 = null,Object? mime = null,Object? width = null,Object? height = null,Object? byteSize = null,Object? createdBy = null,Object? createdAt = null,}) {
  return _then(_MediaBlobDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,base64: null == base64 ? _self.base64 : base64 // ignore: cast_nullable_to_non_nullable
as String,mime: null == mime ? _self.mime : mime // ignore: cast_nullable_to_non_nullable
as String,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,byteSize: null == byteSize ? _self.byteSize : byteSize // ignore: cast_nullable_to_non_nullable
as int,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
