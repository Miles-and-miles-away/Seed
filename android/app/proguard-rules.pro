# Flutter, Firebase and GMS bundle their own keep rules; blanket -keep lines defeat R8.
-dontwarn io.flutter.embedding.**
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Crashlytics
-keepattributes SourceFile,LineNumberTable
