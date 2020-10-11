# Spits everything out to build/output/release
mkdir -p build/output/release
echo "Building dnotifyd (dnotify daemon)..."
dart compile exe -o build/output/release/dnotifyd bin/dnotifyd.dart
echo "Building dnotify (dnotify tool)..."
dart compile exe -o build/output/release/dnotify bin/dnotify.dart