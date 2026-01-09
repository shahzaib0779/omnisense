# Suppress warnings for missing java.beans classes (not available on Android)
-dontwarn java.beans.**
-keep class java.beans.** { *; }

# Keep SnakeYAML classes from being removed or renamed
-dontwarn org.yaml.snakeyaml.**
-keep class org.yaml.snakeyaml.** { *; }