'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/AUTO_MERGE": "28709f36bb1e79285bf32410b58b1391",
".git/COMMIT_EDITMSG": "8cf8463b34caa8ac871a52d5dd7ad1ef",
".git/config": "1b8a48718f73a3e7671eaedcae4d2b6f",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/FETCH_HEAD": "d6101761010e7d20afa08a1e19d12204",
".git/HEAD": "cf7dd3ce51958c5f13fece957cc417fb",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-commit.sample": "5029bfab85b1c39281aa9697379ea444",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/hooks/sendemail-validate.sample": "4d67df3a8d5c98cb8565c07e42be0b04",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/index": "befddedc31f02d0a05153c5d5b22bc59",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "8374d0ae8c9386701b83ca2b72edd3c1",
".git/logs/refs/heads/main": "6f52c6da3d5944c4819ee18dff91ca42",
".git/logs/refs/remotes/origin/main": "d00e7d941187371025572431f4c0f06d",
".git/objects/0e/836456ed1d8b654e9e9259a6bc3d667151e217": "00b4ad921412ea8f54d8264190d3b05b",
".git/objects/0e/a55f42503675b73c82c351c47dec1b055b42a9": "e3c669694e604d0a566e5771e26e40b9",
".git/objects/1d/468b85698a60041b450286f31b3264b3bbd6f7": "5c8c497111befde32ac151f14cf92f85",
".git/objects/35/96d08a5b8c249a9ff1eb36682aee2a23e61bac": "e931dda039902c600d4ba7d954ff090f",
".git/objects/39/9e4567d42f7a6cc6eb4f2d834d5f17bb73368e": "380c96799324f07f7c634db78b90e8c2",
".git/objects/40/1184f2840fcfb39ffde5f2f82fe5957c37d6fa": "1ea653b99fd29cd15fcc068857a1dbb2",
".git/objects/46/4ab5882a2234c39b1a4dbad5feba0954478155": "2e52a767dc04391de7b4d0beb32e7fc4",
".git/objects/4a/2b4bea553c0349bfbc0e812cae482c1230fede": "fd30fc36b8d969a4945ffa05e3442e6f",
".git/objects/53/3402c75429e6feaa7b8f92878ae2313dbdf2de": "63ab067b0b447b461fa3e8f58a1f23a9",
".git/objects/56/e8e55ce73713ab0ec6c2d9bcfdeaba09a41eeb": "66a0afd9023bb6ce4a15ebafbc530634",
".git/objects/57/7946daf6467a3f0a883583abfb8f1e57c86b54": "846aff8094feabe0db132052fd10f62a",
".git/objects/5f/bf1f5ee49ba64ffa8e24e19c0231e22add1631": "f19d414bb2afb15ab9eb762fd11311d6",
".git/objects/6b/88d1b6d1164c423e5dc149194ddc3c2912e6ef": "bffdccdce560586a668c78ac410cf3cf",
".git/objects/6b/9862a1351012dc0f337c9ee5067ed3dbfbb439": "85896cd5fba127825eb58df13dfac82b",
".git/objects/6d/94fd04e42fa86dafc994d2d5fd89d64488c718": "401523aeebcd5d791aff80728894695e",
".git/objects/72/3d030bc89a4250e63d16b082affe1998618c3f": "e4299c419434fc51f64a5266659918fa",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/8a/51a9b155d31c44b148d7e287fc2872e0cafd42": "9f785032380d7569e69b3d17172f64e8",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/8f/c8be62f202c40e7d3e2e16242fb065cfc4e1a7": "6fda1b80da67a8d96186cf8ab8b24087",
".git/objects/91/4a40ccb508c126fa995820d01ea15c69bb95f7": "8963a99a625c47f6cd41ba314ebd2488",
".git/objects/98/436d2e43c18b4d61b5c75a63cfb2a5e2c23924": "0c7e8219e5c669d7f933db9f80c27a72",
".git/objects/9a/fbd49d7aa440e432bf8d9a8c08d7a57aad3484": "80c6cf1fe005ff6cbfc07e02fce919d4",
".git/objects/a5/de584f4d25ef8aace1c5a0c190c3b31639895b": "9fbbb0db1824af504c56e5d959e1cdff",
".git/objects/a8/8c9340e408fca6e68e2d6cd8363dccc2bd8642": "11e9d76ebfeb0c92c8dff256819c0796",
".git/objects/b4/8cd326731d270571aa8e9ca4f33121dc79dea8": "2b7daa70e0425ad3f47fe8cf3877b58a",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/c7/14de35a23fd0f5a06067a915e494237f3f25c8": "b627527b56574280b898e2f177d37271",
".git/objects/c7/735e526a7e82c82e5c00c619f7d304cde9e1b2": "b57932e0aebc296b84cce00a220ac62f",
".git/objects/ca/d65b01636d851b34a38174bd121ca87ea57e4d": "fe8ec052daf2f6964ea22360e48094e3",
".git/objects/d3/4a1a5af8e9c5babc9837502828d5ae84027b16": "463b1060b0321b393956b828b349ef6c",
".git/objects/d3/d7ee3e54a005e15b9aaf9f81801302cb22d8c1": "577d34b7a01d6fcbb3c59ab732e15f5d",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/d7/2b18d0a63de7aa106bcec74f6c1d8ced99ce05": "35e6b1be6080b63d2dc471b789e61fbe",
".git/objects/d7/7cfefdbe249b8bf90ce8244ed8fc1732fe8f73": "9c0876641083076714600718b0dab097",
".git/objects/d9/3952e90f26e65356f31c60fc394efb26313167": "1401847c6f090e48e83740a00be1c303",
".git/objects/e8/cb9ed860fa934e14bee75ec18a0460444b584b": "b9d58bcb4eb53d36714ad42fea47b145",
".git/objects/e9/94225c71c957162e2dcc06abe8295e482f93a2": "2eed33506ed70a5848a0b06f5b754f2c",
".git/objects/ea/644298b14798dcd61f6382c82e37df240d49c6": "deae0cc79bc78c090817ff6b071c7128",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/ee/8b72f51015219cecd5478a024d9511be2fc18d": "25d1fb7a0403804df9cd7dac17f434c5",
".git/objects/ef/b875788e4094f6091d9caa43e35c77640aaf21": "27e32738aea45acd66b98d36fc9fc9e0",
".git/objects/f0/2f52cf459329d3812b662e5f91dbda6110e6e6": "755f4cea985d11705480cefcdb4cbeed",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/f3/709a83aedf1f03d6e04459831b12355a9b9ef1": "538d2edfa707ca92ed0b867d6c3903d1",
".git/objects/f5/72b90ef57ee79b82dd846c6871359a7cb10404": "e68f5265f0bb82d792ff536dcb99d803",
".git/objects/pack/pack-88ae0d3da256c29732b2189b771af91ea988004b.idx": "82bede209a221302a6f1f02bb28539ae",
".git/objects/pack/pack-88ae0d3da256c29732b2189b771af91ea988004b.pack": "fbf07d60bfbdc153773b878ae126be51",
".git/objects/pack/pack-88ae0d3da256c29732b2189b771af91ea988004b.rev": "8a1a8ec825e3aa4cf557327448b2e2fb",
".git/ORIG_HEAD": "8a674abc74b41922f12ba3d9262ce590",
".git/refs/heads/main": "f7fcacb69f57a14892538db961870d92",
".git/refs/remotes/origin/main": "f7fcacb69f57a14892538db961870d92",
".vscode/launch.json": "3753c304833f10a98c42ae5ce5e5a2ca",
".vscode/settings.json": "b5d52cc56844afc9bac81168c0ba1952",
"analysis_options.yaml": "9e65f4b9beebb674c0dc252f70a5c177",
"android/app/build.gradle": "44846ccf378da699443e01ae3273dc6a",
"android/app/google-services.json": "42add573eab9a9da4e43b4210578f6f5",
"android/app/src/debug/AndroidManifest.xml": "820c45a25b424dd5b7388330f7548d1f",
"android/app/src/main/AndroidManifest.xml": "3b04b7602bd9380311f95abf5104ff7c",
"android/app/src/main/kotlin/com/ancikle/carkett/MainActivity.kt": "caae794df64f3680a21b0cf531bf61fa",
"android/app/src/main/res/drawable/launch_background.xml": "12c379b886cbd7e72cfee6060a0947d4",
"android/app/src/main/res/drawable-v21/launch_background.xml": "bff4b9cd8e98754261159601bd94abd3",
"android/app/src/main/res/mipmap-hdpi/ic_launcher.png": "13e9c72ec37fac220397aa819fa1ef2d",
"android/app/src/main/res/mipmap-mdpi/ic_launcher.png": "6270344430679711b81476e29878caa7",
"android/app/src/main/res/mipmap-xhdpi/ic_launcher.png": "a0a8db5985280b3679d99a820ae2db79",
"android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png": "afe1b655b9f32da22f9a4301bb8e6ba8",
"android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png": "57838d52c318faff743130c3fcfae0c6",
"android/app/src/main/res/values/styles.xml": "f8b8cfbf977690d117f4dade5d27a789",
"android/app/src/main/res/values-night/styles.xml": "c22fb29c307f2a6ae4317b3a5e577688",
"android/app/src/profile/AndroidManifest.xml": "820c45a25b424dd5b7388330f7548d1f",
"android/build.gradle": "5ed3a14d2d55c87806faa1ea95f4f813",
"android/gradle/wrapper/gradle-wrapper.properties": "118579ee3c6eef15fb547ae278bf819a",
"android/gradle.properties": "28e835ab42cf53277edaa9d08ba87c7d",
"android/settings.gradle": "1191713066d74a9c0db2358e2de52709",
"assets/AssetManifest.bin": "e22653ede92eaa0b547b48b0c8b2bc0c",
"assets/AssetManifest.bin.json": "99a97df8255cc1642883bc1b4df3e618",
"assets/AssetManifest.json": "e21f0de3e9ae975381dc3c047df17ba2",
"assets/cube/FinalBaseMesh.obj": "28df07f7ad9db2669ff2834ad36c33c3",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "44db19564d131e108dfc2f9e6a6a4847",
"assets/images/amex.png": "9a51ebc89c659fc5773105580b8ad519",
"assets/images/carkett_ico.png": "c3f215c33bb2e993c4ab1f69f32ceadc",
"assets/images/contact_info.png": "4fe3d2ffee42e095de240b4a91481a92",
"assets/images/example_shop.jpg": "835db48c9f11fddb2f46ba8ec0ed583d",
"assets/images/flags.png": "c5c2fca0d9b8b69d43b2c5c71e5faa1c",
"assets/images/location_info.png": "3033307ea5236ef19e6fbc2edadfeac5",
"assets/images/mastercard.png": "b8e692cad9b65cbe1bf0e8c2718dcf46",
"assets/images/mockup.jpg": "a8eea730e9e45e3e08c6fc2fb71b04a5",
"assets/images/profileUser.jpg": "cb56535766aa4c9847cb9613946b1a12",
"assets/images/smartphone.png": "624c4eea537bd5a365bfe6cff25623c5",
"assets/images/store_info.png": "7d0c920eec9cb48302617073b088165d",
"assets/images/store_settings.png": "f224a538eda6508a17b1096cd433c605",
"assets/images/unknown.png": "e92c312c65ec80cd3f567b90ef9a8239",
"assets/images/visa.png": "e185b1fda892c4ba77c5cb10af6b1233",
"assets/NOTICES": "88cf9be7125d44ac7a6d1215092da6c5",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "6cfe36b4647fbfa15683e09e7dd366bc",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/chromium/canvaskit.js": "ba4a8ae1a65ff3ad81c6818fd47e348b",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"dataconnect/connector/connector.yaml": "4f2ec20c8322a7a1f2bdb859776aff52",
"dataconnect/connector/mutations.gql": "719c55c6b282f4fffcf53bc45f5d8575",
"dataconnect/connector/queries.gql": "3f14a0d25e937ccc3cde888c230982e5",
"dataconnect/dataconnect.yaml": "2d1c4ccc44c34e6be31a0dbb8d376aa9",
"dataconnect/schema/schema.gql": "cf85ab3f6e52f69b2f1797ad3433a7c9",
"devtools_options.yaml": "1b16e156b9f8b9f43ca52a78a6f72e80",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"firebase.json": "90d627d473a26052a576a95ce55f1b59",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"flutter_bootstrap.js": "5d8a6463a1f5413e2ed6cdf3da5618d7",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "61e872fd389bb9bd0ef8eb1214f541ac",
"/": "61e872fd389bb9bd0ef8eb1214f541ac",
"ios/Flutter/AppFrameworkInfo.plist": "09ece6f06f706864eb9c343ad93b57c8",
"ios/Flutter/Debug.xcconfig": "e2f44c1946b223a1ce15cefc6ba9ad67",
"ios/Flutter/Release.xcconfig": "e2f44c1946b223a1ce15cefc6ba9ad67",
"ios/Runner/AppDelegate.swift": "e277c49e98c9f80e9e71c0524a5cb60f",
"ios/Runner/Assets.xcassets/AppIcon.appiconset/Contents.json": "31a08e429403e265cabfb31b3d65f049",
"ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png": "c785f8932297af4acd5f5ccb7630f01c",
"ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@1x.png": "a2f8558fb1d42514111fbbb19fb67314",
"ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@2x.png": "2247a840b6ee72b8a069208af170e5b1",
"ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@3x.png": "1b3b1538136316263c7092951e923e9d",
"ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@1x.png": "be8887071dd7ec39cb754d236aa9584f",
"ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@2x.png": "043119ef4faa026ff82bd03f241e5338",
"ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@3x.png": "2b1452c4c1bda6177b4fbbb832df217f",
"ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@1x.png": "2247a840b6ee72b8a069208af170e5b1",
"ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@2x.png": "8245359312aea1b0d2412f79a07b0ca5",
"ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@3x.png": "5b3c0902200ce596e9848f22e1f0fe0e",
"ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@2x.png": "5b3c0902200ce596e9848f22e1f0fe0e",
"ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png": "e419d22a37bc40ba185aca1acb6d4ac6",
"ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@1x.png": "36c0d7a7132bdde18898ffdfcfcdc4d2",
"ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@2x.png": "643842917530acf4c5159ae851b0baf2",
"ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-83.5x83.5@2x.png": "665cb5e3c5729da6d639d26eff47a503",
"ios/Runner/Assets.xcassets/LaunchImage.imageset/Contents.json": "b9e927ac17345f2d5f052fe68a3487f9",
"ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage.png": "978c1bee49d7ad5fc1a4d81099b13e18",
"ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@2x.png": "978c1bee49d7ad5fc1a4d81099b13e18",
"ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@3x.png": "978c1bee49d7ad5fc1a4d81099b13e18",
"ios/Runner/Assets.xcassets/LaunchImage.imageset/README.md": "f7ee1b402881509d197f34963e569927",
"ios/Runner/Base.lproj/LaunchScreen.storyboard": "b428258a72232cdd2cc04136ec23e656",
"ios/Runner/Base.lproj/Main.storyboard": "2b4e6b099f6729340a5ecc272c06cff7",
"ios/Runner/Info.plist": "b82b6730915b78308fc02afec29c8af1",
"ios/Runner/Runner-Bridging-Header.h": "7ad7b5cea096132de13ba526b2b9efbe",
"ios/Runner.xcodeproj/project.pbxproj": "772c3b9dc7c667b8229770c54484ef61",
"ios/Runner.xcodeproj/project.xcworkspace/contents.xcworkspacedata": "77d69f353bbf342ad71a24f69ec331ff",
"ios/Runner.xcodeproj/project.xcworkspace/xcshareddata/IDEWorkspaceChecks.plist": "7e8ed88ea03cf8357fe1c73ae979f345",
"ios/Runner.xcodeproj/project.xcworkspace/xcshareddata/WorkspaceSettings.xcsettings": "ecb41062214c654f65e47faa71e6b52e",
"ios/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme": "1eb71d2100e7a36f63a33aa15dbfe6f1",
"ios/Runner.xcworkspace/contents.xcworkspacedata": "ac9a90958f80f9cc1d0d5301144fb629",
"ios/Runner.xcworkspace/xcshareddata/IDEWorkspaceChecks.plist": "7e8ed88ea03cf8357fe1c73ae979f345",
"ios/Runner.xcworkspace/xcshareddata/WorkspaceSettings.xcsettings": "ecb41062214c654f65e47faa71e6b52e",
"ios/RunnerTests/RunnerTests.swift": "24e5d095048eb86c30423f4e04b6e57b",
"lib/firebase_options.dart": "8a2b37fa6e8785dae2968be6ef08736c",
"lib/generated/intl/messages_all.dart": "623edca644dd1d4606bbc977f67e3b55",
"lib/generated/intl/messages_ar.dart": "5cc1e5ddf0ee6f50b1debcf50b630755",
"lib/generated/intl/messages_de.dart": "e35b920db8d641257ff98841b0ebe895",
"lib/generated/intl/messages_en.dart": "3491a1b19af9f2049194e09e7b147e51",
"lib/generated/intl/messages_es.dart": "5cbd43788e478f7b5a311f9aa39223f6",
"lib/generated/intl/messages_fr.dart": "9067b5943d7fb41101417a7c0aaf7b1a",
"lib/generated/intl/messages_it.dart": "80bcbc38b6e10db0fbd99ecc2afabd8f",
"lib/generated/intl/messages_ru.dart": "ab53dd9425b64c90df6f6c7fbb76fa2e",
"lib/generated/intl/messages_zh.dart": "8efaa0619358a485e17142a1007eb134",
"lib/generated/l10n.dart": "a8d56b9f8bda348a08f12926ccb22194",
"lib/l10n/intl_ar.arb": "99914b932bd37a50b983c5e7c90ae93b",
"lib/l10n/intl_de.arb": "99914b932bd37a50b983c5e7c90ae93b",
"lib/l10n/intl_en.arb": "470ccfe242e1246c20b13bf4ccb638de",
"lib/l10n/intl_es.arb": "aafd93b410765b598a03ad7a5b01a862",
"lib/l10n/intl_fr.arb": "0e31130f49c86933bb0d4ef1232b0d58",
"lib/l10n/intl_it.arb": "99914b932bd37a50b983c5e7c90ae93b",
"lib/l10n/intl_ru.arb": "99914b932bd37a50b983c5e7c90ae93b",
"lib/l10n/intl_zh.arb": "99914b932bd37a50b983c5e7c90ae93b",
"lib/main.dart": "cad8cde28b8fbe47ac27fe66f5f57e1c",
"lib/models/cart_item_model.dart": "3566d64bcadcc62e0440b53fe6668d3c",
"lib/models/categories_model.dart": "884a00ee04f73387503ff4789903e6d9",
"lib/models/gemini_chat_model.dart": "3721706bfbffaaab5b3bb6446dbdcc74",
"lib/models/order_seller_model.dart": "49ce3b60979c8dc37608feb159165fac",
"lib/models/order_user_model.dart": "081b6af94a9904d541feba5e5ebb0276",
"lib/models/perfile_model.dart": "92f4fca1eda3c1811e1abd916a87a7a2",
"lib/models/products_carrusel_model.dart": "54a060a90c8558c5336e2e735506090b",
"lib/models/product_model.dart": "7b34b786863ac55f2c46e705b915f4d0",
"lib/models/search_model.dart": "89a1fe18203dfe6abf20966fb91a2f22",
"lib/models/user_model.dart": "cfe8e71fa8fb30dd2c7cbb11a02feefe",
"lib/providers/appbar_controller.dart": "31a280a4dd8ee834552d5db01be6a96b",
"lib/providers/appconfig_controller.dart": "29eee16de58c43d484dc7d4d26465e5e",
"lib/providers/chat_model_ai_controller.dart": "24c44f311b618a367e8f9a0509feb6f2",
"lib/providers/home_controller.dart": "b42e13ce0096e2de683c1fa8df89beea",
"lib/providers/language_controller.dart": "0da43e5479cf05036cc983fde6b0351a",
"lib/providers/location_controller.dart": "1349091415027f58dc372c80cb58426a",
"lib/providers/navigator_controller.dart": "7a3538ff2a8b7edfd00a20d21e20eef3",
"lib/providers/payment_controller.dart": "2aa961bd834ecd8c28979b95854c6a1d",
"lib/providers/product_aggregator_controller.dart": "963b2803f7d67a5d9d83da87f0a96f4e",
"lib/providers/register_data_controller.dart": "472b1174d03eea1d16bbb2b36cf34459",
"lib/providers/route_manager_controller.dart": "c08702dcf0958b179057262ba4ea0070",
"lib/providers/search_filter_controller.dart": "5780f530135351467826c96d95a9445a",
"lib/providers/theme_controller.dart": "293b2e9e823353fda5d044f4ed9db9c8",
"lib/routes.dart": "8693d888e340dea3a309ba886540f733",
"lib/screens/auth/login_screen.dart": "4f16fc63f7e1d9c89e2227fe18098295",
"lib/screens/auth/login_seller_screen.dart": "f7f733ee1f3fc74b57b066fce2eabe50",
"lib/screens/auth/register_screen.dart": "2ae3c852a87988e15db932604cd6cdf4",
"lib/screens/home_screen.dart": "ec09c6a4c7e11ac76094c56bf4fc06c3",
"lib/screens/map_screen.dart": "4b461188d90d68df398120664139fa3c",
"lib/screens/OLDsearch_zone_screen.dart": "80fa329246ec6ab262e48a875c496dd8",
"lib/screens/paid_carousel/card_details_screen.dart": "32af763d206ca5b790f530c24979b0cb",
"lib/screens/paid_carousel/checkout_screen.dart": "b576cfdd96fe7eb105fe27f8421948a0",
"lib/screens/paid_carousel/orders_screen.dart": "4a9471d59e3c1e7b987f2896a1205d0c",
"lib/screens/paid_carousel/payment_information_screen.dart": "a5bb5bb7bb53ce42c152e26b6f357eb2",
"lib/screens/paid_carousel/profile_selection_screen.dart": "8a05bd8e0f5ee6662f614c72209268bc",
"lib/screens/paid_carousel/shopping_cart_screen.dart": "708619ff84fe39cb7b515603fe31a97d",
"lib/screens/product_zone/image_viewer_screen.dart": "5fb97750171d54a1d0f1d843ea29985d",
"lib/screens/product_zone/object_3d_screen.dart": "8906195ae53e834f6dace925b981eaf6",
"lib/screens/product_zone/product_screen.dart": "6601d6047ca3d531d98a0243551fdda2",
"lib/screens/search_zone_screen.dart": "7104b8a85a544695814ab9ad725b50be",
"lib/screens/seller/create_store_screen.dart": "338598e77b39124e756e4ff52abd9b30",
"lib/screens/seller/html_page_screen.dart": "8d50e131bf3e31ca16ba788e629a38a6",
"lib/screens/seller/product_aggregator_screen.dart": "56dd0534feaefc5a226c3dfb454064da",
"lib/screens/seller/provider_dashboard_screen.dart": "f16e37d72ff7b6b30679fd3567c87664",
"lib/screens/seller/seller_selection_screen.dart": "928009812d4b70afcc2bd34d1fea1a82",
"lib/screens/setting/delete_account_screen.dart": "c93000ba2f62c1f3e2c64cd2df0d554c",
"lib/screens/setting/edit_profile_screen.dart": "cea232531c2a0df2919126d84cd2b9bf",
"lib/screens/setting/language_screen.dart": "905aee2313ef1aa2680f7d983280948d",
"lib/screens/setting/profile_list_screen.dart": "0652229c4b2468e44e1a74aef717886e",
"lib/screens/setting/setting_screen.dart": "2e511788d8f71bae80b1dd62de3ff346",
"lib/screens/setting/terms_conditions_screen.dart": "87d5910c4df23293d94c0cf5569a662d",
"lib/screens/setting/user_profile_screen.dart": "f54fdbe6cf350e4299f8b664c20cd1e1",
"lib/screens/start_screen.dart": "46864148e7f50b8d1d6e169d42344896",
"lib/services/api_service.dart": "ec400750d940b5ee1e1835d5305c6844",
"lib/services/auth_firebase_service.dart": "6e9f76a6b757802ef951b10dc22ce3b7",
"lib/services/db_firebase_service.dart": "0abb5414676965fc7ee89c1d5459a65d",
"lib/services/file_service.dart": "e1df28c40f7e932e2547486b6db4bdce",
"lib/services/paypal_service.dart": "5b9ae23d5870256b14dc9e3c649038ad",
"lib/utils/utils.dart": "1cac6a91258c915a0018edbf76d5dd30",
"lib/widgets/alert_widget.dart": "8e6cfb32222a5c0b51337bdba5c505a4",
"lib/widgets/animated_back_widget.dart": "b1c4a0e2872eda296d32430390d9e34a",
"lib/widgets/appbar_search.dart": "9598ca640a5c59a664f17a591cf4f06f",
"lib/widgets/cards/fill_image_card.dart": "1ee4c9679aeef5d489ecfbe711689f8e",
"lib/widgets/cards/flutter_product_card.dart": "b0e7635618c1ec7237fd6e615c9932cc",
"lib/widgets/cards/image_card_content.dart": "c50796bfd736f26fd956b44be2141337",
"lib/widgets/cards/product_card.dart": "5b3cec10080595eaf3e1d0f71659fb2f",
"lib/widgets/cards/slider_widget.dart": "28d7de19280f918854796173bfc52713",
"lib/widgets/cards/transparent_image_card.dart": "b5853c6c4b13df1223aa3d6877ec1d14",
"lib/widgets/custom_appbar_blur.dart": "d38c22277cf5130da5585de74cdc7614",
"lib/widgets/custom_appbar_widget.dart": "f46f7bf3251b4cc57b93f150d7f1e04a",
"lib/widgets/custom_buttom_navigation_bar.dart": "8177b20a92564f41b611bafba2c079db",
"lib/widgets/custom_buttom_textfield_widget.dart": "bee5c401fa25a26f2305ef9ecc1536fc",
"lib/widgets/custom_dropdown_button_widget.dart": "92e6419e77e2576189722a9b29dd498a",
"lib/widgets/custom_floating_action_button.dart": "5dd9fba81da1782b0488e150acf78b83",
"lib/widgets/custom_show_modal_bottom_sheet.dart": "ded48be302bd5faa0a88e43e98b89699",
"lib/widgets/custom_textfield_widget.dart": "a04c47540e27efa3b5407c65ec18016b",
"lib/widgets/flutter_map_widget.dart": "d1738c1ee94b612890d7518dbba1256d",
"lib/widgets/home_screen_widgets/product_carousels_zone_list_widget.dart": "7e2bd667c92b253b9f5a60e5c1cab783",
"lib/widgets/home_screen_widgets/top_image_widget.dart": "e0f72f710d506a74cf270dc41bac9a4f",
"lib/widgets/map_buttom_widget.dart": "17bac70e46cecb8f9c4748d77bd17e79",
"lib/widgets/message_container_widget.dart": "90e1c1e72550a8f54de4e3a02985a8c6",
"lib/widgets/modals/model_ai_chat.dart": "25d62d5f2bd2b5c810120e011eea8e31",
"lib/widgets/product_aggragator_screen/location_selector_widget.dart": "934e93244dd9252c997cbfe8d7c1ad2f",
"lib/widgets/product_screen/comments_product_widget.dart": "96e6f4b95e14eeea6bd00b37415636ad",
"lib/widgets/product_screen/presentation_images_widget.dart": "a4176421335a41eddf670e96240fac82",
"lib/widgets/product_screen/product_info_panel_widget.dart": "87b8f1f15cd28e971cad69525ef580ab",
"lib/widgets/seller/categories_menu_widget.dart": "5ea6a153c2bbd40af06edb32d1fc7f8f",
"lib/widgets/seller/seller_management_screen.dart": "2c19610fafc77ea6c6f6f01ac7102f33",
"lib/widgets/show_long_text_window.dart": "bc01905b4c93608e1105627867bb5279",
"lib/widgets/super_progressindicator_widget.dart": "064c4dad02a498e652780425592f6724",
"linux/CMakeLists.txt": "2083a122a9e17b5dce9b3e6ff138223f",
"linux/flutter/CMakeLists.txt": "2195470ce31675d31db5a37590d011f6",
"linux/flutter/generated_plugins.cmake": "655db7a6424e7dce224fc415d86dc833",
"linux/flutter/generated_plugin_registrant.cc": "499d892f4afab8694d928a0cab33be81",
"linux/flutter/generated_plugin_registrant.h": "0208db974972d7b29a0ac368be83644b",
"linux/main.cc": "539395bcd63dba20afed0838d136189f",
"linux/my_application.cc": "4f7f2eec9c702532cb3b3370f67c6683",
"linux/my_application.h": "f6b37d58752c8671078b6f660e33e8c1",
"macos/Flutter/Flutter-Debug.xcconfig": "f6991d7432e1664af118cc9531127016",
"macos/Flutter/Flutter-Release.xcconfig": "f6991d7432e1664af118cc9531127016",
"macos/Flutter/GeneratedPluginRegistrant.swift": "4ebce0913035f04d4f71f086ecd4d499",
"macos/Runner/AppDelegate.swift": "1813bdfcac0cbedd79c180525df0e4e4",
"macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_1024.png": "c9becc9105f8cabce934d20c7bfb6aac",
"macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_128.png": "3ded30823804caaa5ccc944067c54a36",
"macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_16.png": "8bf511604bc6ed0a6aeb380c5113fdcf",
"macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_256.png": "dfe2c93d1536ae02f085cc63faa3430e",
"macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_32.png": "8e0ae58e362a6636bdfccbc04da2c58c",
"macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_512.png": "0ad44039155424738917502c69667699",
"macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_64.png": "04e7b6ef05346c70b663ca1d97de3ad5",
"macos/Runner/Assets.xcassets/AppIcon.appiconset/Contents.json": "1d48e925145d4b573a3b5d7960a1c585",
"macos/Runner/Base.lproj/MainMenu.xib": "85bdf02ea39336686f2e0ff5f52137cc",
"macos/Runner/Configs/AppInfo.xcconfig": "796e6cf41687af2b06e2ece216ee0844",
"macos/Runner/Configs/Debug.xcconfig": "783e2b0e2aa72d8bc215462bb8d1569d",
"macos/Runner/Configs/Release.xcconfig": "709485d8ea7b78479bf23eb64281287d",
"macos/Runner/Configs/Warnings.xcconfig": "bbde97fb62099b5b9879fb2ffeb1a0a0",
"macos/Runner/DebugProfile.entitlements": "4ad77e84621dc5735c16180a0934fcde",
"macos/Runner/Info.plist": "9ffcbec0a18fdad9d3d606656fd46f9a",
"macos/Runner/MainFlutterWindow.swift": "93c22dae2d93f3dc1402e121901f582b",
"macos/Runner/Release.entitlements": "fc4ad575c1efec3d097fb9d40a0f702f",
"macos/Runner.xcodeproj/project.pbxproj": "3b7542e725b2472a2500c22e3b0162f3",
"macos/Runner.xcodeproj/project.xcworkspace/xcshareddata/IDEWorkspaceChecks.plist": "7e8ed88ea03cf8357fe1c73ae979f345",
"macos/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme": "7fc98d815d81572103373083b67659de",
"macos/Runner.xcworkspace/contents.xcworkspacedata": "ac9a90958f80f9cc1d0d5301144fb629",
"macos/Runner.xcworkspace/xcshareddata/IDEWorkspaceChecks.plist": "7e8ed88ea03cf8357fe1c73ae979f345",
"macos/RunnerTests/RunnerTests.swift": "8059f5d27a19c556eeafb49b3f9b7bdd",
"main.dart.js": "594fa775faee7391c45e110f017c2dda",
"manifest.json": "f40c818243173f8da436e394e4833e2e",
"pubspec.lock": "c778391aaf1e39982a2d321d6c04aad1",
"pubspec.yaml": "f28445923c84a87be5277b239ede33fc",
"README.md": "272a8f6bfb22d4f436a05add84ced8a6",
"test/widget_test.dart": "fbe370b21d466c5e9ced87b86b5c426c",
"ticket_25.pdf": "ea86f6e7f70d76e259e36973ad2867bd",
"version.json": "dc9f58731b0169a544e8078e0314ce22",
"web/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"web/icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"web/icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"web/icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"web/icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"web/index.html": "269a96f21b2ca35d7609693867e2e492",
"web/manifest.json": "dcfc62af391805be300855bfd52af315",
"web_entrypoint.dart": "d41d8cd98f00b204e9800998ecf8427e",
"windows/CMakeLists.txt": "e76a2edfc9e3a16d263f16e6ee466699",
"windows/flutter/CMakeLists.txt": "bbf66fed5180bd9ae8198b8d7c4a0001",
"windows/flutter/generated_plugins.cmake": "44c774b8066800148f053b786371cd9f",
"windows/flutter/generated_plugin_registrant.cc": "3c7bd6bce96894fbcfcc96cacb2ebc8c",
"windows/flutter/generated_plugin_registrant.h": "0c3df6700414e7f332dfa2582a1ae29e",
"windows/runner/CMakeLists.txt": "028602ab9754bffe716659ada7590d29",
"windows/runner/flutter_window.cpp": "2f463f9b7da67a2d692a012f9ea85e0c",
"windows/runner/flutter_window.h": "7defcc89d4a26d56e801241d624d48fb",
"windows/runner/main.cpp": "de05c66007b34bd7227ee27ce07cc556",
"windows/runner/resource.h": "1ade5dd15e613479a15e8832ed276f2b",
"windows/runner/resources/app_icon.ico": "6ea04d80ca2a3fa92c7717c3c44ccc19",
"windows/runner/runner.exe.manifest": "298a0260a755c3959d2c3c8904298803",
"windows/runner/Runner.rc": "3be725640763adc065ee75c68bf9d80d",
"windows/runner/utils.cpp": "432461b09d862a2f8dadf380ff0e34e5",
"windows/runner/utils.h": "fd81e143f5614eb6fd75efe539002853",
"windows/runner/win32_window.cpp": "571eb8234dbc2661be03aa5f2a4d2fca",
"windows/runner/win32_window.h": "7569387d58711ab975940f4df3b4bcda"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
