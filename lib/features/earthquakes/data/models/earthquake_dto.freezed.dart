// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'earthquake_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EarthquakeDto {

 String get id; EarthquakePropertiesDto get properties; EarthquakeGeometryDto get geometry;
/// Create a copy of EarthquakeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EarthquakeDtoCopyWith<EarthquakeDto> get copyWith => _$EarthquakeDtoCopyWithImpl<EarthquakeDto>(this as EarthquakeDto, _$identity);

  /// Serializes this EarthquakeDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EarthquakeDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EarthquakeDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.properties, _this.properties) || other.properties == _this.properties)&&(identical(other.geometry, _this.geometry) || other.geometry == _this.geometry));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EarthquakeDto;
  return Object.hash(runtimeType,_this.id,_this.properties,_this.geometry);
}

@override
String toString() {
  final _this = this as EarthquakeDto;
  return 'EarthquakeDto(id: ${_this.id}, properties: ${_this.properties}, geometry: ${_this.geometry})';
}


}

/// @nodoc
abstract mixin class $EarthquakeDtoCopyWith<$Res>  {
  factory $EarthquakeDtoCopyWith(EarthquakeDto value, $Res Function(EarthquakeDto) _then) = _$EarthquakeDtoCopyWithImpl;
@useResult
$Res call({
 String id, EarthquakePropertiesDto properties, EarthquakeGeometryDto geometry
});


$EarthquakePropertiesDtoCopyWith<$Res> get properties;$EarthquakeGeometryDtoCopyWith<$Res> get geometry;

}
/// @nodoc
class _$EarthquakeDtoCopyWithImpl<$Res>
    implements $EarthquakeDtoCopyWith<$Res> {
  _$EarthquakeDtoCopyWithImpl(this._self, this._then);

  final EarthquakeDto _self;
  final $Res Function(EarthquakeDto) _then;

/// Create a copy of EarthquakeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? properties = null,Object? geometry = null,}) {
  return _then(EarthquakeDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,properties: null == properties ? _self.properties : properties // ignore: cast_nullable_to_non_nullable
as EarthquakePropertiesDto,geometry: null == geometry ? _self.geometry : geometry // ignore: cast_nullable_to_non_nullable
as EarthquakeGeometryDto,
  ));
}
/// Create a copy of EarthquakeDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EarthquakePropertiesDtoCopyWith<$Res> get properties {
  
  return $EarthquakePropertiesDtoCopyWith<$Res>(_self.properties, (value) {
    return _then(_self.copyWith(properties: value));
  });
}/// Create a copy of EarthquakeDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EarthquakeGeometryDtoCopyWith<$Res> get geometry {
  
  return $EarthquakeGeometryDtoCopyWith<$Res>(_self.geometry, (value) {
    return _then(_self.copyWith(geometry: value));
  });
}
}


/// Adds pattern-matching-related methods to [EarthquakeDto].
extension EarthquakeDtoPatterns on EarthquakeDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EarthquakeDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EarthquakeDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EarthquakeDto value)  $default,){
final _that = this;
switch (_that) {
case _EarthquakeDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EarthquakeDto value)?  $default,){
final _that = this;
switch (_that) {
case _EarthquakeDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  EarthquakePropertiesDto properties,  EarthquakeGeometryDto geometry)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EarthquakeDto() when $default != null:
return $default(_that.id,_that.properties,_that.geometry);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  EarthquakePropertiesDto properties,  EarthquakeGeometryDto geometry)  $default,) {final _that = this;
switch (_that) {
case _EarthquakeDto():
return $default(_that.id,_that.properties,_that.geometry);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  EarthquakePropertiesDto properties,  EarthquakeGeometryDto geometry)?  $default,) {final _that = this;
switch (_that) {
case _EarthquakeDto() when $default != null:
return $default(_that.id,_that.properties,_that.geometry);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EarthquakeDto implements EarthquakeDto {
  const _EarthquakeDto({required this.id, required this.properties, required this.geometry});
  factory _EarthquakeDto.fromJson(Map<String, dynamic> json) => _$EarthquakeDtoFromJson(json);

@override final  String id;
@override final  EarthquakePropertiesDto properties;
@override final  EarthquakeGeometryDto geometry;

/// Create a copy of EarthquakeDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EarthquakeDtoCopyWith<_EarthquakeDto> get copyWith => __$EarthquakeDtoCopyWithImpl<_EarthquakeDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EarthquakeDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EarthquakeDto&&(identical(other.id, id) || other.id == id)&&(identical(other.properties, properties) || other.properties == properties)&&(identical(other.geometry, geometry) || other.geometry == geometry));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,properties,geometry);
}

@override
String toString() {
    return 'EarthquakeDto(id: $id, properties: $properties, geometry: $geometry)';
}


}

/// @nodoc
abstract mixin class _$EarthquakeDtoCopyWith<$Res> implements $EarthquakeDtoCopyWith<$Res> {
  factory _$EarthquakeDtoCopyWith(_EarthquakeDto value, $Res Function(_EarthquakeDto) _then) = __$EarthquakeDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, EarthquakePropertiesDto properties, EarthquakeGeometryDto geometry
});


