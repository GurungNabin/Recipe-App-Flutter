import 'package:equatable/equatable.dart';

abstract class PdfEvent extends Equatable {
  const PdfEvent();

  @override
  List<Object> get props => [];
}

class GenerateRecipePdf extends PdfEvent {
  final dynamic recipe;

  const GenerateRecipePdf(this.recipe);

  @override
  List<Object> get props => [recipe];
}
