create table if not exists recurring_orders (
  id bigint primary key,
  cliente text not null,
  qtd integer not null check (qtd > 0),
  valor numeric(12,2) not null default 0,
  desconto numeric(12,2) not null default 0,
  rev text not null references app_users(id) on update cascade,
  pgto text not null default 'pix',
  obs text default '',
  freq text not null check (freq in ('diario', 'semanal', 'quinzenal', 'mensal')),
  dia_semana integer check (dia_semana between 0 and 6),
  dia_mes integer check (dia_mes between 1 and 31),
  data_inicio date,
  ativo boolean not null default true,
  created_at timestamptz not null default now()
);

alter table recurring_orders enable row level security;

drop policy if exists "0v0 public app read recurring" on recurring_orders;
drop policy if exists "0v0 public app write recurring" on recurring_orders;

create policy "0v0 public app read recurring" on recurring_orders for select using (true);
create policy "0v0 public app write recurring" on recurring_orders for all using (true) with check (true);
