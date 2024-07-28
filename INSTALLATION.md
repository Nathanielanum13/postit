# Project Setup

This project was developed around 2020, so its supporting infrastructure is largely legacy.

## Recommended Dart Version
- **Dart SDK Version**: 2.12.0 (stable) on "linux_x64"

## Note
If you encounter an error related to `toIntValue()` on a null object, modify the Dart analyzer to be null-safe. Update the following code in `../analyzer-0.40.7/lib/src/error/best_practices_verifier.dart` on line 1545:

```dart
for (var annotation in classElement.metadata) {
    if (annotation.isTarget) {
        var value = annotation.computeConstantValue();
        if (value != null) {
            var kindsField = value.getField('kinds');
            if (kindsField != null) {
                var kindsSet = kindsField.toSetValue();
                if (kindsSet != null) {
                    var kinds = <TargetKind>{};
                    for (var kindObject in kindsSet) {
                        var indexField = kindObject.getField('index');
                        if (indexField != null) {
                            var index = indexField.toIntValue();
                            if (index != null) {
                                var targetKindClass =
                                    (kindObject.type as InterfaceType).element as EnumElementImpl;
                                var getter = targetKindClass.constants[index];
                                var name = 'TargetKind.${getter.name}';
                                var foundTargetKind = _targetKindsByName[name];
                                if (foundTargetKind != null) {
                                    kinds.add(foundTargetKind);
                                }
                            }
                        }
                    }
                    return kinds;
                }
            }
        }
    }
}
```