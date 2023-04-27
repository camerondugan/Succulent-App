'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "canvaskit/canvaskit.js": "97937cb4c2c2073c968525a3e08c86a3",
"canvaskit/canvaskit.wasm": "3de12d898ec208a5f31362cc00f09b9e",
"canvaskit/profiling/canvaskit.js": "c21852696bc1cc82e8894d851c01921a",
"canvaskit/profiling/canvaskit.wasm": "371bc4e204443b0d5e774d64a046eb99",
"flutter.js": "a85fcf6324d3c4d3ae3be1ae4931e9c5",
"main.dart.js": "ce20fed6d5b04573db6e20e9e0597b25",
"version.json": "529b92530f145e6974f6841bae72036f",
"assets/assets/DeadPlant.png": "13400231fc3018432b8e06605d6ceb0e",
"assets/assets/NoPlant.png": "a354dc9da55762bc459af14cecb9dda3",
"assets/assets/Plant001Full.png": "2807ddf049c73686d1622521023049d4",
"assets/assets/Plant001Medium.png": "367f6f55c8b3750a289cae6388ff80cb",
"assets/assets/Plant001Sprout.png": "229b2f6634a3a7bc0a5ae2754e7e2d3f",
"assets/assets/Plant002.xcf": "a24fdab119a122e857fb79aa4fac7789",
"assets/assets/Plant002Full.png": "508f4d69590c75b648fbc27c07abf181",
"assets/assets/Plant002Medium.png": "04a837d718c971c040254c02528dfaf8",
"assets/assets/Plant002Medium.xcf": "477466bb35a4c0423d91910386f3b1e2",
"assets/assets/Plant002Sprout.png": "cf3205d99b4f7373bd5c1f482b9f8a9d",
"assets/assets/Plant002Sprout.xcf": "6d6f934ff3536cd80434da67bb294f9f",
"assets/assets/Plant003Full.png": "36f2e7174f8d213af47bab6c5a39dfd9",
"assets/assets/Plant003Medium.png": "8a3ace79a0bb902af3e5ade35dd1fb73",
"assets/assets/Plant003Sprout.png": "ebd640a18b93b19b3a8ee88d7f576270",
"assets/assets/Plant004Full.png": "1d0771342e22731ee1699f319d36ee42",
"assets/assets/Plant004Medium.png": "303a9aacbc77690ccbd2ca00d0c3ebab",
"assets/assets/Plant004Sprout.png": "a93f020e383dc6d085db81fe2259a23b",
"assets/assets/Plant005.xcf": "d3b531fe2d130f47268cf03ee6c6241d",
"assets/assets/Plant005Full.png": "5f8bf6da0424c2b9403eb1f452eb0b51",
"assets/assets/Plant005Medium.png": "3570ea920c8dc38438360d5cac93c7a6",
"assets/assets/Plant005Sprout.png": "36ab49fff4fee759c47f920937c4e967",
"assets/assets/PlantCoin.png": "2d9e53d350f2a430836d62c441ad7850",
"assets/assets/PlantTemplatexcf.xcf": "d3b531fe2d130f47268cf03ee6c6241d",
"assets/assets/Store.png": "2e2bbfd3ccd01a672ba2ce3e3434c0ac",
"assets/assets/plantbg.jpg": "217f7e5609d2db5bdfff7614f1a0f1d7",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/AssetManifest.json": "75934a6e305be5de13d20922882a2693",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/NOTICES": "e3a3ca2fda65cb12dcebb8f7926ca3f3",
"favicon.png": "92a37bc28ac8464dc023df18e0e2336f",
"icons/Icon-192.png": "0af847587c0101516dcb01f1c5785c99",
"icons/Icon-512.png": "f7e547ecad452d3eb2c28d65c36283c0",
"icons/Icon-maskable-192.png": "0af847587c0101516dcb01f1c5785c99",
"icons/Icon-maskable-512.png": "f7e547ecad452d3eb2c28d65c36283c0",
"index.html": "ae8ad9b2c1b0e61732b0a6100dade8f2",
"/": "ae8ad9b2c1b0e61732b0a6100dade8f2",
"manifest.json": "8b2433737cbf6f5d658043537d9d5646"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/AssetManifest.json",
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
