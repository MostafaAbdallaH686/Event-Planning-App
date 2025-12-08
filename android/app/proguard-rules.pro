# Rules for Firebase Crashlytics
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception
-keep class com.google.firebase.crashlytics.** { *; }
-keep class com.google.firebase.analytics.** { *; }

# Preserve Firebase SDK classes
-keep class com.google.firebase.** { *; }
-keep interface com.google.firebase.** { *; }

# Keep custom application classes
-keep class com.example.event_planning_app.** { *; }

# Preserve line numbers for Crashlytics
-renamesourcefileattribute SourceFile

# Keep enums
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep Kotlin metadata
-keepclassmembers class **$WhenMappings {
    <fields>;
}

# Keep data classes
-keepclassmembers class * {
    ** component1();
    ** component2();
    ** component3();
    ** component4();
    ** component5();
}

# Keep serializable classes
-keep class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}
