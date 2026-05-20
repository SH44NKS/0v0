create table if not exists app_users (
  id text primary key,
  name text not null,
  username text unique not null,
  pass_hash text not null,
  role text not null default 'rev' check (role in ('admin', 'rev')),
  created_at timestamptz not null default now()
);

create table if not exists lots (
  id bigint primary key,
  data date not null,
  qtd integer not null check (qtd > 0),
  obs text default '',
  created_at timestamptz not null default now()
);

create table if not exists orders (
  id bigint primary key,
  cliente text not null,
  qtd integer not null check (qtd > 0),
  valor numeric(12,2) not null default 0,
  desconto numeric(12,2) not null default 0,
  status text not null check (status in ('solicitado', 'pedido', 'entregue', 'pago')),
  rev text not null references app_users(id) on update cascade,
  data date not null,
  data_pago date,
  pgto text not null default 'pix',
  obs text default '',
  lote_id bigint references lots(id),
  created_at timestamptz not null default now()
);

alter table app_users enable row level security;
alter table lots enable row level security;
alter table orders enable row level security;

create policy "0v0 public app read users" on app_users for select using (true);
create policy "0v0 public app write users" on app_users for all using (true) with check (true);
create policy "0v0 public app read lots" on lots for select using (true);
create policy "0v0 public app write lots" on lots for all using (true) with check (true);
create policy "0v0 public app read orders" on orders for select using (true);
create policy "0v0 public app write orders" on orders for all using (true) with check (true);

insert into app_users (id, name, username, pass_hash, role)
values
  ('iuri', 'Iuri', 'iuri', 'ebec91fc7c76e182463b7f8ea98e1745a67bcfe9ba1f92f097b845852bd0eb61', 'admin'),
  ('thaissa', 'Thaissa', 'thaissa', 'ebec91fc7c76e182463b7f8ea98e1745a67bcfe9ba1f92f097b845852bd0eb61', 'rev'),
  ('alisson', 'Alisson', 'alisson', 'ebec91fc7c76e182463b7f8ea98e1745a67bcfe9ba1f92f097b845852bd0eb61', 'rev'),
  ('nany', 'Nany', 'nany', 'ebec91fc7c76e182463b7f8ea98e1745a67bcfe9ba1f92f097b845852bd0eb61', 'rev')
on conflict (id) do nothing;

insert into lots (id, data, qtd, obs)
values
  (1, '2026-05-15', 40, 'Lote principal'),
  (2, '2026-04-20', 8, 'Lote anterior'),
  (3, '2026-03-10', 2, 'Lote antigo')
on conflict (id) do nothing;

insert into orders (id, cliente, qtd, valor, desconto, status, rev, data, data_pago, pgto, obs, lote_id)
values
  (1, 'Mariana', 2, 50, 0, 'solicitado', 'thaissa', '2026-05-15', null, 'pix', '', null),
  (2, 'Roberto', 4, 95, 5, 'entregue', 'alisson', '2026-05-14', null, 'dinheiro', 'Vai pagar na sexta', 1),
  (3, 'Fernanda', 1, 25, 0, 'pago', 'thaissa', '2026-05-12', '2026-05-13', 'pix', '', 1),
  (4, 'Joana', 3, 75, 0, 'pago', 'nany', '2026-05-08', '2026-05-09', 'dinheiro', '', 1),
  (5, 'Beto', 2, 45, 5, 'pedido', 'thaissa', '2026-05-05', null, 'fiado', 'Pagou metade', 1),
  (6, 'Clara', 5, 125, 0, 'pago', 'alisson', '2026-04-20', '2026-04-21', 'pix', '', 2),
  (7, 'Larissa', 2, 50, 0, 'pago', 'nany', '2026-03-10', '2026-03-11', 'dinheiro', '', 3),
  (8, 'Mariana', 3, 75, 0, 'pago', 'thaissa', '2026-04-28', '2026-04-29', 'pix', '', 2)
on conflict (id) do nothing;
