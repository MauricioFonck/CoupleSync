// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'roulette_spin_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RouletteSpinDto {

 String get id; String get itemId; String get text; String get level; String get createdAt; bool get done;
/// Create a copy of RouletteSpinDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouletteSpinDtoCopyWith<RouletteSpinDto> get copyWith => _$RouletteSpinDtoCopyWithImpl<RouletteSpinDto>(this as RouletteSpinDto, _$identity);

  /// Serializes this RouletteSpinDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouletteSpinDto&&(identical(other.id, id) || other.id == id)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.text, text) || other.text == text)&&(identical(other.level, level) || other.level == level)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.done, done) || other.done == done));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,itemId,text,level,createdAt,done);

@override
String toString() {
  return 'RouletteSpinDto(id: $id, itemId: $itemId, text: $text, level: $level, createdAt: $createdAt, done: $done)';
}


}

/// @nodoc
abstract mixin class $RouletteSpinDtoCopyWith<$Res>  {
  factory $RouletteSpinDtoCopyWith(RouletteSpinDto value, $Res Function(RouletteSpinDto) _then) = _$RouletteSpinDtoCopyWithImpl;
@useResult
$Res call({
 String id, String itemId, String text, String level, String createdAt, bool done
});




}
/// @nodoc
class _$RouletteSpinDtoCopyWithImpl<$Res>
    implements $RouletteSpinDtoCopyWith<$Res> {
  _$RouletteSpinDtoCopyWithImpl(this._self, this._then);

  final RouletteSpinDto _self;
  final $Res Function(RouletteSpinDto) _then;

/// Create a copy of RouletteSpinDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? itemId = null,Object? text = null,Object? level = null,Object? createdAt = null,Object? done = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RouletteSpinDto].
extension RouletteSpinDtoPatterns on RouletteSpinDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouletteSpinDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouletteSpinDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouletteSpinDto value)  $default,){
final _that = this;
switch (_that) {
case _RouletteSpinDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouletteSpinDto value)?  $default,){
final _that = this;
switch (_that) {
case _RouletteSpinDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String itemId,  String text,  String level,  String createdAt,  bool done)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouletteSpinDto() when $default != null:
return $default(_that.id,_that.itemId,_that.text,_that.level,_that.createdAt,_that.done);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String itemId,  String text,  String level,  String createdAt,  bool done)  $default,) {final _that = this;
switch (_that) {
case _RouletteSpinDto():
return $default(_that.id,_that.itemId,_that.text,_that.level,_that.createdAt,_that.done);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String itemId,  String text,  String level,  String createdAt,  bool done)?  $default,) {final _that = this;
switch (_that) {
case _RouletteSpinDto() when $default != null:
return $default(_that.id,_that.itemId,_that.text,_that.level,_that.createdAt,_that.done);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RouletteSpinDto implements RouletteSpinDto {
  const _RouletteSpinDto({required this.id, required this.itemId, required this.text, required this.level, required this.createdAt, required this.done});
  factory _RouletteSpinDto.fromJson(Map<String, dynamic> json) => _$RouletteSpinDtoFromJson(json);

@override final  String id;
@override final  String itemId;
@override final  String text;
@override final  String level;
@override final  String createdAt;
@override final  bool done;

/// Create a copy of RouletteSpinDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouletteSpinDtoCopyWith<_RouletteSpinDto> get copyWith => __$RouletteSpinDtoCopyWithImpl<_RouletteSpinDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RouletteSpinDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouletteSpinDto&&(identical(other.id, id) || other.id == id)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.text, text) || other.text == text)&&(identical(other.level, level) || other.level == level)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.done, done) || other.done == done));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,itemId,text,level,createdAt,done);

@override
String toString() {
  return 'RouletteSpinDto(id: $id, itemId: $itemId, text: $text, level: $level, createdAt: $createdAt, done: $done)';
}


}

/// @nodoc
abstract mixin class _$RouletteSpinDtoCopyWith<$Res> implements $RouletteSpinDtoCopyWith<$Res> {
  factory _$RouletteSpinDtoCopyWith(_RouletteSpinDto value, $Res Function(_RouletteSpinDto) _then) = __$RouletteSpinDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String itemId, String text, String level, String createdAt, bool done
});




}
/// @nodoc
class __$RouletteSpinDtoCopyWithImpl<$Res>
    implements _$RouletteSpinDtoCopyWith<$Res> {
  __$RouletteSpinDtoCopyWithImpl(this._self, this._then);

  final _RouletteSpinDto _self;
  final $Res Function(_RouletteSpinDto) _then;

/// Create a copy of RouletteSpinDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? itemId = null,Object? text = null,Object? level = null,Object? createdAt = null,Object? done = null,}) {
  return _then(_RouletteSpinDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
