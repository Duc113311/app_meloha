import 'package:dating_app/src/components/bloc/static_info/static_info_data.dart';
import 'package:json_annotation/json_annotation.dart';

import '../general/insert_dto.dart';

part 'prompt_dto.g.dart';

@JsonSerializable()
class PromptDto {
  @JsonKey(name: 'codePrompt')
  String codePrompt;
  @JsonKey(name: 'answer')
  String answer;
  @JsonKey(name: 'id', defaultValue: '')
  String id;
  @JsonKey(name: 'order')
  int? order;
  @JsonKey(name: 'insert')
  InsertDto? insert;

  String get getQuestion {
    if ((codePrompt ?? '').isEmpty) {
      return '';
    }
    return StaticInfoManager.shared().convertPrompt(codePrompt!);
  }

  factory PromptDto.fromJson(Map<String, dynamic> json) =>
      _$PromptDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PromptDtoToJson(this);

  PromptDto({required this.codePrompt, required this.answer, this.id = '', this.order, this.insert})
      : super();
}
