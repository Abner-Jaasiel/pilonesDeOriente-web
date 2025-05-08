'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/COMMIT_EDITMSG": "b10b4db8780a2378241ca8e40b3c53bb",
".git/config": "97d7dc39d4ee18f1208094c029876123",
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
".git/index": "ac28d253d5af21ae37b5206c1ce36264",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "d363f671164cfc54b3614a9d12505b1c",
".git/logs/refs/heads/main": "47ca5bcf3c51e68f5efd4a8abe032432",
".git/logs/refs/heads/master": "af14a223768df11d77248c0ddb08fff4",
".git/logs/refs/remotes/origin/main": "a9c83e915dd48afec8580ccf2267f3f9",
".git/objects/02/397a968956701156bd08bfd534fbc7573569e3": "70d113e3c43b0f7364ed7edbe767e7fe",
".git/objects/04/705df99827af3ff211527e19d25a32193d146f": "e70590442ec9fb4901a86b4d2cefa6b4",
".git/objects/06/01d675e106268451de543b1f058583a20fb2c7": "b58642f699183613a01c464783d02862",
".git/objects/06/32e3c86c42e308c9209aa044dc433c1a8a4612": "3bcd7d1de7117ffc4c4f9b5f13016c70",
".git/objects/0d/953014b017994fcbbddbc1bab195864cf0352d": "afad88f51efbe39d3c43df7fcafe8bff",
".git/objects/1d/468b85698a60041b450286f31b3264b3bbd6f7": "5c8c497111befde32ac151f14cf92f85",
".git/objects/1e/1c6b09df313a704ff1ae64650d7ec72e2ce967": "b2fabf2ae437572521e173a077d4d958",
".git/objects/1e/4c5f66a42f93f1cee86179274ffab5606779e7": "799eab9fb5d00f7f386b94dd5ab6238e",
".git/objects/25/c5fc099e960dce12bd4595d27e488f6ff2988c": "46afd2fdf4306d12c97db0513d0150c5",
".git/objects/27/f4dd76292e5fd77ca916900195f9823db16d1f": "7ff67a0f3ba8f2ac1f694f25f758dd75",
".git/objects/2a/c05dff7aff96e488679ad9ef5642b29cf78b01": "662e6d9edbc3a9b626d7376644d79960",
".git/objects/2b/9ef40880d845fe265005a3b1f76fa16606f877": "1dcf24ae9b9349b9e1383910595d6a53",
".git/objects/30/cbfbff551d110eadebda2bbc43148eebe881ff": "1a245b4b54cf7813ff5b1554c150ed1d",
".git/objects/35/96d08a5b8c249a9ff1eb36682aee2a23e61bac": "e931dda039902c600d4ba7d954ff090f",
".git/objects/38/ad5d3f2c8ad24d392493960ed8389c1e939e98": "0216f00e51e31c264438e131c6a115fc",
".git/objects/39/8a5e7a7fd87d82b797f6bf60525656258a66c3": "73f81cdffe5010134cd3c9b5bc028030",
".git/objects/40/1184f2840fcfb39ffde5f2f82fe5957c37d6fa": "1ea653b99fd29cd15fcc068857a1dbb2",
".git/objects/42/a48ebc59cb54a79c8575fbf768a3d402f430b5": "c1b6c30725f777fa9fb4e97613e3291a",
".git/objects/43/67e966c697e802eea46623ac3687670fca3708": "3a6f353735e9ded07f0558bc6101bafb",
".git/objects/44/0afb0a89405e1f91a7c8544b7efa211880dcfe": "05ffd75e6d2f5da18dfb3cd28fb33601",
".git/objects/46/4ab5882a2234c39b1a4dbad5feba0954478155": "2e52a767dc04391de7b4d0beb32e7fc4",
".git/objects/4a/2b4bea553c0349bfbc0e812cae482c1230fede": "fd30fc36b8d969a4945ffa05e3442e6f",
".git/objects/4c/59722eb95799eb11fde91904ac886875a0e58e": "422bdcbacf4be28a5d0428862b6a2363",
".git/objects/51/58a37f7de52542c264a8bc38d60ae86ee664d5": "0e524ddeba6fc8e52d58bf38e46aeacc",
".git/objects/53/3402c75429e6feaa7b8f92878ae2313dbdf2de": "63ab067b0b447b461fa3e8f58a1f23a9",
".git/objects/54/fd148ec442ae1db74757e59bd57c978d8373d9": "00299db2cef1a9ddf70223234d2266a1",
".git/objects/56/e8e55ce73713ab0ec6c2d9bcfdeaba09a41eeb": "66a0afd9023bb6ce4a15ebafbc530634",
".git/objects/57/7946daf6467a3f0a883583abfb8f1e57c86b54": "846aff8094feabe0db132052fd10f62a",
".git/objects/59/00cdb901de8ec21b580869c01c70d32e764dae": "498630bca95d427f12739acd32c22b3c",
".git/objects/5e/f3b4fa270ad79dcb4f659630e620bb1cf7e5c2": "86dc0c6ba8109e9a05e4356071f844b5",
".git/objects/5f/bf1f5ee49ba64ffa8e24e19c0231e22add1631": "f19d414bb2afb15ab9eb762fd11311d6",
".git/objects/62/6fee69059b9206078359498cc0d836400c8b38": "0641f2e2986d939be9f5d8c975889411",
".git/objects/67/d9bf3162352cb778814f52f276d8ef63f77edf": "5992b2e5c654e1339bc0096256815316",
".git/objects/6b/9862a1351012dc0f337c9ee5067ed3dbfbb439": "85896cd5fba127825eb58df13dfac82b",
".git/objects/6d/94fd04e42fa86dafc994d2d5fd89d64488c718": "401523aeebcd5d791aff80728894695e",
".git/objects/72/3d030bc89a4250e63d16b082affe1998618c3f": "e4299c419434fc51f64a5266659918fa",
".git/objects/76/7fbec18a1407b4162f9403fdea65e3386a3cdb": "631ade6b9059d7edfe69569eb2a3e3a8",
".git/objects/77/dfdb5651ad96590b89282003c7670dbc5fa028": "1abfd72419653b89c534d35fda6e4319",
".git/objects/78/e0e9ddb5701496c45878588f8d340f11645a9d": "a8a90d65af656ffae61b32a021326def",
".git/objects/7a/af3da066de93f19b4a611191b6aed4af6c1d7e": "0341d44b95098cc654100c83d04f9031",
".git/objects/81/01b180f79e73609df9997ec1e0f87b9dc58962": "67b7b4e67c4072bce38f16155ce4dfac",
".git/objects/85/0438c57f682d615f9b33c9564a42aab1e61a41": "a4f72337ac8a6efcf20e77e70cfe4f12",
".git/objects/88/67707c3aeb07964d7e27c8056fa8fb270f38a7": "b0bf24962b9639c92cb1f50da094d6ce",
".git/objects/8a/51a9b155d31c44b148d7e287fc2872e0cafd42": "9f785032380d7569e69b3d17172f64e8",
".git/objects/8b/2dc663a543f1cb14ee7997289fab33d1b6a6a9": "b26796a867d641893279bccb0a6960fc",
".git/objects/8f/c8be62f202c40e7d3e2e16242fb065cfc4e1a7": "6fda1b80da67a8d96186cf8ab8b24087",
".git/objects/91/4a40ccb508c126fa995820d01ea15c69bb95f7": "8963a99a625c47f6cd41ba314ebd2488",
".git/objects/93/160525623425873cb8bfdac42407369a8200dd": "22ab6becc852940357633257d381a19b",
".git/objects/9a/fbd49d7aa440e432bf8d9a8c08d7a57aad3484": "80c6cf1fe005ff6cbfc07e02fce919d4",
".git/objects/9b/e2e2101748de33aa8cd7e84d68171404e528aa": "c8cc90e0e5ee269a56432a9502873536",
".git/objects/9d/b805e0914a6e926764d7d95531f2908913d64b": "440ab475d93bdaee0bce3cf52a8ee867",
".git/objects/9d/c949ed318bcd864ff0c1ced199af821c0a0b29": "5c124a0d7b81f015aab818560b1d1fde",
".git/objects/a5/de584f4d25ef8aace1c5a0c190c3b31639895b": "9fbbb0db1824af504c56e5d959e1cdff",
".git/objects/a6/f5464bfefd368a806bd6648d9e2345b64912d6": "af263ae6ed494192dd56afb42d3e818a",
".git/objects/a8/8c9340e408fca6e68e2d6cd8363dccc2bd8642": "11e9d76ebfeb0c92c8dff256819c0796",
".git/objects/a9/4f3ee0f382984701c1c8a2a3638cae34930040": "105c48b2dcbb474ff5b315f554f3fa62",
".git/objects/b0/0c915a301c8891835721cd7292ff3a21a14462": "15f4d89157582971fb53d610919b9d10",
".git/objects/b5/379d6e77fbfad10cad0ae3184363f6d1561036": "3080af10963ea38c151b75e2d931108c",
".git/objects/b8/40bd1ce923e9d86318533ec59beb42cd95a6d1": "853791977ddabd3d1e6c81676694b8c9",
".git/objects/bc/c4d3c27588a0e1e73345f7b1ae009e1fc3e7b4": "c565b2a2c5a664803c3087b32e8943a3",
".git/objects/be/717a7ef958ebda71906aab7e65f28a9f0e3226": "eb0097e6d153d9000c42dae8f701275c",
".git/objects/c1/a9dbe5272ad5b9e66538898a6ec7c78611871d": "9b2e8c818b47f4401225826d586bf69b",
".git/objects/c9/0431cd010dbcb7e8cc32ebc5736af760a0b650": "35525cf8f5ef413913f4adca6bda261c",
".git/objects/cc/829c696238f25db7e2ea816d32a1d8696bcef9": "f63eeae6b21b33b1c6ec54ef10da8d98",
".git/objects/d3/2cca838ab320b6809cd5146e39747e0d7d6345": "f1eba3705c25dc359a38454b010e0c93",
".git/objects/d3/d7ee3e54a005e15b9aaf9f81801302cb22d8c1": "577d34b7a01d6fcbb3c59ab732e15f5d",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/d7/7cfefdbe249b8bf90ce8244ed8fc1732fe8f73": "9c0876641083076714600718b0dab097",
".git/objects/d9/3952e90f26e65356f31c60fc394efb26313167": "1401847c6f090e48e83740a00be1c303",
".git/objects/db/ebec1f1da6855802646dee13765b9b645d79e5": "f87ed6b728a39f35beb152343ff9aa9a",
".git/objects/de/ad6a4558ae191c1703646e7ceff60540a4a66b": "8d6d52c4f1c5c668b3c90655de46f069",
".git/objects/e1/1db3b262d569aeafa4b07ebc28ae1fa023bcbe": "0623b206c0960c84b402ef537dd4d4c6",
".git/objects/e5/44e09cf7661532cb8a8b4f643d7f8413c6cc7f": "f69dd2e89699ad023408a7578865e1be",
".git/objects/e8/cb9ed860fa934e14bee75ec18a0460444b584b": "b9d58bcb4eb53d36714ad42fea47b145",
".git/objects/e9/94225c71c957162e2dcc06abe8295e482f93a2": "2eed33506ed70a5848a0b06f5b754f2c",
".git/objects/ea/99f8990de53d7085fb9fc704ad2b2728a7c700": "c1065f1df5759d7094e0bf053a6a9351",
".git/objects/ea/d3a53c396194327511a1e835c5d58dd812c369": "fefe579c776e178be2c9ac1f03937ea1",
".git/objects/ed/db86055ae84afba8d24f4f920542511e0a11af": "09c2f22724c342f15542d542ef70098a",
".git/objects/ee/8b72f51015219cecd5478a024d9511be2fc18d": "25d1fb7a0403804df9cd7dac17f434c5",
".git/objects/ef/b875788e4094f6091d9caa43e35c77640aaf21": "27e32738aea45acd66b98d36fc9fc9e0",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/f3/709a83aedf1f03d6e04459831b12355a9b9ef1": "538d2edfa707ca92ed0b867d6c3903d1",
".git/objects/f3/d156fe338cf81df942efaf1e9259f142434402": "bbe7961a1e443e71ad6c937f7898be39",
".git/objects/f5/72b90ef57ee79b82dd846c6871359a7cb10404": "e68f5265f0bb82d792ff536dcb99d803",
".git/objects/fd/f0c6bd0029a5a0f7b19b32b5f7b11713eff642": "388b3bbb48988446e241c927db2cd922",
".git/refs/heads/main": "d8e9eb3f41cf3b5074842add2277a7cc",
".git/refs/heads/master": "6eb7344f6a3595e2363d59c44bea8fe6",
".git/refs/remotes/origin/main": "d8e9eb3f41cf3b5074842add2277a7cc",
"assets/AssetManifest.bin": "fe584cf4e8e01f0c4efc99279987fd86",
"assets/AssetManifest.bin.json": "ab9b85712123addac4dff04bb9d74e60",
"assets/AssetManifest.json": "49028c1b8f63c0210e41e3b6c82f7791",
"assets/assets/images/icon.png": "6656b1a337b1d765a40bcf9176baff81",
"assets/FontManifest.json": "ac3f70900a17dc2eb8830a3e27c653c3",
"assets/fonts/MaterialIcons-Regular.otf": "9f078b144f3e361132fd798ba949a409",
"assets/NOTICES": "3d4f8ee1d2bb80166e777b50d9507f99",
"assets/packages/awesome_notifications/test/assets/images/test_image.png": "c27a71ab4008c83eba9b554775aa12ca",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/syncfusion_flutter_datagrid/assets/font/FilterIcon.ttf": "b8e5e5bf2b490d3576a9562f24395532",
"assets/packages/syncfusion_flutter_datagrid/assets/font/UnsortIcon.ttf": "acdd567faa403388649e37ceb9adeb44",
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
"favicon.png": "6656b1a337b1d765a40bcf9176baff81",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"flutter_bootstrap.js": "37e5eb9437a235ccd6e0be0470dd9c32",
"icons/Icon-192.png": "6656b1a337b1d765a40bcf9176baff81",
"icons/Icon-512.png": "6656b1a337b1d765a40bcf9176baff81",
"icons/Icon-maskable-192.png": "6656b1a337b1d765a40bcf9176baff81",
"icons/Icon-maskable-512.png": "6656b1a337b1d765a40bcf9176baff81",
"index.html": "61e872fd389bb9bd0ef8eb1214f541ac",
"/": "61e872fd389bb9bd0ef8eb1214f541ac",
"main.dart.js": "23cb3516b53310b20818eb90cc41e5d6",
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
