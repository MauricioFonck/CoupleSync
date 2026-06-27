// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'roulette_item_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RouletteItemDto {

 String get id; String get text; bool get favorite;
/// Create a copy of RouletteItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouletteItemDtoCopyWith<RouletteItemDto> get copyWith => _$RouletteItemDtoCopyWithImpl<RouletteItemDto>(this as RouletteItemDto, _$identity);

  /// Serializes this RouletteItemDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouletteItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.favorite, favorite) || other.favorite == favorite));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,favorite);

@override
String toString() {
  return 'RouletteItemDto(id: $id, text: $text, favorite: $favorite)';
}


}

/// @nodoc
abstract mixin class $RouletteItemDtoCopyWith<$Res>  {
  factory $RouletteItemDtoCopyWith(RouletteItemDto value, $Res Function(RouletteItemDto) _then) = _$RouletteItemDtoCopyWithImpl;
@useResult
$Res call({
 String id, String text, bool favorite
});




}
/// @nodoc
class _$RouletteItemDtoCopyWithImpl<$Res>
    implements $RouletteItemDtoCopyWith<$Res> {
  _$RouletteItemDtoCopyWithImpl(this._self, this._then);

  final RouletteItemDto _self;
  final $Res Function(RouletteItemDto) _then;

/// Create a copy of RouletteItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? text = null,Object? favorite = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,favorite: null == favorite ? _self.favorite : favorite // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RouletteItemDto].
extension RouletteItemDtoPatterns on RouletteItemDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouletteItemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouletteItemDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouletteItemDto value)  $default,){
final _that = this;
switch (_that) {
case _RouletteItemDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouletteItemDto value)?  $default,){
final _that = this;
switch (_that) {
case _RouletteItemDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String text,  bool favorite)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouletteItemDto() when $default != null:
return $default(_that.id,_that.text,_that.favorite);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String text,  bool favorite)  $default,) {final _that = this;
switch (_that) {
case _RouletteItemDto():
return $default(_that.id,_that.text,_that.favorite);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String text,  bool favorite)?  $default,) {final _that = this;
switch (_that) {
case _RouletteItemDto() when $default != null:
return $default(_that.id,_that.text,_that.favorite);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RouletteItemDto implements RouletteItemDto {
  const _RouletteItemDto({required this.id, required this.text, required this.favorite});
  factory _RouletteItemDto.fromJson(Map<String, dynamic> json) => _$RouletteItemDtoFromJson(json);

@override final  String id;
@override final  String text;
@override final  bool favorite;

/// Create a copy of RouletteItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouletteItemDtoCopyWith<_RouletteItemDto> get copyWith => __$RouletteItemDtoCopyWithImpl<_RouletteItemDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RouletteItemDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouletteItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.favorite, favorite) || other.favorite == favorite));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,favorite);

@override
String toString() {
  return 'RouletteItemDto(id: $id, text: $text, favorite: $favorite)';
}


}

/// @nodoc
abstract mixin class _$RouletteItemDtoCopyWith<$Res> implements $RouletteItemDtoCopyWith<$Res> {
  factory _$RouletteItemDtoCopyWith(_RouletteItemDto value, $Res Function(_RouletteItemDto) _then) = __$RouletteItemDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String text, bool favorite
});




}
/// @nodoc
class __$RouletteItemDtoCopyWithImpl<$Res>
    implements _$RouletteItemDtoCopyWith<$Res> {
  __$RouletteItemDtoCopyWithImpl(this._self, this._then);

  final _RouletteItemDto _self;
  final $Res Function(_RouletteItemDto) _then;

/// Create a copy of RouletteItemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? text = null,Object? favorite = null,}) {
  return _then(_RouletteItemDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,favorite: null == favorite ? _self.favorite : favorite // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
