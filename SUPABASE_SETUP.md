# 0v0 - Configuracao do Supabase

## 1. Criar o projeto

Crie um projeto no Supabase e abra o SQL Editor.

## 2. Criar as tabelas

Copie todo o conteudo de `supabase-schema.sql`, cole no SQL Editor e execute.

Isso cria:

- `app_users`
- `lots`
- `orders`
- usuario admin `iuri / 1234`
- nenhum pedido, lote ou revendedor de teste

## 3. Configurar as chaves

No Supabase, va em:

`Project Settings > API`

Copie:

- `Project URL`
- `anon public key`

Depois edite `config.js`:

```js
window.OVO_CONFIG = {
  SUPABASE_URL: 'https://SEU-PROJETO.supabase.co',
  SUPABASE_ANON_KEY: 'SUA_CHAVE_ANON_PUBLICA'
};
```

## 4. Publicar

Depois de alterar `config.js`, publique no GitHub Pages novamente.

Enquanto `config.js` estiver vazio, o app roda em modo demo usando o navegador local.

## Aviso importante

Esta primeira versao funcional usa Supabase direto pelo frontend para validar o produto rapidamente. Para producao final com seguranca completa, o ideal e migrar permissoes sensiveis para backend/API.
