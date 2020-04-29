import 'package:luzia/services/stoppable_service.dart';

class BackGroundFetchService extends StoppableService {
  @override
  void start() {
    super.start();
    print('BackGroundFetchService Started');
  }

  @override
  void stop() {
    super.stop();
    print('BackGroundFetchService Started');
  }
}
