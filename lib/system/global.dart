
bool _hasInitialized = false;

//Initialize all global things here.
initializeGlobalStuffs() async {

  _hasInitialized = true;
}

bool globalStuffsHasInitialized() {
  return _hasInitialized;
}