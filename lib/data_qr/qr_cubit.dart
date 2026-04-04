
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'qr_repository.dart';
import 'qr_state.dart';

@injectable
class QrCubit extends Cubit<QrState> {
  final QrRepository _qrRepository;
  QrCubit(this._qrRepository) : super(QrInitialState());

  Future<void> getMyQr() async {
    emit(QrLoadingState());
    final result = await _qrRepository.getMyQr();
    result.fold(
      (failure) => emit(QrErrorState(message: failure.message)),
      (qrModel) => emit(QrSuccessState(qrModel: qrModel)),
    );
  }
}
