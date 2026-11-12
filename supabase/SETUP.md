# Supabase setup

The site reads its products, projects, services and enquiries from a Supabase
project. This is how to stand one up from scratch (or rebuild it if a project is
ever lost).

## 1. Create the project

1. Create a project at [supabase.com](https://supabase.com) — region
   **Southeast Asia (Singapore)** is the closest to Nepal.
2. Save the database password somewhere safe.

## 2. Create the schema

Open **SQL Editor → New query**, paste the whole of
[`fresh-project.sql`](./fresh-project.sql) and press **Run**. It creates the
tables, roles, row-level security policies, the `site-images` storage bucket,
the enquiry rate limiter, and the seeded catalogue. It should finish with
*"Success. No rows returned"*.

Add every person who should be able to sign in to `owner_allowlist` at the top of
that file (`insert into public.owner_allowlist`). The signup trigger rejects any
email that is not listed, so the site cannot be registered on by strangers.

## 3. Create the owner account

Either sign up once at `/auth`, or create the user in
**Authentication → Users → Add user** (confirm the email). Then grant the admin
role — signup no longer grants it automatically, deliberately:

```sql
insert into public.user_roles (user_id, role)
select id, 'admin' from auth.users where email = 'you@example.com'
on conflict do nothing;
```

`/admin` checks this role on every load, so without it the owner sees
"this account doesn't have owner access".

## 4. Point the app at it

`Project Settings → API`:

| Value | Goes into |
|---|---|
| Project URL | `SUPABASE_URL` and `VITE_SUPABASE_URL` |
| Publishable key | `SUPABASE_PUBLISHABLE_KEY` and `VITE_SUPABASE_PUBLISHABLE_KEY` |
| Secret key | `SUPABASE_SERVICE_ROLE_KEY` (**server only**) |

Put the public values in `.env`, and the server-only values in `.dev.vars`
(both are gitignored). For the deployed worker:

```sh
npx wrangler secret put SUPABASE_URL --name kritis-kirti-staging
npx wrangler secret put SUPABASE_PUBLISHABLE_KEY --name kritis-kirti-staging
npx wrangler secret put SUPABASE_SERVICE_ROLE_KEY --name kritis-kirti-staging
```

Never put `SUPABASE_SERVICE_ROLE_KEY` in `.env`, in client code, or in git — it
bypasses every row-level security policy in the database.

## 5. Deploy

```sh
npm run deploy:staging
```

## Optional extras

- **Email notifications for enquiries** — set `RESEND_API_KEY`,
  `ENQUIRY_NOTIFICATION_TO` and `ENQUIRY_NOTIFICATION_FROM`. Without them
  enquiries are still saved and visible in `/admin`, just not emailed.
- **Spam protection** — set `VITE_TURNSTILE_SITE_KEY` and
  `TURNSTILE_SECRET_KEY` from Cloudflare Turnstile. A honeypot field and
  per-IP-hash rate limiting are already active without it.
