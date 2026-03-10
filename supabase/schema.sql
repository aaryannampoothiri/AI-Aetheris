-- Run this in Supabase SQL Editor

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text not null unique,
  name text not null,
  username text not null unique,
  nickname text,
  bio text,
  profile_picture text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.workspaces (
  user_id uuid primary key references auth.users(id) on delete cascade,
  workspace jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists profiles_set_updated_at on public.profiles;
create trigger profiles_set_updated_at
before update on public.profiles
for each row execute function public.set_updated_at();

drop trigger if exists workspaces_set_updated_at on public.workspaces;
create trigger workspaces_set_updated_at
before update on public.workspaces
for each row execute function public.set_updated_at();

alter table public.profiles enable row level security;
alter table public.workspaces enable row level security;

-- Users can read and update only their own profile
create policy if not exists "profiles_select_own"
on public.profiles
for select
using (auth.uid() = id);

create policy if not exists "profiles_insert_own"
on public.profiles
for insert
with check (auth.uid() = id);

create policy if not exists "profiles_update_own"
on public.profiles
for update
using (auth.uid() = id)
with check (auth.uid() = id);

-- Users can read and write only their own workspace
create policy if not exists "workspaces_select_own"
on public.workspaces
for select
using (auth.uid() = user_id);

create policy if not exists "workspaces_insert_own"
on public.workspaces
for insert
with check (auth.uid() = user_id);

create policy if not exists "workspaces_update_own"
on public.workspaces
for update
using (auth.uid() = user_id)
with check (auth.uid() = user_id);
