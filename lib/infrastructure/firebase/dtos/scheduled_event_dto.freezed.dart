// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scheduled_event_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScheduledEventDto {

 String get id; String get date; String get weekId; List<String> get activityIds; String get status; String get createdAt; String? get notes;
/// Create a copy of ScheduledEventDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduledEventDtoCopyWith<ScheduledEventDto> get copyWith => _$ScheduledEventDtoCopyWithImpl<ScheduledEventDto>(this as ScheduledEventDto, _$identity);

  /// Serializes this ScheduledEventDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduledEventDto&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.weekId, weekId) || other.weekId == weekId)&&const DeepCollectionEquality().equals(other.activityIds, activityIds)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,weekId,const DeepCollectionEquality().hash(activityIds),status,createdAt,notes);

@override
String toString() {
  return 'ScheduledEventDto(id: $id, date: $date, weekId: $weekId, activityIds: $activityIds, status: $status, createdAt: $createdAt, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $ScheduledEventDtoCopyWith<$Res>  {
  factory $ScheduledEventDtoCopyWith(ScheduledEventDto value, $Res Function(ScheduledEventDto) _then) = _$ScheduledEventDtoCopyWithImpl;
@useResult
$Res call({
 String id, String date, String weekId, List<String> activityIds, String status, String createdAt, String? notes
});




}
/// @nodoc
class _$ScheduledEventDtoCopyWithImpl<$Res>
    implements $ScheduledEventDtoCopyWith<$Res> {
  _$ScheduledEventDtoCopyWithImpl(this._self, this._then);

  final ScheduledEventDto _self;
  final $Res Function(ScheduledEventDto) _then;

/// Create a copy of ScheduledEventDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? date = null,Object? weekId = null,Object? activityIds = null,Object? status = null,Object? createdAt = null,Object? notes = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,weekId: null == weekId ? _self.weekId : weekId // ignore: cast_nullable_to_non_nullable
as String,activityIds: null == activityIds ? _self.activityIds : activityIds // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduledEventDto].
extension ScheduledEventDtoPatterns on ScheduledEventDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduledEventDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduledEventDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduledEventDto value)  $default,){
final _that = this;
switch (_that) {
case _ScheduledEventDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduledEventDto value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduledEventDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String date,  String weekId,  List<String> activityIds,  String status,  String createdAt,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduledEventDto() when $default != null:
return $default(_that.id,_that.date,_that.weekId,_that.activityIds,_that.status,_that.createdAt,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String date,  String weekId,  List<String> activityIds,  String status,  String createdAt,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _ScheduledEventDto():
return $default(_that.id,_that.date,_that.weekId,_that.activityIds,_that.status,_that.createdAt,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String date,  String weekId,  List<String> activityIds,  String status,  String createdAt,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _ScheduledEventDto() when $default != null:
return $default(_that.id,_that.date,_that.weekId,_that.activityIds,_that.status,_that.createdAt,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScheduledEventDto implements ScheduledEventDto {
  const _ScheduledEventDto({required this.id, required this.date, required this.weekId, required final  List<String> activityIds, required this.status, required this.createdAt, this.notes}): _activityIds = activityIds;
  factory _ScheduledEventDto.fromJson(Map<String, dynamic> json) => _$ScheduledEventDtoFromJson(json);

@override final  String id;
@override final  String date;
@override final  String weekId;
 final  List<String> _activityIds;
@override List<String> get activityIds {
  if (_activityIds is EqualUnmodifiableListView) return _activityIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_activityIds);
}

@override final  String status;
@override final  String createdAt;
@override final  String? notes;

/// Create a copy of ScheduledEventDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduledEventDtoCopyWith<_ScheduledEventDto> get copyWith => __$ScheduledEventDtoCopyWithImpl<_ScheduledEventDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduledEventDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduledEventDto&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.weekId, weekId) || other.weekId == weekId)&&const DeepCollectionEquality().equals(other._activityIds, _activityIds)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,weekId,const DeepCollectionEquality().hash(_activityIds),status,createdAt,notes);

@override
String toString() {
  return 'ScheduledEventDto(id: $id, date: $date, weekId: $weekId, activityIds: $activityIds, status: $status, createdAt: $createdAt, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$ScheduledEventDtoCopyWith<$Res> implements $ScheduledEventDtoCopyWith<$Res> {
  factory _$ScheduledEventDtoCopyWith(_ScheduledEventDto value, $Res Function(_ScheduledEventDto) _then) = __$ScheduledEventDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String date, String weekId, List<String> activityIds, String status, String createdAt, String? notes
});




}
/// @nodoc
class __$ScheduledEventDtoCopyWithImpl<$Res>
    implements _$ScheduledEventDtoCopyWith<$Res> {
  __$ScheduledEventDtoCopyWithImpl(this._self, this._then);

  final _ScheduledEventDto _self;
  final $Res Function(_ScheduledEventDto) _then;

/// Create a copy of ScheduledEventDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? date = null,Object? weekId = null,Object? activityIds = null,Object? status = null,Object? createdAt = null,Object? notes = freezed,}) {
  return _then(_ScheduledEventDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,weekId: null == weekId ? _self.weekId : weekId // ignore: cast_nullable_to_non_nullable
as String,activityIds: null == activityIds ? _self._activityIds : activityIds // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
