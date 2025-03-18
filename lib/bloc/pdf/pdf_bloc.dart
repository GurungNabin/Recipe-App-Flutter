import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_book/bloc/pdf/pdf_event.dart';
import 'package:recipe_book/bloc/pdf/pdf_state.dart';
import 'package:recipe_book/presentation/pages/pdf_generate.dart';

class PdfBloc extends Bloc<PdfEvent, PdfState> {
  PdfBloc() : super(PdfInitial()) {
    on<GenerateRecipePdf>(_onGenerateRecipePdf);
  }

  Future<void> _onGenerateRecipePdf(
      GenerateRecipePdf event, Emitter<PdfState> emit) async {
    emit(PdfLoading());
    try {
      final filePath = await PdfGenerator.generatePdf(event.recipe);
      emit(PdfGenerated(filePath));
    } catch (e) {
      emit(PdfError(e.toString()));
    }
  }
}
