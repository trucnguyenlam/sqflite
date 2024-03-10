#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'sqflite'
  s.version          = '0.0.7'
  s.summary          = 'SQLite plugin.'
  s.description      = <<-DESC
Access SQLite database.
                       DESC
  s.homepage         = 'https://github.com/tekartik/sqflite'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Tekartik' => 'alex@tekartik.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.ios.dependency 'Flutter'
  s.osx.dependency 'FlutterMacOS'
  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.14'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.resource_bundles = {'sqflite_darwin_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
  # c++ support
  s.libraries = "c++"
  s.xcconfig  = {
    'CLANG_CXX_LANGUAGE_STANDARD' => 'c++11',
    'CLANG_CXX_LIBRARY' => 'libc++'
  }
  # s.xcconfig = { 'OTHER_CFLAGS' => '$(inherited) -DSqfliteDarwinDB_SQLITE_STANDALONE' }

  # iOS packed version https://github.com/yapstudios/YapDatabase/wiki/SQLite-version-(bundled-with-OS)
  # download sqlite version from https://www.sqlite.org/chronology.html,
  # then build the source with ./configure && make sqlite3.c sqlite3.h sqlite3ext.h,
  # after that adding sqlite3_auto_extension(sqlite3_signaltokenizer_init) to sqlite3.c source
  sqlite_version = "3.45.1"
  # for flag, https://github.com/requery/sqlite-android/blob/master/sqlite-android/src/main/jni/sqlite/Android.mk
  sqlite_compiled_options = "-DNDEBUG=1 -DSQLITE_HAVE_ISNAN -DSQLITE_DEFAULT_JOURNAL_SIZE_LIMIT=1048576 -DSQLITE_THREADSAFE=2 -DSQLITE_TEMP_STORE=3 -DSQLITE_POWERSAFE_OVERWRITE=1 -DSQLITE_DEFAULT_FILE_FORMAT=4 -DSQLITE_DEFAULT_AUTOVACUUM=1 -DSQLITE_ENABLE_MEMORY_MANAGEMENT=1 -DSQLITE_ENABLE_FTS3 -DSQLITE_ENABLE_FTS3_PARENTHESIS -DSQLITE_ENABLE_FTS4 -DSQLITE_ENABLE_FTS4_PARENTHESIS -DSQLITE_ENABLE_FTS5 -DSQLITE_ENABLE_FTS5_PARENTHESIS -DSQLITE_ENABLE_JSON1 -DSQLITE_ENABLE_RTREE=1 -DSQLITE_UNTESTABLE -DSQLITE_OMIT_COMPILEOPTION_DIAGS -DSQLITE_DEFAULT_FILE_PERMISSIONS=0600 -DSQLITE_DEFAULT_MEMSTATUS=0 -DSQLITE_MAX_EXPR_DEPTH=0 -DSQLITE_USE_ALLOCA -DSQLITE_ENABLE_BATCH_ATOMIC_WRITE -O3"

  # instruction borrowed from https://github.com/ccgus/fmdb/blob/master/FMDB.podspec
  s.subspec 'sqlite3' do |sss|
    sss.source_files = "Libs/#{sqlite_version}/sqlite*.{h,c}"
    sss.public_header_files = "Libs/#{sqlite_version}/sqlite3.h,Libs/#{sqlite_version}/sqlite3ext.h"
    sss.osx.pod_target_xcconfig = { 'OTHER_CFLAGS' => "$(inherited) -DHAVE_USLEEP=1 #{sqlite_compiled_options}" }
    # Disable OS X / AFP locking code on mobile platforms (iOS, tvOS, watchOS)
    sqlite_xcconfig_ios = { 'OTHER_CFLAGS' => "$(inherited) -DHAVE_USLEEP=1 -DSQLITE_ENABLE_LOCKING_STYLE=0 #{sqlite_compiled_options}" }
    sss.ios.pod_target_xcconfig = sqlite_xcconfig_ios
    sss.tvos.pod_target_xcconfig = sqlite_xcconfig_ios
    sss.watchos.pod_target_xcconfig = sqlite_xcconfig_ios
    # compiled with extensions
    sss.vendored_frameworks = 'Frameworks/SignalTokenizer.xcframework', 'Frameworks/CalibreTokenizer.xcframework', 'Frameworks/icudata.xcframework', 'Frameworks/icui18n.xcframework', 'Frameworks/icuio.xcframework', 'Frameworks/icuuc.xcframework', 'Frameworks/stemmer.xcframework'
  end

end

