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

create table if not exists recurring_orders (
  id bigint primary key,
  cliente text not null,
  qtd integer not null check (qtd > 0),
  valor numeric(12,2) not null default 0,
  desconto numeric(12,2) not null default 0,
  rev text not null references app_users(id) on update cascade,
  pgto text not null default 'pix',
  obs text default '',
  freq text not null check (freq in ('diario', 'semanal', 'mensal')),
  dia_semana integer check (dia_semana between 0 and 6),
  dia_mes integer check (dia_mes between 1 and 31),
  ativo boolean not null default true,
  created_at timestamptz not null default now()
);

alter table app_users enable row level security;
alter table lots enable row level security;
alter table orders enable row level security;
alter table recurring_orders enable row level security;

create policy "0v0 public app read users" on app_users for select using (true);
create policy "0v0 public app write users" on app_users for all using (true) with check (true);
create policy "0v0 public app read lots" on lots for select using (true);
create policy "0v0 public app write lots" on lots for all using (true) with check (true);
create policy "0v0 public app read orders" on orders for select using (true);
create policy "0v0 public app write orders" on orders for all using (true) with check (true);
create policy "0v0 public app read recurring" on recurring_orders for select using (true);
create policy "0v0 public app write recurring" on recurring_orders for all using (true) with check (true);

insert into app_users (id, name, username, pass_hash, role)
values
  ('iuri', 'Iuri', 'iuri', 'ebec91fc7c76e182463b7f8ea98e1745a67bcfe9ba1f92f097b845852bd0eb61', 'admin')
on conflict (id) do nothing;
