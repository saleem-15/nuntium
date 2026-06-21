# We do not explicitly keep io.flutter.** anymore because Flutter's internal deferred component 
# classes extend Play Core classes. Keeping them forces R8 to crash looking for missing superclasses!
# Flutter handles its own keep rules natively.

# Google Sign-In / Play Services
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Flutter Deferred Components / Play Core (Stops R8 from failing if Play Core is missing)
-dontwarn com.google.android.play.core.**
-dontwarn io.flutter.embedding.engine.deferredcomponents.**

