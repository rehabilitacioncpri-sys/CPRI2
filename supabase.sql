create table if not exists public.patients (
 id uuid primary key default gen_random_uuid(), user_id uuid not null default auth.uid(),
 name text not null, phone text, admission_date date default current_date,
 diagnosis text, type text not null check(type in ('Nuevo','Seguimiento','Paquete')),
 package_sessions integer default 0, package_used integer default 0, created_at timestamptz default now()
);
create table if not exists public.attendance (
 id uuid primary key default gen_random_uuid(), user_id uuid not null default auth.uid(),
 patient_id uuid references public.patients(id) on delete cascade, patient_name text not null,
 date date not null default current_date, type text not null check(type in ('Nuevo','Seguimiento','Paquete')),
 notes text, created_at timestamptz default now()
);
alter table public.patients enable row level security;
alter table public.attendance enable row level security;
create policy "users own patients" on public.patients for all using (auth.uid()=user_id) with check(auth.uid()=user_id);
create policy "users own attendance" on public.attendance for all using (auth.uid()=user_id) with check(auth.uid()=user_id);
