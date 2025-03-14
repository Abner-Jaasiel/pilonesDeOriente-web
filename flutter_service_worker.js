'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/COMMIT_EDITMSG": "4ed6ca28619e62385fec56384796782b",
".git/config": "97d7dc39d4ee18f1208094c029876123",
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
".git/index": "177ef3be942cb3c47a70bc3fc1c16508",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "bfec9548df0af0c9d70f2e8a198e04a3",
".git/logs/refs/heads/main": "291f46410946aac50c5d9fd96ae3613f",
".git/logs/refs/remotes/origin/main": "7ba4afc855f11997fbefe1392442162e",
".git/objects/0a/d9aacf504bce2e9f4287ac9e60af03c9bed21d": "f2d723274780a41bc1fd4ce99b212b1c",
".git/objects/0a/e695425ec5e0cdf0f0f7b291fd9b42d0265dac": "10355c05127321c6dd15d778895cbf83",
".git/objects/0e/836456ed1d8b654e9e9259a6bc3d667151e217": "00b4ad921412ea8f54d8264190d3b05b",
".git/objects/0e/a55f42503675b73c82c351c47dec1b055b42a9": "e3c669694e604d0a566e5771e26e40b9",
".git/objects/11/c902110bcc9edaf5c32073658e9d0b02005e7d": "60be9deb0ff0234ffcf2f4445220bb55",
".git/objects/15/3a8972ba828b6403e72b01c6e2531a62c9b722": "1fbd9ca3fdfae458fe77f274445c44a4",
".git/objects/1d/468b85698a60041b450286f31b3264b3bbd6f7": "5c8c497111befde32ac151f14cf92f85",
".git/objects/26/c52da095219b6609e1b2d63348ca8e85fd400e": "34198bdb13030b901020fb888a32e58c",
".git/objects/2c/bba23337fcfb108c529d21b641e0f64162c142": "456e376af922f954b369cdcdae9be036",
".git/objects/35/96d08a5b8c249a9ff1eb36682aee2a23e61bac": "e931dda039902c600d4ba7d954ff090f",
".git/objects/39/9e4567d42f7a6cc6eb4f2d834d5f17bb73368e": "380c96799324f07f7c634db78b90e8c2",
".git/objects/40/1184f2840fcfb39ffde5f2f82fe5957c37d6fa": "1ea653b99fd29cd15fcc068857a1dbb2",
".git/objects/42/b9caeab6521e1a01401c61a0cef99c64a7efc6": "e921148aa284a16d2ee1929f52b96f1d",
".git/objects/46/4ab5882a2234c39b1a4dbad5feba0954478155": "2e52a767dc04391de7b4d0beb32e7fc4",
".git/objects/4a/2b4bea553c0349bfbc0e812cae482c1230fede": "fd30fc36b8d969a4945ffa05e3442e6f",
".git/objects/53/3402c75429e6feaa7b8f92878ae2313dbdf2de": "63ab067b0b447b461fa3e8f58a1f23a9",
".git/objects/54/47e840e51c56ea9a07325306e613623f5a7b2a": "0069a1f879e86c97d2da5fd285893c1f",
".git/objects/56/e8e55ce73713ab0ec6c2d9bcfdeaba09a41eeb": "66a0afd9023bb6ce4a15ebafbc530634",
".git/objects/57/7946daf6467a3f0a883583abfb8f1e57c86b54": "846aff8094feabe0db132052fd10f62a",
".git/objects/58/e50b2ce4db60d4c88bf7dd5c824e952e947ae3": "6d099b123350cdddf06ef7474c8bce8b",
".git/objects/5f/bf1f5ee49ba64ffa8e24e19c0231e22add1631": "f19d414bb2afb15ab9eb762fd11311d6",
".git/objects/62/5af359467e7a2cef843dad79a50fb277caddc7": "1ca41c60814db314f2beff750453c78e",
".git/objects/62/6fee69059b9206078359498cc0d836400c8b38": "0641f2e2986d939be9f5d8c975889411",
".git/objects/64/e036058c9a481fdb16991422447623f90f8a1d": "a8b14f9af17821b53cdb9ce828a7a682",
".git/objects/6a/3d29424322f6f5069931d6c3c7db4d784cc1b9": "828d2d27f4724e5d864aaec627e6cf6f",
".git/objects/6b/88d1b6d1164c423e5dc149194ddc3c2912e6ef": "bffdccdce560586a668c78ac410cf3cf",
".git/objects/6b/9862a1351012dc0f337c9ee5067ed3dbfbb439": "85896cd5fba127825eb58df13dfac82b",
".git/objects/6d/0edf32ac6d5fa5bd99544fa9d0fe11afd35013": "b007b34b431f232fe0eb6d87817353fb",
".git/objects/6d/94fd04e42fa86dafc994d2d5fd89d64488c718": "401523aeebcd5d791aff80728894695e",
".git/objects/71/27003cb071c80dd7e1a6a3aee2176afe386f8c": "d989ab551c9616bec2e668a0d7f7c38e",
".git/objects/72/3d030bc89a4250e63d16b082affe1998618c3f": "e4299c419434fc51f64a5266659918fa",
".git/objects/78/e0e9ddb5701496c45878588f8d340f11645a9d": "a8a90d65af656ffae61b32a021326def",
".git/objects/79/767341ec0df33db59b2bc1851a6f771173e2cf": "2402783e6dd85a9f8951b3085a41e8f3",
".git/objects/7d/670b1d3eb418f9cc3bb84f5c29bfa7d33391e6": "7e05bb78da82a72235fcdae595a5a9c4",
".git/objects/82/423809c4f98fa0c9099a39c2df2c82c2a9b33d": "f3a122f76329e6f352437e7cd42b8b54",
".git/objects/85/617f2b3e1335c1541f098203cfcb6795a4afde": "f790c69dcb88c094576532ceb51a976b",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/8a/51a9b155d31c44b148d7e287fc2872e0cafd42": "9f785032380d7569e69b3d17172f64e8",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/8b/2dc663a543f1cb14ee7997289fab33d1b6a6a9": "b26796a867d641893279bccb0a6960fc",
".git/objects/8f/0887804b0f1b4abca50a2ba3cc36afc0764f1e": "4bfad06e00ae411f530cc6d41c2d5888",
".git/objects/8f/c8be62f202c40e7d3e2e16242fb065cfc4e1a7": "6fda1b80da67a8d96186cf8ab8b24087",
".git/objects/91/4a40ccb508c126fa995820d01ea15c69bb95f7": "8963a99a625c47f6cd41ba314ebd2488",
".git/objects/98/436d2e43c18b4d61b5c75a63cfb2a5e2c23924": "0c7e8219e5c669d7f933db9f80c27a72",
".git/objects/9a/fbd49d7aa440e432bf8d9a8c08d7a57aad3484": "80c6cf1fe005ff6cbfc07e02fce919d4",
".git/objects/9b/e2e2101748de33aa8cd7e84d68171404e528aa": "c8cc90e0e5ee269a56432a9502873536",
".git/objects/a1/aff37cbd402560baa4a29ab79ad4719b943720": "19aaf8245fd2e44838b020f9d78c2685",
".git/objects/a5/de584f4d25ef8aace1c5a0c190c3b31639895b": "9fbbb0db1824af504c56e5d959e1cdff",
".git/objects/a8/8c9340e408fca6e68e2d6cd8363dccc2bd8642": "11e9d76ebfeb0c92c8dff256819c0796",
".git/objects/a9/0f28e2bc0341b553105cd9e6f11386cce41e49": "77ec7ff5bcc4f5636259c0e944093fb2",
".git/objects/a9/4f3ee0f382984701c1c8a2a3638cae34930040": "105c48b2dcbb474ff5b315f554f3fa62",
".git/objects/b4/8cd326731d270571aa8e9ca4f33121dc79dea8": "2b7daa70e0425ad3f47fe8cf3877b58a",
".git/objects/b7/34bb5721f7ac4f7e99862872e15e7c383bff06": "e0090831291203539a40619660772570",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b8/b79e6f95193be1d8565ac6a377d14bdd960d2a": "afdbb064932f09c3d733e3e3166b7920",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/be/275dcc29ac2382ec9f70a18817faa7fb20589a": "4659f4360de35296d1435cba9f3f88cf",
".git/objects/bf/4eba6554b8cf17c27996cc1a5af65760112c2c": "aa16c482b0598bbfa80142289aac6ca2",
".git/objects/c3/ad3bcb94a477f673d97c4400018dea419c6792": "7b6062ce5ed0ea1cd2efb97c606be28b",
".git/objects/c4/8cbe7e1eb623ace7271254e9ba9f5baa1ccd9a": "be79409bf6fd587e1c0e5ecbebce7fea",
".git/objects/c7/14de35a23fd0f5a06067a915e494237f3f25c8": "b627527b56574280b898e2f177d37271",
".git/objects/c7/735e526a7e82c82e5c00c619f7d304cde9e1b2": "b57932e0aebc296b84cce00a220ac62f",
".git/objects/ca/d65b01636d851b34a38174bd121ca87ea57e4d": "fe8ec052daf2f6964ea22360e48094e3",
".git/objects/cc/829c696238f25db7e2ea816d32a1d8696bcef9": "f63eeae6b21b33b1c6ec54ef10da8d98",
".git/objects/d0/50f4a9869b39650fcd5d0db8a7e3ec082e4ce7": "1726b67812908579193bfd691f9879d5",
".git/objects/d3/4a1a5af8e9c5babc9837502828d5ae84027b16": "463b1060b0321b393956b828b349ef6c",
".git/objects/d3/d7ee3e54a005e15b9aaf9f81801302cb22d8c1": "577d34b7a01d6fcbb3c59ab732e15f5d",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/d7/2b18d0a63de7aa106bcec74f6c1d8ced99ce05": "35e6b1be6080b63d2dc471b789e61fbe",
".git/objects/d7/7cfefdbe249b8bf90ce8244ed8fc1732fe8f73": "9c0876641083076714600718b0dab097",
".git/objects/d9/3952e90f26e65356f31c60fc394efb26313167": "1401847c6f090e48e83740a00be1c303",
".git/objects/db/ebec1f1da6855802646dee13765b9b645d79e5": "f87ed6b728a39f35beb152343ff9aa9a",
".git/objects/de/c4528da9b18ba7dd89ba2cc37824aefa09fbe1": "b60f2c2d8db5f38d605242951877601b",
".git/objects/e2/1e1e901ef598417794105c51f2b8f4e13a8d8b": "ccc85f9bb8f5c329ef31c003212576da",
".git/objects/e7/d77270602189959d4967d338d40a3ba66ab9aa": "13af1888725495e9702af890f1ebf8ed",
".git/objects/e8/8eda7e8b50c96bcf2ad839c48de45aae7a092b": "7ca041d1dfa1f8fea24112305480b4a2",
".git/objects/e8/cb9ed860fa934e14bee75ec18a0460444b584b": "b9d58bcb4eb53d36714ad42fea47b145",
".git/objects/e9/94225c71c957162e2dcc06abe8295e482f93a2": "2eed33506ed70a5848a0b06f5b754f2c",
".git/objects/e9/f201ffd6d63f67ad4bfcf2456db55eb15b484a": "f51cd0e07c9f6b032b6472b9cd0b0f40",
".git/objects/ea/644298b14798dcd61f6382c82e37df240d49c6": "deae0cc79bc78c090817ff6b071c7128",
".git/objects/ea/e6352f25c697f874330b47059413c20578b6d7": "60497153dd4986db13f3cb3768e3fd68",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/ee/8b72f51015219cecd5478a024d9511be2fc18d": "25d1fb7a0403804df9cd7dac17f434c5",
".git/objects/ef/b875788e4094f6091d9caa43e35c77640aaf21": "27e32738aea45acd66b98d36fc9fc9e0",
".git/objects/f0/2f52cf459329d3812b662e5f91dbda6110e6e6": "755f4cea985d11705480cefcdb4cbeed",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/f3/709a83aedf1f03d6e04459831b12355a9b9ef1": "538d2edfa707ca92ed0b867d6c3903d1",
".git/objects/f5/72b90ef57ee79b82dd846c6871359a7cb10404": "e68f5265f0bb82d792ff536dcb99d803",
".git/objects/f7/4b25db38c7d27019b1d40d0785cbf25dbf43a1": "221fd69196706bdba8ba3b5623ca80c6",
".git/objects/fb/d3fb121e2d3cc97e951e706a2fdbacdc0b1c04": "3f665175a007aecb08e1c783a6a59a3c",
".git/objects/pack/pack-88ae0d3da256c29732b2189b771af91ea988004b.idx": "82bede209a221302a6f1f02bb28539ae",
".git/objects/pack/pack-88ae0d3da256c29732b2189b771af91ea988004b.pack": "fbf07d60bfbdc153773b878ae126be51",
".git/objects/pack/pack-88ae0d3da256c29732b2189b771af91ea988004b.rev": "8a1a8ec825e3aa4cf557327448b2e2fb",
".git/ORIG_HEAD": "8a674abc74b41922f12ba3d9262ce590",
".git/refs/heads/main": "0dcf3fd6bc1cbf2bbee1df92bef39f76",
".git/refs/remotes/origin/main": "0dcf3fd6bc1cbf2bbee1df92bef39f76",
"assets/AssetManifest.bin": "ff0d4119c0f62ae4f2cae6654f4eec4a",
"assets/AssetManifest.bin.json": "d2a2c282db984e5d73b8209e73f0b5d9",
"assets/AssetManifest.json": "ba82af29e798792e68b2a00834b80e43",
"assets/assets/images/icon.png": "6656b1a337b1d765a40bcf9176baff81",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "44db19564d131e108dfc2f9e6a6a4847",
"assets/NOTICES": "f710059f3e02b0afc456ff664b904ec1",
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
"favicon.png": "6656b1a337b1d765a40bcf9176baff81",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"flutter_bootstrap.js": "689e39ece5814d5407d1c742d09ba9e7",
"icons/Icon-192.png": "6656b1a337b1d765a40bcf9176baff81",
"icons/Icon-512.png": "6656b1a337b1d765a40bcf9176baff81",
"icons/Icon-maskable-192.png": "6656b1a337b1d765a40bcf9176baff81",
"icons/Icon-maskable-512.png": "6656b1a337b1d765a40bcf9176baff81",
"index.html": "61e872fd389bb9bd0ef8eb1214f541ac",
"/": "61e872fd389bb9bd0ef8eb1214f541ac",
"main.dart.js": "e5dc5eb0148bd0b5a190b19d5ea7106b",
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
