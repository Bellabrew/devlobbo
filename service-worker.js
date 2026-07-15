// Dev.Lobbo — service worker "kill switch"
// Este arquivo existe apenas para desinstalar qualquer versão antiga de
// service worker que possa ter ficado presa no navegador de algum visitante
// (registrada por uma versão anterior do site) e limpar caches antigos,
// garantindo que a versão mais recente do site seja sempre buscada da rede.

self.addEventListener('install', () => {
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    (async () => {
      // Limpa todos os caches criados por versões anteriores deste service worker
      const cacheNames = await caches.keys();
      await Promise.all(cacheNames.map((name) => caches.delete(name)));

      // Assume o controle de todas as abas abertas imediatamente
      await self.clients.claim();

      // Desinstala este próprio service worker — a partir de agora,
      // o site passa a funcionar normalmente, sempre buscando da rede.
      await self.registration.unregister();

      // Força um reload das páginas abertas para que carreguem a versão
      // atual do site diretamente da rede, sem qualquer service worker.
      const clientsList = await self.clients.matchAll({ type: 'window' });
      clientsList.forEach((client) => client.navigate(client.url));
    })()
  );
});

// Sempre busca da rede — nunca serve nada do cache enquanto este
// SW temporário ainda estiver ativo (janela curta antes de se desinstalar).
self.addEventListener('fetch', (event) => {
  event.respondWith(fetch(event.request));
});
