import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seed_app/features/actions/data/datasources/action_library_remote_datasource.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/data/repositories/action_library_repository.dart';

class _MockDataSource extends Mock implements ActionLibraryRemoteDataSource {}

void main() {
  late _MockDataSource dataSource;
  late ActionLibraryRepository repository;

  setUp(() {
    dataSource = _MockDataSource();
    repository = ActionLibraryRepository(dataSource: dataSource);
  });

  group('ActionLibraryRepository', () {
    group('watchActions', () {
      test('forwards stream from data source', () {
        const actions = [
          ActionModel(
            id: 'a1',
            nameEn: 'Walk',
            nameJa: '歩く',
            category: 'transport',
            points: 10,
          ),
        ];
        when(() => dataSource.watchActions())
            .thenAnswer((_) => Stream.value(actions));

        final stream = repository.watchActions();

        expect(stream, emits(actions));
        verify(() => dataSource.watchActions()).called(1);
      });

      test('propagates multiple emissions in order', () {
        const first = <ActionModel>[];
        const second = [
          ActionModel(
            id: 'a1',
            nameEn: 'Bike',
            nameJa: '自転車',
            category: 'transport',
            points: 5,
          ),
        ];
        when(() => dataSource.watchActions())
            .thenAnswer((_) => Stream.fromIterable([first, second]));

        expect(repository.watchActions(), emitsInOrder([first, second]));
      });

      test('propagates errors without swallowing', () {
        when(() => dataSource.watchActions())
            .thenAnswer((_) => Stream.error(Exception('boom')));

        expect(repository.watchActions(), emitsError(isA<Exception>()));
      });
    });

    group('getAction', () {
      test('returns action from data source', () async {
        const action = ActionModel(
          id: 'a1',
          nameEn: 'Walk',
          nameJa: '歩く',
          category: 'transport',
          points: 10,
        );
        when(() => dataSource.getAction('a1')).thenAnswer((_) async => action);

        final result = await repository.getAction('a1');

        expect(result, equals(action));
        verify(() => dataSource.getAction('a1')).called(1);
      });

      test('returns null when data source returns null', () async {
        when(() => dataSource.getAction('missing'))
            .thenAnswer((_) async => null);

        final result = await repository.getAction('missing');

        expect(result, isNull);
      });

      test('forwards the exact id argument', () async {
        when(() => dataSource.getAction(any())).thenAnswer((_) async => null);

        await repository.getAction('special-id-123');

        verify(() => dataSource.getAction('special-id-123')).called(1);
      });
    });
  });
}
