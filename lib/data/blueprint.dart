import 'package:json_annotation/json_annotation.dart';

part 'blueprint.g.dart';

@JsonSerializable()
class ProjectBlueprint {
  String title, description, url;

  ProjectBlueprint(this.title, this.description, this.url);

  factory ProjectBlueprint.fromJson(Map<String, dynamic> json) =>
      _$ProjectBlueprintFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectBlueprintToJson(this);
}
