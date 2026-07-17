const CACHE='ponto-v10f-'+Date.now().toString(36);
const ASSETS=['./','./index.html','./manifest.json'];

self.addEventListener('install',function(e){
  e.waitUntil(caches.open(CACHE).then(function(c){return c.addAll(ASSETS)}));
  self.skipWaiting(); /* Ativa imediatamente sem esperar fechar */
});

self.addEventListener('activate',function(e){
  e.waitUntil(
    caches.keys().then(function(keys){
      return Promise.all(keys.map(function(k){
        return caches.delete(k); /* Apaga TODOS os caches antigos */
      }));
    })
  );
  self.clients.claim(); /* Assume controle de todas as abas abertas */
});

/* Sempre busca da rede primeiro, cache só como fallback offline */
self.addEventListener('fetch',function(e){
  e.respondWith(
    fetch(e.request).catch(function(){
      return caches.match(e.request);
    })
  );
});
