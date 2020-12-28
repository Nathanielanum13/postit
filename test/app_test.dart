@TestOn('browser')
import 'package:angular_test/angular_test.dart';
import 'package:test/test.dart';
import 'package:angular_app/post_it_app_component.dart';
import 'package:angular_app/post_it_app_component.template.dart' as ng;

void main() {
  final testBed =
      NgTestBed.forComponent<PostItAppComponent>(ng.PostItAppComponentNgFactory);
  NgTestFixture<PostItAppComponent> fixture;

  setUp(() async {
    fixture = await testBed.create();
  });

  tearDown(disposeAnyRunningTest);

  test('heading', () {
    expect(fixture.text, contains('My First AngularDart App'));
  });

  // Testing info: https://angulardart.dev/guide/testing
}
