import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ogrety_app/controller/blocs/reactions_bloc/reactions_controller.dart';
import 'package:ogrety_app/controller/urls.dart';
import 'package:ogrety_app/model/posts_model.dart';
import 'reactions_state.dart';

class ReactionsCubit extends Cubit<ReactionsState> {
  ReactionsCubit() : super(ReactionsInitial());
  emitNewState(ReactionsState reactionsState) {
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
