// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'streak_stats_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StreakStatsDto {

 int get currentStreak; int get bestStreak; double get weeklyCompletionRate; double get monthlyCompletionRate; double get yearlyCompletionRate;
/// Create a copy of StreakStatsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StreakStatsDtoCopyWith<StreakStatsDto> get copyWith => _$StreakStatsDtoCopyWithImpl<StreakStatsDto>(this as StreakStatsDto, _$identity);

  /// Serializes this StreakStatsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StreakStatsDto&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.bestStreak, bestStreak) || other.bestStreak == bestStreak)&&(identical(other.weeklyCompletionRate, weeklyCompletionRate) || other.weeklyCompletionRate == weeklyCompletionRate)&&(identical(other.monthlyCompletionRate, monthlyCompletionRate) || other.monthlyCompletionRate == monthlyCompletionRate)&&(identical(other.yearlyCompletionRate, yearlyCompletionRate) || other.yearlyCompletionRate == yearlyCompletionRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentStreak,bestStreak,weeklyCompletionRate,monthlyCompletionRate,yearlyCompletionRate);

@override
String toString() {
  return 'StreakStatsDto(currentStreak: $currentStreak, bestStreak: $bestStreak, weeklyCompletionRate: $weeklyCompletionRate, monthlyCompletionRate: $monthlyCompletionRate, yearlyCompletionRate: $yearlyCompletionRate)';
}


}

