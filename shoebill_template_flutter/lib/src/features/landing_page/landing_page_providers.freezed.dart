// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'landing_page_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LandingPageState {

 bool get isLoading; String? get thinkingText; String? get errorMessage;
/// Create a copy of LandingPageState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LandingPageStateCopyWith<LandingPageState> get copyWith => _$LandingPageStateCopyWithImpl<LandingPageState>(this as LandingPageState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LandingPageState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.thinkingText, thinkingText) || other.thinkingText == thinkingText)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,thinkingText,errorMessage);

@override
String toString() {
  return 'LandingPageState(isLoading: $isLoading, thinkingText: $thinkingText, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $LandingPageStateCopyWith<$Res>  {
  factory $LandingPageStateCopyWith(LandingPageState value, $Res Function(LandingPageState) _then) = _$LandingPageStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, String? thinkingText, String? errorMessage
});




}
/// @nodoc
class _$LandingPageStateCopyWithImpl<$Res>
    implements $LandingPageStateCopyWith<$Res> {
  _$LandingPageStateCopyWithImpl(this._self, this._then);

  final LandingPageState _self;
  final $Res Function(LandingPageState) _then;

/// Create a copy of LandingPageState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? thinkingText = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,thinkingText: freezed == thinkingText ? _self.thinkingText : thinkingText // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LandingPageState].
extension LandingPageStatePatterns on LandingPageState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LandingPageState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LandingPageState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LandingPageState value)  $default,){
final _that = this;
switch (_that) {
case _LandingPageState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LandingPageState value)?  $default,){
final _that = this;
switch (_that) {
case _LandingPageState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  String? thinkingText,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LandingPageState() when $default != null:
return $default(_that.isLoading,_that.thinkingText,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  String? thinkingText,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _LandingPageState():
return $default(_that.isLoading,_that.thinkingText,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  String? thinkingText,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _LandingPageState() when $default != null:
return $default(_that.isLoading,_that.thinkingText,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _LandingPageState implements LandingPageState {
  const _LandingPageState({this.isLoading = false, this.thinkingText, this.errorMessage});
  

@override@JsonKey() final  bool isLoading;
@override final  String? thinkingText;
@override final  String? errorMessage;

/// Create a copy of LandingPageState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LandingPageStateCopyWith<_LandingPageState> get copyWith => __$LandingPageStateCopyWithImpl<_LandingPageState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LandingPageState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.thinkingText, thinkingText) || other.thinkingText == thinkingText)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,thinkingText,errorMessage);

@override
String toString() {
  return 'LandingPageState(isLoading: $isLoading, thinkingText: $thinkingText, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$LandingPageStateCopyWith<$Res> implements $LandingPageStateCopyWith<$Res> {
  factory _$LandingPageStateCopyWith(_LandingPageState value, $Res Function(_LandingPageState) _then) = __$LandingPageStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String? thinkingText, String? errorMessage
});




}
/// @nodoc
class __$LandingPageStateCopyWithImpl<$Res>
    implements _$LandingPageStateCopyWith<$Res> {
  __$LandingPageStateCopyWithImpl(this._self, this._then);

  final _LandingPageState _self;
  final $Res Function(_LandingPageState) _then;

/// Create a copy of LandingPageState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? thinkingText = freezed,Object? errorMessage = freezed,}) {
  return _then(_LandingPageState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,thinkingText: freezed == thinkingText ? _self.thinkingText : thinkingText // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
