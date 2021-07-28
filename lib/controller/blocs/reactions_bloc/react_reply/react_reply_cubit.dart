import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:ogrety_app/controller/blocs/reactions_bloc/react_reply/react_reply_state.dart';
import 'package:ogrety_app/model/fetch_reply_model.dart';

import '../../../urls.dart';
import '../reactions_controller.dart';

class ReactReplyCubit extends Cubit<ReactReplyState> {
  ReactReplyCubit() : super(ReactReplyInitial());

  emitNewState(ReactReplyState reactionsState) {
    emit(reactionsState);
  }

  addReact({@required String token, @required Doc doc}) async {
    doc.flavor = "love";
    emit(AddReaction(doc: doc));
    await ReactionsController.addReact(token: token, id: doc.id);
    if (Urls.errorMessage == 'no') {
      emit(AddReaction(doc: doc));
    } else {
      doc.flavor = null;
      emit(Err(err: Urls.errorMessage));
    }
  }

  removeReact({@required String token, @required Doc doc}) async {
    doc.flavor = null;
    emit(RemoveReaction(doc: doc));
    await ReactionsController.removeReact(token: token, id: doc.id);
    if (Urls.errorMessage == 'no') {
      emit(RemoveReaction(doc: doc));
    } else {
      doc.flavor = "love";
      emit(Err(err: Urls.errorMessage));
    }
  }
}