@override $EarthquakePropertiesDtoCopyWith<$Res> get properties;@override $EarthquakeGeometryDtoCopyWith<$Res> get geometry;

}
/// @nodoc
class __$EarthquakeDtoCopyWithImpl<$Res>
    implements _$EarthquakeDtoCopyWith<$Res> {
  __$EarthquakeDtoCopyWithImpl(this._self, this._then);

  final _EarthquakeDto _self;
  final $Res Function(_EarthquakeDto) _then;

/// Create a copy of EarthquakeDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? properties = null,Object? geometry = null,}) {
  return _then(_EarthquakeDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,properties: null == properties ? _self.properties : properties // ignore: cast_nullable_to_non_nullable
as EarthquakePropertiesDto,geometry: null == geometry ? _self.geometry : geometry // ignore: cast_nullable_to_non_nullable
as EarthquakeGeometryDto,
  ));
}

/// Create a copy of EarthquakeDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EarthquakePropertiesDtoCopyWith<$Res> get properties {
  
  return $EarthquakePropertiesDtoCopyWith<$Res>(_self.properties, (value) {
    return _then(_self.copyWith(properties: value));
  });
}/// Create a copy of EarthquakeDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EarthquakeGeometryDtoCopyWith<$Res> get geometry {
  
  return $EarthquakeGeometryDtoCopyWith<$Res>(_self.geometry, (value) {
    return _then(_self.copyWith(geometry: value));
  });
}
}


/// @nodoc
mixin _$EarthquakePropertiesDto {

 num get mag; String get place; int get time;
/// Create a copy of EarthquakePropertiesDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EarthquakePropertiesDtoCopyWith<EarthquakePropertiesDto> get copyWith => _$EarthquakePropertiesDtoCopyWithImpl<EarthquakePropertiesDto>(this as EarthquakePropertiesDto, _$identity);

  /// Serializes this EarthquakePropertiesDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EarthquakePropertiesDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EarthquakePropertiesDto&&(identical(other.mag, _this.mag) || other.mag == _this.mag)&&(identical(other.place, _this.place) || other.place == _this.place)&&(identical(other.time, _this.time) || other.time == _this.time));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EarthquakePropertiesDto;
  return Object.hash(runtimeType,_this.mag,_this.place,_this.time);
}

@override
String toString() {
  final _this = this as EarthquakePropertiesDto;
  return 'EarthquakePropertiesDto(mag: ${_this.mag}, place: ${_this.place}, time: ${_this.time})';
}


}

