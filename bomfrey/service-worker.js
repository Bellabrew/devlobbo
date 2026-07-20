// BOMFREY Insight — service worker
// Estratégia: SEMPRE busca a versão mais nova na rede primeiro.
// Só usa a cópia salva (cache) se o dispositivo estiver offline.
// Isso existe apenas para permitir "instalar" o site como app — não há
// funcionalidade offline real, já que o app depende de internet para verificar fatos.

const CACHE_NAME = 'bomfrey-insight-v1';

self.addEventListener('install', (event) => {
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((names) =>
      Promise.all(
        names.filter((n) => n !== CACHE_NAME).map((n) => caches.delete(n))
      )
    )
  );
  self.clients.claim();
});

self.addEventListener('fetch', (event) => {
  if (event.request.method !== 'GET') return;

  event.respondWith(
    fetch(event.request)
      .then((response) => {
        const copy = response.clone();
        caches.open(CACHE_NAME).then((cache) => cache.put(event.request, copy));
        return response;
      })
      .catch(() => caches.match(event.request))
  );
});
