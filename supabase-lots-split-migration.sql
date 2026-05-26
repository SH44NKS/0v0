alter table orders add column if not exists lotes_json jsonb;

alter table recurring_orders add column if not exists data_inicio date;

alter table recurring_orders drop constraint if exists recurring_orders_freq_check;
alter table recurring_orders add constraint recurring_orders_freq_check
  check (freq in ('diario', 'semanal', 'quinzenal', 'mensal'));
