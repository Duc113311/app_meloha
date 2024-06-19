import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../data/remote/middle-handler/failure.dart';
import '../../../../../domain/dtos/customers/customers_dto.dart';
import '../../../../../domain/repositories/home_main/home_main_repo.dart';
import '../../../../../general/inject_dependencies/inject_dependencies.dart';

part 'explore_detail_page_state.dart';

class ExploreDetailPageCubit extends Cubit<ExploreDetailPageState> {
  ExploreDetailPageCubit() : super(ExploreDetailPageInitial());

  HomeMainRepo homeMainRepo = getIt<HomeMainRepo>();
  //ExploreRepo repo = getIt<ExploreRepo>();

  //
  //List<CustomerDto> cardCustomer = [];

  //
  // Future<void> joinExplore(String idTopic) async {
  //   emit(ExploreDetailPageLoading());
  //   repo.joinExplore(idTopic).then(
  //         (value) => value.fold((left) {
  //       return emit(ExploreDetailPageFailed(left));
  //     }, (right) async{
  //           await Future.delayed(const Duration(milliseconds: 300),(){
  //             PrefAssist.getMyCustomer() == right;
  //             PrefAssist.saveMyCustomer();
  //           });
  //           await getCards(idTopic);
  //     }),
  //   );
  // }

  // Future<void> getCards(String idTopic) async {
  //   repo.getCards(idTopic).then(
  //         (value) => value.fold((left) {
  //           return emit(ExploreDetailPageFailed(left));
  //         }, (right) {
  //           emit(ExploreDetailPageSuccess(state)..customDto = right.data);
  //         }),
  //       );
  // }
}