/// @nodoc
abstract mixin class $EarthquakePropertiesDtoCopyWith<$Res>  {
  factory $EarthquakePropertiesDtoCopyWith(EarthquakePropertiesDto value, $Res Function(EarthquakePropertiesDto) _then) = _$EarthquakePropertiesDtoCopyWithImpl;
@useResult
$Res call({
 num mag, String place, int time
});




}
/// @nodoc
class _$EarthquakePropertiesDtoCopyWithImpl<$Res>
    implements $EarthquakePropertiesDtoCopyWith<$Res> {
  _$EarthquakePropertiesDtoCopyWithImpl(this._self, this._then);

  final EarthquakePropertiesDto _self;
  final $Res Function(EarthquakePropertiesDto) _then;

/// Create a copy of EarthquakePropertiesDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mag = null,Object? place = null,Object? time = null,}) {
  return _then(EarthquakePropertiesDto(
mag: null == mag ? _self.mag : mag // ignore: cast_nullable_to_non_nullable
as num,place: null == place ? _self.place : place // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [EarthquakePropertiesDto].
extension EarthquakePropertiesDtoPatterns on EarthquakePropertiesDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EarthquakePropertiesDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EarthquakePropertiesDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EarthquakePropertiesDto value)  $default,){
final _that = this;
switch (_that) {
case _EarthquakePropertiesDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EarthquakePropertiesDto value)?  $default,){
final _that = this;
switch (_that) {
case _EarthquakePropertiesDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( num mag,  String place,  int time)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EarthquakePropertiesDto() when $default != null:
return $default(_that.mag,_that.place,_that.time);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( num mag,  String place,  int time)  $default,) {final _that = this;
switch (_that) {
case _EarthquakePropertiesDto():
return $default(_that.mag,_that.place,_that.time);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( num mag,  String place,  int time)?  $default,) {final _that = this;
switch (_that) {
case _EarthquakePropertiesDto() when $default != null:
return $default(_that.mag,_that.place,_that.time);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EarthquakePropertiesDto implements EarthquakePropertiesDto {
  const _EarthquakePropertiesDto({required this.mag, required this.place, required this.time});
  factory _EarthquakePropertiesDto.fromJson(Map<String, dynamic> json) => _$EarthquakePropertiesDtoFromJson(json);

@override final  num mag;
@override final  String place;
@override final  int time;

/// Create a copy of EarthquakePropertiesDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EarthquakePropertiesDtoCopyWith<_EarthquakePropertiesDto> get copyWith => __$EarthquakePropertiesDtoCopyWithImpl<_EarthquakePropertiesDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EarthquakePropertiesDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EarthquakePropertiesDto&&(identical(other.mag, mag) || other.mag == mag)&&(identical(other.place, place) || other.place == place)&&(identical(other.time, time) || other.time == time));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,mag,place,time);
}

@override
String toString() {
    return 'EarthquakePropertiesDto(mag: $mag, place: $place, time: $time)';
}


}

/// @nodoc
abstract mixin class _$EarthquakePropertiesDtoCopyWith<$Res> implements $EarthquakePropertiesDtoCopyWith<$Res> {
  factory _$EarthquakePropertiesDtoCopyWith(_EarthquakePropertiesDto value, $Res Function(_EarthquakePropertiesDto) _then) = __$EarthquakePropertiesDtoCopyWithImpl;
@override @useResult
$Res call({
 num mag, String place, int time
});




}
/// @nodoc
class __$EarthquakePropertiesDtoCopyWithImpl<$Res>
    implements _$EarthquakePropertiesDtoCopyWith<$Res> {
  __$EarthquakePropertiesDtoCopyWithImpl(this._self, this._then);

  final _EarthquakePropertiesDto _self;
  final $Res Function(_EarthquakePropertiesDto) _then;

/// Create a copy of EarthquakePropertiesDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mag = null,Object? place = null,Object? time = null,}) {
  return _then(_EarthquakePropertiesDto(
mag: null == mag ? _self.mag : mag // ignore: cast_nullable_to_non_nullable
as num,place: null == place ? _self.place : place // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$EarthquakeGeometryDto {

 List<double> get coordinates;
/// Create a copy of EarthquakeGeometryDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EarthquakeGeometryDtoCopyWith<EarthquakeGeometryDto> get copyWith => _$EarthquakeGeometryDtoCopyWithImpl<EarthquakeGeometryDto>(this as EarthquakeGeometryDto, _$identity);

  /// Serializes this EarthquakeGeometryDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EarthquakeGeometryDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EarthquakeGeometryDto&&const DeepCollectionEquality().equals(other.coordinates, _this.coordinates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EarthquakeGeometryDto;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.coordinates));
}

@override
String toString() {
  final _this = this as EarthquakeGeometryDto;
  return 'EarthquakeGeometryDto(coordinates: ${_this.coordinates})';
}


}

/// @nodoc
abstract mixin class $EarthquakeGeometryDtoCopyWith<$Res>  {
  factory $EarthquakeGeometryDtoCopyWith(EarthquakeGeometryDto value, $Res Function(EarthquakeGeometryDto) _then) = _$EarthquakeGeometryDtoCopyWithImpl;
@useResult
$Res call({
 List<double> coordinates
});




}
/// @nodoc
class _$EarthquakeGeometryDtoCopyWithImpl<$Res>
    implements $EarthquakeGeometryDtoCopyWith<$Res> {
  _$EarthquakeGeometryDtoCopyWithImpl(this._self, this._then);

  final EarthquakeGeometryDto _self;
  final $Res Function(EarthquakeGeometryDto) _then;

/// Create a copy of EarthquakeGeometryDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? coordinates = null,}) {
  return _then(EarthquakeGeometryDto(
coordinates: null == coordinates ? _self.coordinates : coordinates // ignore: cast_nullable_to_non_nullable
as List<double>,
  ));
}

}


/// Adds pattern-matching-related methods to [EarthquakeGeometryDto].
extension EarthquakeGeometryDtoPatterns on EarthquakeGeometryDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EarthquakeGeometryDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EarthquakeGeometryDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EarthquakeGeometryDto value)  $default,){
final _that = this;
switch (_that) {
case _EarthquakeGeometryDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EarthquakeGeometryDto value)?  $default,){
final _that = this;
switch (_that) {
case _EarthquakeGeometryDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<double> coordinates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EarthquakeGeometryDto() when $default != null:
return $default(_that.coordinates);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<double> coordinates)  $default,) {final _that = this;
switch (_that) {
case _EarthquakeGeometryDto():
return $default(_that.coordinates);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<double> coordinates)?  $default,) {final _that = this;
switch (_that) {
case _EarthquakeGeometryDto() when $default != null:
return $default(_that.coordinates);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EarthquakeGeometryDto implements EarthquakeGeometryDto {
  const _EarthquakeGeometryDto({required  List<double> coordinates}): _coordinates = coordinates;
  factory _EarthquakeGeometryDto.fromJson(Map<String, dynamic> json) => _$EarthquakeGeometryDtoFromJson(json);

 final  List<double> _coordinates;
@override List<double> get coordinates {
  if (_coordinates is EqualUnmodifiableListView) return _coordinates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_coordinates);
}


/// Create a copy of EarthquakeGeometryDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EarthquakeGeometryDtoCopyWith<_EarthquakeGeometryDto> get copyWith => __$EarthquakeGeometryDtoCopyWithImpl<_EarthquakeGeometryDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EarthquakeGeometryDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EarthquakeGeometryDto&&const DeepCollectionEquality().equals(other.coordinates, _coordinates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_coordinates));
}

@override
String toString() {
    return 'EarthquakeGeometryDto(coordinates: $coordinates)';
}


}

/// @nodoc
abstract mixin class _$EarthquakeGeometryDtoCopyWith<$Res> implements $EarthquakeGeometryDtoCopyWith<$Res> {
  factory _$EarthquakeGeometryDtoCopyWith(_EarthquakeGeometryDto value, $Res Function(_EarthquakeGeometryDto) _then) = __$EarthquakeGeometryDtoCopyWithImpl;
@override @useResult
$Res call({
 List<double> coordinates
});




}
/// @nodoc
class __$EarthquakeGeometryDtoCopyWithImpl<$Res>
    implements _$EarthquakeGeometryDtoCopyWith<$Res> {
  __$EarthquakeGeometryDtoCopyWithImpl(this._self, this._then);

  final _EarthquakeGeometryDto _self;
  final $Res Function(_EarthquakeGeometryDto) _then;

/// Create a copy of EarthquakeGeometryDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? coordinates = null,}) {
  return _then(_EarthquakeGeometryDto(
coordinates: null == coordinates ? _self._coordinates : coordinates // ignore: cast_nullable_to_non_nullable
as List<double>,
  ));
}


}

// dart format on
