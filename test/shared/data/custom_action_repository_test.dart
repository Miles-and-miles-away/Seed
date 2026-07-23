import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/shared/data/custom_action_repository.dart';
import 'package:seed_app/shared/models/custom_action_model.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late CustomActionRepository repository;

  const uid = 'test-user';

  setUp(() {
    firestore = FakeFirebaseFirestore();
    repository = CustomActionRepository(firestore);
  });

  Future<int> customActionCount() async {
    final snap = await firestore
        .collection(AppConstants.collectionUsers)
        .doc(uid)
        .collection(AppConstants.collectionCustomActions)
        .get();
    return snap.docs.length;
  }

  CustomAction action({
    String name = 'Walk instead of Fly',
    int co2Grams = 5000,
    int points = 30,
  }) => CustomAction(
    id: '',
    name: name,
    co2Grams: co2Grams,
    points: points,
    category: 'transport',
    relatedSdgs: const ['11', '13'],
  );

  test('re-banking an identical choice reuses one template', () async {
    final first = await repository.create(uid, action());
    final second = await repository.create(uid, action());

    expect(first.id, second.id);
    expect(await customActionCount(), 1);
  });

  test('distinct choices get distinct templates', () async {
    final a = await repository.create(uid, action());
    final b = await repository.create(uid, action(co2Grams: 9000));

    expect(a.id, isNot(b.id));
    expect(await customActionCount(), 2);
  });

  test('id is a valid non-empty firestore doc id, not blank', () async {
    final created = await repository.create(uid, action());
    expect(created.id, isNotEmpty);
    expect(created.id, isNot(contains('/')));
  });
}
