create table if not exists error_logs (
  id uuid primary key default gen_random_uuid(),

  -- User may be null (if not logged in)
  user_id uuid references auth.users(id) on delete set null,

  app_version text,
  platform text,       -- android / web / watch / ios
  os_version text,
  device_model text,

  screen_name text,
  error_message text not null,
  stacktrace text,

  extra_data jsonb default '{}'::jsonb,

  created_at timestamptz default now()
);
