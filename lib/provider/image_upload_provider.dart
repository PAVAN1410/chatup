import 'package:flutter/material.dart';
import 'package:skype_3/enum/viewState.dart';

class ImageUploadProvider with ChangeNotifier{

ViewState _viewState = ViewState.IDLE;

 get getViewState => _viewState;

void setToLoading() {
  _viewState = ViewState.LOADING;
  notifyListeners();
}

void setToIdle(){
  _viewState = ViewState.IDLE;
  notifyListeners();
}
  
}