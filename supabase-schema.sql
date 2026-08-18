create table if not exists public.finance_snapshots (
  id text primary key,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.finance_snapshots enable row level security;

drop policy if exists "finance snapshots select authenticated" on public.finance_snapshots;
drop policy if exists "finance snapshots insert authenticated" on public.finance_snapshots;
drop policy if exists "finance snapshots update authenticated" on public.finance_snapshots;

create policy "finance snapshots select authenticated"
on public.finance_snapshots
for select
to authenticated
using (true);

create policy "finance snapshots insert authenticated"
on public.finance_snapshots
for insert
to authenticated
with check (true);

create policy "finance snapshots update authenticated"
on public.finance_snapshots
for update
to authenticated
using (true)
with check (true);

insert into public.finance_snapshots (id, data, updated_at)
values (
  'ambrosio-financeiro',
  '{
    "settings": {
      "familyName": "Controle financeiro Sr&Sra Ambrosio",
      "monthlyGoal": 0,
      "note": ""
    },
    "transactions": [],
    "shopping": []
  }'::jsonb,
  now()
)
on conflict (id) do update
set data = excluded.data,
    updated_at = excluded.updated_at;
