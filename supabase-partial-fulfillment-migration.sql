alter table orders add column if not exists data_prev_pagamento date;
alter table orders add column if not exists qtd_paga integer not null default 0;
alter table orders add column if not exists qtd_entregue integer not null default 0;

update orders
set
  qtd_paga = case when data_pago is not null or status = 'pago' then qtd else qtd_paga end,
  qtd_entregue = case when status in ('entregue', 'pago') then qtd else qtd_entregue end
where qtd_paga = 0 or qtd_entregue = 0;
