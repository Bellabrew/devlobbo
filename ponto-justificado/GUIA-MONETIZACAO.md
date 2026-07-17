# 💰 Guia de Monetização — Ponto Justificado

## OPÇÃO 1: Google AdSense (versão Web/PWA)

### Passo 1 — Ter domínio próprio
- Compre `pontojustificado.com.br` em registro.br (~R$40/ano)
- Ou use subdomínio: `ponto.devlobbo.com`

### Passo 2 — Política de Privacidade
- Arquivo `privacidade.html` já está incluído ✅
- Adicione link para ela no rodapé do app

### Passo 3 — Cadastrar no AdSense
1. Acesse: https://adsense.google.com
2. Adicione seu site
3. Cole o código de verificação no <head> do index.html
4. Aguarde aprovação (1-2 semanas)

### Passo 4 — Ativar anúncios no app
No arquivo `index.html`:

1. **Descomente o script do AdSense** no <head>:
```html
<script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-SEU_ID" crossorigin="anonymous"></script>
```

2. **Em cada banner** (busque por "AdSense: substitua"):
   - Substitua `ca-pub-XXXXXXXXXXXXXXXX` pelo seu Publisher ID
   - Substitua `XXXXXXXXXX` pelo Ad Slot ID de cada banner
   - Descomente o bloco `<ins class="adsbygoogle"...>`
   - Comente ou remova o div placeholder

---

## OPÇÃO 2: Google AdMob (Play Store / App Android)

### Ferramenta recomendada: Capacitor (gratuito)

O Capacitor converte o PWA em app Android nativo.

### Passo 1 — Instalar Capacitor
```bash
npm install @capacitor/core @capacitor/cli @capacitor/android
npm install @capacitor-community/admob
npx cap init "Ponto Justificado" "com.devlobbo.pontojustificado"
npx cap add android
```

### Passo 2 — Configurar AdMob
No arquivo `capacitor.config.ts`:
```typescript
import { CapacitorConfig } from '@capacitor/cli';
const config: CapacitorConfig = {
  appId: 'com.devlobbo.pontojustificado',
  appName: 'Ponto Justificado',
  webDir: '.',
  plugins: {
    AdMob: {
      appId: 'ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX', // seu App ID do AdMob
    }
  }
};
export default config;
```

### Passo 3 — IDs do AdMob
1. Crie conta em: https://admob.google.com
2. Crie um app Android
3. Crie um bloco de anúncio do tipo "Banner"
4. Anote o App ID e o Ad Unit ID

### Passo 4 — Gerar APK
```bash
npx cap sync android
npx cap open android
# No Android Studio: Build > Generate Signed Bundle/APK
```

### Passo 5 — Play Store
1. Crie conta em: https://play.google.com/console (~$25 única vez)
2. Crie novo app → faça upload do APK/AAB
3. Preencha ficha do app (use as descrições abaixo)

---

## 📝 Textos para a ficha da Play Store

**Título:** Ponto Justificado — Cartão Ponto Digital

**Descrição curta:**
Justifique faltas e atrasos com assinatura digital. Gratuito para empresas e órgãos públicos.

**Descrição completa:**
O Ponto Justificado é um sistema eletrônico completo para gerenciamento de justificativas de cartão ponto.

✅ Ideal para empresas, prefeituras, hospitais e instituições públicas
✅ Fluxo completo: Funcionário → Superior → RH
✅ Assinatura digital integrada
✅ Geração de PDF profissional
✅ Funciona offline
✅ Backup de dados
✅ 100% gratuito

**Categoria:** Produtividade / Empresas
**Classificação:** Livre (sem conteúdo inadequado)

---

## 📊 Estimativa de receita

| Usuários/dia | AdSense (RPM ~R$3) | AdMob (RPM ~R$5) |
|---|---|---|
| 100 | ~R$ 9/mês | ~R$ 15/mês |
| 500 | ~R$ 45/mês | ~R$ 75/mês |
| 2.000 | ~R$ 180/mês | ~R$ 300/mês |
| 10.000 | ~R$ 900/mês | ~R$ 1.500/mês |

