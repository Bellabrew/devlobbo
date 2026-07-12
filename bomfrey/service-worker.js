const CACHE_NAME = 'bomfrey-insight-v1';

// Arquivos essenciais que devem funcionar mesmo offline
const CORE_ASSETS = [
  '/bomfrey/',
  '/bomfrey/index.html',
  '/bomfrey/manifest.json',
  '/bomfrey/icons/icon-192x192.png',
  '/bomfrey/icons/icon-512x512.png'
];

// Instala o service worker e guarda os arquivos essenciais em cache
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(CORE_ASSETS))
  );
  self.skipWaiting();
});

// Remove caches antigos quando uma nova versão é publicada
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(
        keys.filter((key) => key !== CACHE_NAME).map((key) => caches.delete(key))
      )
    )
  );
  self.clients.claim();
});

// Estratégia: tenta rede primeiro (conteúdo sempre atualizado);
// se não houver internet, cai pro cache; se não tiver no cache, mostra fallback.
self.addEventListener('fetch', (event) => {
  // Nunca cachear chamadas de API - análises têm que ser sempre em tempo real
  if (event.request.url.includes('/api/')) {
    return;
  }

  event.respondWith(
    fetch(event.request)
      .then((response) => {
        const responseClone = response.clone();
        caches.open(CACHE_NAME).then((cache) => cache.put(event.request, responseClone));
        return response;
      })
      .catch(() => caches.match(event.request).then((cached) => cached || caches.match('/bomfrey/index.html')))
  );
});
