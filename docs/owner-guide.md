# Owner guide — KRITI'S KIRTI

Live staging site: <https://kritis-kirti-staging.kritis-kirti.workers.dev>

This is the day-to-day manual for running the site. For rebuilding the Supabase
project from scratch, see [`supabase/SETUP.md`](../supabase/SETUP.md).

## Sign in

Go to `/auth` and sign in with the owner account. Once signed in you land on
`/admin`; the header also shows a **Studio** link. If you see _"This account
doesn't have owner access"_, the account needs the `admin` role described in
`SETUP.md`.

> The account was created with a temporary password. Change it in Supabase
> **Authentication → Users** after your first login.

## Enquiries

- All enquiries appear in `/admin` under **Enquiries**, newest first.
- The **Enquiries** tab shows a number badge for messages not yet handled.
- After replying, switch **Replied / handled** on that enquiry. The badge
  updates immediately and the card dims.
- Enquiries are saved in Supabase even if email notifications are switched off.

**Email notifications are not configured yet.** The code that sends them is
already in `src/lib/content.functions.ts`; it activates as soon as the three
Worker secrets below are set. Until then, check `/admin` for new messages.

## Products, projects and services

Use the **Products**, **Projects** and **Services** tabs in `/admin`.

- **Add new** creates a row; **Edit** changes it; the trash icon deletes it.
- **Web address (slug)** is generated from the name if left blank. Changing a
  slug changes the link used by the photo fallback, so leave it alone unless you
  know what you're doing.
- **Price** left empty renders as _Price on request_.
- **Visible on site** controls whether the row appears to the public.
- **Show on home page** adds a product to the home grid.
- **Order** controls position; lower numbers come first.
- **Photo / Cover photo / Gallery photos** upload straight to Supabase Storage
  (`site-images`). Square images around 1000–1200 px work best. Bundled starter
  photos are used automatically when a row has no uploaded photo.

Changes are live as soon as they save — no deploy needed.

## Text that needs a deploy

These live in source files, not in the database:

| What                                                                 | File                             |
| -------------------------------------------------------------------- | -------------------------------- |
| Phone, WhatsApp, address, social links, enquiry email, canonical URL | `src/lib/site.ts`                |
| Contact page wording                                                 | `src/routes/contact.tsx`         |
| About page wording                                                   | `src/routes/about.tsx`           |
| Services wording is in the database, except the page hero            | `src/routes/services.tsx`        |
| Footer links                                                         | `src/components/site/Footer.tsx` |

After editing one, run `npm run deploy:staging`.

## Turn on enquiry emails

1. Create a [Resend](https://resend.com) account and verify the domain you want
   to send from.
2. Add the secrets to the Worker (run these from the project folder):

   ```sh
   npx wrangler secret put RESEND_API_KEY --name kritis-kirti-staging
   npx wrangler secret put ENQUIRY_NOTIFICATION_TO --name kritis-kirti-staging
   npx wrangler secret put ENQUIRY_NOTIFICATION_FROM --name kritis-kirti-staging
   ```

   `ENQUIRY_NOTIFICATION_TO` can hold several addresses separated by commas.
   `ENQUIRY_NOTIFICATION_FROM` must be a verified sender in Resend, for example
   `KRITI'S KIRTI <enquiries@your-domain.com>`.

3. Run `npm run deploy:staging`, then submit a test enquiry and confirm the
   email arrives and the row still appears in `/admin`.

## Turn on Cloudflare Turnstile (optional spam protection)

The form already has a honeypot and one-hour rate limiting. For a visible
challenge:

1. Create a Turnstile widget in Cloudflare.
2. Put the **site key** in `.env` as `VITE_TURNSTILE_SITE_KEY=...`. This one must
   be present at **build time** because Vite embeds it in the browser bundle —
   a Worker secret will not work for this value.
3. Add the **secret key** to the Worker:

   ```sh
   npx wrangler secret put TURNSTILE_SECRET_KEY --name kritis-kirti-staging
   ```

4. Run `npm run deploy:staging`.

## Move to a real domain

1. Add the domain in Cloudflare and point it at the Worker.
2. Change `SITE.url` in `src/lib/site.ts`.
3. Replace the staging origin in all ten `<loc>` entries in
   `public/sitemap.xml`, and in the `Sitemap:` line of `public/robots.txt`.
4. Run `npm run deploy:staging` and check that every page's canonical link uses
   the new domain.

## Still waiting on content

- Real prices for the catalogue (blank ones show _Price on request_).
- Fabric, weave and price details for **Floral Handpainted Saree**.
- The enquiry email address for `SITE.email` in `src/lib/site.ts`.
- Authentic photography to replace the remaining starter images.
- Confirmation of project locations and years.
