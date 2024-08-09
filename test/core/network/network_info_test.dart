import 'package:clean_code_architecture_tdd/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'network_info_test.mocks.dart';

@GenerateNiceMocks([MockSpec<InternetConnectionChecker>()])
void main() {
  late NetworkInfoImpl networkInfoImpl;
  late MockInternetConnectionChecker mockInternetConnectionChecker;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockInternetConnectionChecker);
  });

  group('isConnected', () {
    test(
      'should return true when there is an internet connection',
      () async {
        // Arrange
        when(mockInternetConnectionChecker.hasConnection).thenAnswer((_) async => true); // Ensure this returns a Future<bool>

        // Act
        final result = await networkInfoImpl.isConnected;

        // Assert
        verify(mockInternetConnectionChecker.hasConnection);
        expect(result, true);
      },
    );

    test(
      'should return false when there is no internet connection',
      () async {
        // Arrange
        when(mockInternetConnectionChecker.hasConnection).thenAnswer((_) async => false); // Ensure this returns a Future<bool>

        // Act
        final result = await networkInfoImpl.isConnected;

        // Assert
        verify(mockInternetConnectionChecker.hasConnection);
        expect(result, false);
      },
    );
  });
}
