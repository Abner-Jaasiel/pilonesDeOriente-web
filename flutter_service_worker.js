'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/COMMIT_EDITMSG": "0e25c5ffee0af4e2d1f3280219f31446",
".git/config": "9e544aa509c93f09cc3791cefea65c46",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
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
".git/index": "6442616df90e4c21c56dcc93b6e84dc1",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "0bbe7431886db874cea873665eb11cb8",
".git/logs/refs/heads/main": "8792fafaf6d3961067912aadd626ef1b",
".git/logs/refs/remotes/origin/main": "9c2c29815438b3662bd61113ac00db78",
".git/objects/02/45264a965328e4d333aa2e2a66f3065f7924f5": "5a4bca0746c1ca309315c87a809f361f",
".git/objects/07/0a6ba6171cc86ba31efe7c61fd5b7e437bebcc": "97a0da0f830162557309d0f946e8bb5c",
".git/objects/1a/d7683b343914430a62157ebf451b9b2aa95cac": "94fdc36a022769ae6a8c6c98e87b3452",
".git/objects/1e/1c6b09df313a704ff1ae64650d7ec72e2ce967": "b2fabf2ae437572521e173a077d4d958",
".git/objects/1e/3691625e5b979a53e9da34478936ecee85a135": "c09b7aac784603ab90dd7896c1bac88c",
".git/objects/27/f4dd76292e5fd77ca916900195f9823db16d1f": "7ff67a0f3ba8f2ac1f694f25f758dd75",
".git/objects/2b/9ef40880d845fe265005a3b1f76fa16606f877": "1dcf24ae9b9349b9e1383910595d6a53",
".git/objects/44/0afb0a89405e1f91a7c8544b7efa211880dcfe": "05ffd75e6d2f5da18dfb3cd28fb33601",
".git/objects/4c/51fb2d35630595c50f37c2bf5e1ceaf14c1a1e": "a20985c22880b353a0e347c2c6382997",
".git/objects/51/58a37f7de52542c264a8bc38d60ae86ee664d5": "0e524ddeba6fc8e52d58bf38e46aeacc",
".git/objects/53/18a6956a86af56edbf5d2c8fdd654bcc943e88": "a686c83ba0910f09872b90fd86a98a8f",
".git/objects/53/3d2508cc1abb665366c7c8368963561d8c24e0": "4592c949830452e9c2bb87f305940304",
".git/objects/56/e8e55ce73713ab0ec6c2d9bcfdeaba09a41eeb": "66a0afd9023bb6ce4a15ebafbc530634",
".git/objects/59/00cdb901de8ec21b580869c01c70d32e764dae": "498630bca95d427f12739acd32c22b3c",
".git/objects/62/6fee69059b9206078359498cc0d836400c8b38": "0641f2e2986d939be9f5d8c975889411",
".git/objects/6b/9862a1351012dc0f337c9ee5067ed3dbfbb439": "85896cd5fba127825eb58df13dfac82b",
".git/objects/6d/94fd04e42fa86dafc994d2d5fd89d64488c718": "401523aeebcd5d791aff80728894695e",
".git/objects/70/a234a3df0f8c93b4c4742536b997bf04980585": "d95736cd43d2676a49e58b0ee61c1fb9",
".git/objects/73/c63bcf89a317ff882ba74ecb132b01c374a66f": "6ae390f0843274091d1e2838d9399c51",
".git/objects/7a/fc1d0504394c038a6ed1e6b99f15bff05e162d": "f24c238449fe370377e79fe0c3830c5f",
".git/objects/81/01b180f79e73609df9997ec1e0f87b9dc58962": "67b7b4e67c4072bce38f16155ce4dfac",
".git/objects/84/c73fae0deade50115860b219fcc72f77a7bec6": "52224f5d0a18eacc59fedc93655d3b09",
".git/objects/85/0438c57f682d615f9b33c9564a42aab1e61a41": "a4f72337ac8a6efcf20e77e70cfe4f12",
".git/objects/8b/2dc663a543f1cb14ee7997289fab33d1b6a6a9": "b26796a867d641893279bccb0a6960fc",
".git/objects/8e/3c7d6bbbef6e7cefcdd4df877e7ed0ee4af46e": "025a3d8b84f839de674cd3567fdb7b1b",
".git/objects/9b/d3accc7e6a1485f4b1ddfbeeaae04e67e121d8": "784f8e1966649133f308f05f2d98214f",
".git/objects/9b/e2e2101748de33aa8cd7e84d68171404e528aa": "c8cc90e0e5ee269a56432a9502873536",
".git/objects/b0/0c915a301c8891835721cd7292ff3a21a14462": "15f4d89157582971fb53d610919b9d10",
".git/objects/b0/112571f52b44ecc11407666378da47794955a5": "eb1d7c59cf6860dc40b3aebf75c9e056",
".git/objects/b5/379d6e77fbfad10cad0ae3184363f6d1561036": "3080af10963ea38c151b75e2d931108c",
".git/objects/b9/6a5236065a6c0fb7193cb2bb2f538b2d7b4788": "4227e5e94459652d40710ef438055fe5",
".git/objects/bb/9a37ba6bd80de59b01b9f3fef376280be2eef7": "59a5621f505499999dedb5e6b44162eb",
".git/objects/bc/c4d3c27588a0e1e73345f7b1ae009e1fc3e7b4": "c565b2a2c5a664803c3087b32e8943a3",
".git/objects/c8/08fb85f7e1f0bf2055866aed144791a1409207": "92cdd8b3553e66b1f3185e40eb77684e",
".git/objects/d3/2cca838ab320b6809cd5146e39747e0d7d6345": "f1eba3705c25dc359a38454b010e0c93",
".git/objects/d3/d7ee3e54a005e15b9aaf9f81801302cb22d8c1": "577d34b7a01d6fcbb3c59ab732e15f5d",
".git/objects/d3/deba978551a8bf2907862c4b0a55138c462817": "0a8d2f006c2f5f1084504f7664ecff10",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/d4/69d50206f513305c9395ab97126e4861711448": "ea609f6bf316aca447597a3d07b43ae3",
".git/objects/d6/325c74f7310fb8a15768c9b1a0ec3dc57f51fb": "1662a89945c225fd30003761af48e2da",
".git/objects/db/ebec1f1da6855802646dee13765b9b645d79e5": "f87ed6b728a39f35beb152343ff9aa9a",
".git/objects/dc/11fdb45a686de35a7f8c24f3ac5f134761b8a9": "761c08dfe3c67fe7f31a98f6e2be3c9c",
".git/objects/e0/7ac7b837115a3d31ed52874a73bd277791e6bf": "74ebcb23eb10724ed101c9ff99cfa39f",
".git/objects/e1/1db3b262d569aeafa4b07ebc28ae1fa023bcbe": "0623b206c0960c84b402ef537dd4d4c6",
".git/objects/e8/cb9ed860fa934e14bee75ec18a0460444b584b": "b9d58bcb4eb53d36714ad42fea47b145",
".git/objects/e9/94225c71c957162e2dcc06abe8295e482f93a2": "2eed33506ed70a5848a0b06f5b754f2c",
".git/objects/ea/99f8990de53d7085fb9fc704ad2b2728a7c700": "c1065f1df5759d7094e0bf053a6a9351",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/f5/72b90ef57ee79b82dd846c6871359a7cb10404": "e68f5265f0bb82d792ff536dcb99d803",
".git/objects/fd/f0c6bd0029a5a0f7b19b32b5f7b11713eff642": "388b3bbb48988446e241c927db2cd922",
".git/refs/heads/main": "be4152084a66a68fb6bd26d35580c0b3",
".git/refs/remotes/origin/main": "be4152084a66a68fb6bd26d35580c0b3",
"assets/AssetManifest.bin": "fe584cf4e8e01f0c4efc99279987fd86",
"assets/AssetManifest.bin.json": "ab9b85712123addac4dff04bb9d74e60",
"assets/AssetManifest.json": "49028c1b8f63c0210e41e3b6c82f7791",
"assets/assets/images/icon.png": "6656b1a337b1d765a40bcf9176baff81",
"assets/FontManifest.json": "ac3f70900a17dc2eb8830a3e27c653c3",
"assets/fonts/MaterialIcons-Regular.otf": "ea985ac7e4e5b8e29193a77084dc5a94",
"assets/NOTICES": "070805e0e8e8fa70f0f07a6f14feb27d",
"assets/packages/awesome_notifications/test/assets/images/test_image.png": "c27a71ab4008c83eba9b554775aa12ca",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/syncfusion_flutter_datagrid/assets/font/FilterIcon.ttf": "b8e5e5bf2b490d3576a9562f24395532",
"assets/packages/syncfusion_flutter_datagrid/assets/font/UnsortIcon.ttf": "acdd567faa403388649e37ceb9adeb44",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"favicon.png": "6656b1a337b1d765a40bcf9176baff81",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"flutter_bootstrap.js": "0e809de5a41d646a90667ed37082e33a",
"icons/Icon-192.png": "6656b1a337b1d765a40bcf9176baff81",
"icons/Icon-512.png": "6656b1a337b1d765a40bcf9176baff81",
"icons/Icon-maskable-192.png": "6656b1a337b1d765a40bcf9176baff81",
"icons/Icon-maskable-512.png": "6656b1a337b1d765a40bcf9176baff81",
"index.html": "61e872fd389bb9bd0ef8eb1214f541ac",
"/": "61e872fd389bb9bd0ef8eb1214f541ac",
"main.dart.js": "53f8a61318773023d8b9e974d1d6065b",
"manifest.json": "f40c818243173f8da436e394e4833e2e",
"version.json": "dc9f58731b0169a544e8078e0314ce22"};
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
