import 'package:equatable/equatable.dart';

abstract class PdfState extends Equatable {
  const PdfState();

  @override
  List<Object> get props => [];
}

class PdfInitial extends PdfState {}

class PdfLoading extends PdfState {}

class PdfGenerated extends PdfState {
  final String filePath;

  const PdfGenerated(this.filePath);

  @override
  List<Object> get props => [filePath];
}

class PdfError extends PdfState {
  final String message;

  const PdfError(this.message);

  @override
  List<Object> get props => [message];
}
