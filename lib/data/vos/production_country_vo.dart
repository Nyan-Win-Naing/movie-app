import 'package:hive_flutter/adapters.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:movie_app/persistence/hive_constants.dart';

part 'production_country_vo.g.dart';

@JsonSerializable()
@HiveType(typeId: HIVE_TYPE_ID_PRODUCTION_COUNTRY_VO, adapterName: "ProductionCountryVOAdapter")
class ProductionCountryVO {
  @JsonKey(name: "iso_3166_1")
  @HiveField(0)
  String? iso31661;
  @JsonKey(name: "name")
  @HiveField(1)
  String? name;

  ProductionCountryVO(this.iso31661, this.name);


  factory ProductionCountryVO.fromJson(Map<String, dynamic> json) =>
      _$ProductionCountryVOFromJson(json);

  Map<String, dynamic> toJson() => _$ProductionCountryVOToJson(this);
}
