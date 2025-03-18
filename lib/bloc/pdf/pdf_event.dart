import 'package:equatable/equatable.dart';
import 'package:recipe_book/model/recipe.dart';

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
