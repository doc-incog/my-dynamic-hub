# KRITI'S KIRTI — Handcrafted Interiors & Sustainable Décor

A warm, craft-led website for Kriti Shrestha Upadhyaya's handmade jute and eco-décor brand, with a private login area so you can update products, projects and enquiries yourself.

## Pages

**Home** — full-width hero with the tagline "Interior Designing to Sustainable Creativity", a short brand intro, featured handcrafted products, the "Reuse & Recreation" philosophy strip, interior-design services teaser, and a clear "Enquire / Book a consultation" call to action.

**About** — Kriti's story, the journey from interior design into handcrafted sustainability, the philosophy "Think Local. Design Creatively. Build Sustainably.", the artisan and women-entrepreneur impact, and the "Made in Nepal" identity.

**Services / Pricing** — interior design consultation, custom décor commissions, and product ranges (jute mats, coasters, bags, earrings, jewellery, mirror frames). Each with what's included and price or "price on request".

**Work & Contact** — a gallery of finished products and interior projects, each opening a detail view with photos and description, plus an enquiry form (name, email, phone, interest, message) that saves the enquiry and notifies you.

## Live, updatable content

You get a private sign-in at `/admin` (only your account can enter). From there you can:

- Add, edit, reorder and hide products and projects, with image uploads
- Edit services and prices
- Read and mark enquiries as handled

Everything on the public pages reads from this, so the site stays current without code changes. Public visitors can only read; nobody can reach the admin area without your login.

## Look and feel

Earthy, tactile and editorial rather than corporate: natural jute and clay tones, deep green accent, generous whitespace, a distinctive display typeface for headings, soft scroll-reveal and hover motion on product cards. Before building, I'll show you three rendered design directions to choose from.

Placeholder product photography will be generated so the site looks complete; swap in your real photos anytime. Contact details, real prices and any dates I cannot know will be flagged for you to supply.

## Technical notes

- TanStack Start routes: `/`, `/about`, `/services`, `/work`, `/work/$slug`, `/contact`, `/auth`, `/admin` (gated).
- Lovable Cloud enabled for database, image storage and login.
- Tables: `products`, `projects`, `services`, `enquiries`, `user_roles` + `has_role()` security-definer function; explicit grants, RLS with public `SELECT` on published rows only, writes restricted to the admin role. Enquiry inserts allowed for anonymous visitors, reads admin-only.
- Seed migration includes literal demo rows for products, projects and services so the first screen is populated.
- Reads via route loader + `ensureQueryData` / `useSuspenseQuery`; admin mutations via authenticated server functions.
- Per-route `head()` metadata with unique titles, descriptions and og tags.
- Design tokens (palette, gradients, shadows, fonts) defined in `src/styles.css`; fonts loaded via `<link>` in `__root.tsx`.

## Build order

1. Design direction choice, then design system and shared layout (header, footer, nav).
2. Enable Cloud; database schema, roles, grants, RLS and seed data.
3. Public pages: Home, About, Services, Work + detail, Contact with working enquiry form.
4. Login and admin area for products, projects, services and enquiries.
5. Imagery, metadata and polish pass.