/// @nodoc
abstract mixin class $StreakStatsDtoCopyWith<$Res>  {
  factory $StreakStatsDtoCopyWith(StreakStatsDto value, $Res Function(StreakStatsDto) _then) = _$StreakStatsDtoCopyWithImpl;
@useResult
$Res call({
 int currentStreak, int bestStreak, double weeklyCompletionRate, double monthlyCompletionRate, double yearlyCompletionRate
});




}
/// @nodoc
class _$StreakStatsDtoCopyWithImpl<$Res>
    implements $StreakStatsDtoCopyWith<$Res> {
  _$StreakStatsDtoCopyWithImpl(this._self, this._then);

  final StreakStatsDto _self;
  final $Res Function(StreakStatsDto) _then;

/// Create a copy of StreakStatsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentStreak = null,Object? bestStreak = null,Object? weeklyCompletionRate = null,Object? monthlyCompletionRate = null,Object? yearlyCompletionRate = null,}) {
  return _then(_self.copyWith(
currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,bestStreak: null == bestStreak ? _self.bestStreak : bestStreak // ignore: cast_nullable_to_non_nullable
as int,weeklyCompletionRate: null == weeklyCompletionRate ? _self.weeklyCompletionRate : weeklyCompletionRate // ignore: cast_nullable_to_non_nullable
as double,monthlyCompletionRate: null == monthlyCompletionRate ? _self.monthlyCompletionRate : monthlyCompletionRate // ignore: cast_nullable_to_non_nullable
as double,yearlyCompletionRate: null == yearlyCompletionRate ? _self.yearlyCompletionRate : yearlyCompletionRate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [StreakStatsDto].
extension StreakStatsDtoPatterns on StreakStatsDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StreakStatsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StreakStatsDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StreakStatsDto value)  $default,){
final _that = this;
switch (_that) {
case _StreakStatsDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StreakStatsDto value)?  $default,){
final _that = this;
switch (_that) {
case _StreakStatsDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int currentStreak,  int bestStreak,  double weeklyCompletionRate,  double monthlyCompletionRate,  double yearlyCompletionRate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StreakStatsDto() when $default != null:
return $default(_that.currentStreak,_that.bestStreak,_that.weeklyCompletionRate,_that.monthlyCompletionRate,_that.yearlyCompletionRate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int currentStreak,  int bestStreak,  double weeklyCompletionRate,  double monthlyCompletionRate,  double yearlyCompletionRate)  $default,) {final _that = this;
switch (_that) {
case _StreakStatsDto():
return $default(_that.currentStreak,_that.bestStreak,_that.weeklyCompletionRate,_that.monthlyCompletionRate,_that.yearlyCompletionRate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int currentStreak,  int bestStreak,  double weeklyCompletionRate,  double monthlyCompletionRate,  double yearlyCompletionRate)?  $default,) {final _that = this;
switch (_that) {
case _StreakStatsDto() when $default != null:
return $default(_that.currentStreak,_that.bestStreak,_that.weeklyCompletionRate,_that.monthlyCompletionRate,_that.yearlyCompletionRate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StreakStatsDto implements StreakStatsDto {
  const _StreakStatsDto({required this.currentStreak, required this.bestStreak, required this.weeklyCompletionRate, required this.monthlyCompletionRate, required this.yearlyCompletionRate});
  factory _StreakStatsDto.fromJson(Map<String, dynamic> json) => _$StreakStatsDtoFromJson(json);

@override final  int currentStreak;
@override final  int bestStreak;
@override final  double weeklyCompletionRate;
@override final  double monthlyCompletionRate;
@override final  double yearlyCompletionRate;

/// Create a copy of StreakStatsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StreakStatsDtoCopyWith<_StreakStatsDto> get copyWith => __$StreakStatsDtoCopyWithImpl<_StreakStatsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StreakStatsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StreakStatsDto&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.bestStreak, bestStreak) || other.bestStreak == bestStreak)&&(identical(other.weeklyCompletionRate, weeklyCompletionRate) || other.weeklyCompletionRate == weeklyCompletionRate)&&(identical(other.monthlyCompletionRate, monthlyCompletionRate) || other.monthlyCompletionRate == monthlyCompletionRate)&&(identical(other.yearlyCompletionRate, yearlyCompletionRate) || other.yearlyCompletionRate == yearlyCompletionRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentStreak,bestStreak,weeklyCompletionRate,monthlyCompletionRate,yearlyCompletionRate);

@override
String toString() {
  return 'StreakStatsDto(currentStreak: $currentStreak, bestStreak: $bestStreak, weeklyCompletionRate: $weeklyCompletionRate, monthlyCompletionRate: $monthlyCompletionRate, yearlyCompletionRate: $yearlyCompletionRate)';
}


}

/// @nodoc
abstract mixin class _$StreakStatsDtoCopyWith<$Res> implements $StreakStatsDtoCopyWith<$Res> {
  factory _$StreakStatsDtoCopyWith(_StreakStatsDto value, $Res Function(_StreakStatsDto) _then) = __$StreakStatsDtoCopyWithImpl;
@override @useResult
$Res call({
 int currentStreak, int bestStreak, double weeklyCompletionRate, double monthlyCompletionRate, double yearlyCompletionRate
});




}
/// @nodoc
class __$StreakStatsDtoCopyWithImpl<$Res>
    implements _$StreakStatsDtoCopyWith<$Res> {
  __$StreakStatsDtoCopyWithImpl(this._self, this._then);

  final _StreakStatsDto _self;
  final $Res Function(_StreakStatsDto) _then;

/// Create a copy of StreakStatsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentStreak = null,Object? bestStreak = null,Object? weeklyCompletionRate = null,Object? monthlyCompletionRate = null,Object? yearlyCompletionRate = null,}) {
  return _then(_StreakStatsDto(
currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,bestStreak: null == bestStreak ? _self.bestStreak : bestStreak // ignore: cast_nullable_to_non_nullable
as int,weeklyCompletionRate: null == weeklyCompletionRate ? _self.weeklyCompletionRate : weeklyCompletionRate // ignore: cast_nullable_to_non_nullable
as double,monthlyCompletionRate: null == monthlyCompletionRate ? _self.monthlyCompletionRate : monthlyCompletionRate // ignore: cast_nullable_to_non_nullable
as double,yearlyCompletionRate: null == yearlyCompletionRate ? _self.yearlyCompletionRate : yearlyCompletionRate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
