import 'package:luzia/services/stoppable_service.dart';

class LocationService extends StoppableService {
  @override
  void start() {
    super.start();
    print('LocationService Started');
  }

  @override
  void stop() {
    super.stop();
    print('LocationService Stopped');
  }
}
