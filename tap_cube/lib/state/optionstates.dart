class optionStates {
  static final optionStates _OPTION_STATES = new optionStates();
  bool isOptionDialogOpen = false;

  static optionStates getInstance() {
    return _OPTION_STATES;
  }

  void setIsOptionDialogOpen(bool value) {
    isOptionDialogOpen = value;
  }

  bool getIsOptionDialogOpen() {
    return isOptionDialogOpen;
  }
}