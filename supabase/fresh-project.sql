-- KRITI'S KIRTI — complete database setup for a fresh Supabase project.
-- Paste this whole file into the SQL Editor and press Run. It is safe to run once.
-- Generated from supabase/migrations on 2026-11-12.

-- ============================================================
-- Migration: 20260929165913_a7fb076c-4690-4497-9d91-77d00670645a.sql
-- ============================================================
CREATE TYPE public.app_role AS ENUM ('admin', 'user');

CREATE TABLE public.user_roles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  role public.app_role NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (user_id, role)
);
GRANT SELECT ON public.user_roles TO authenticated;
GRANT ALL ON public.user_roles TO service_role;
ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can read their own roles" ON public.user_roles FOR SELECT TO authenticated USING (auth.uid() = user_id);

CREATE OR REPLACE FUNCTION public.has_role(_user_id uuid, _role public.app_role)
RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = _user_id AND role = _role)
$$;

CREATE OR REPLACE FUNCTION public.grant_first_user_admin()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.user_roles WHERE role = 'admin') THEN
    INSERT INTO public.user_roles (user_id, role) VALUES (NEW.id, 'admin');
  ELSE
    INSERT INTO public.user_roles (user_id, role) VALUES (NEW.id, 'user') ON CONFLICT DO NOTHING;
  END IF;
  RETURN NEW;
END;
$$;

CREATE TRIGGER on_auth_user_created_grant_role
AFTER INSERT ON auth.users
FOR EACH ROW EXECUTE FUNCTION public.grant_first_user_admin();

CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS trigger LANGUAGE plpgsql SET search_path = public AS $$
BEGIN NEW.updated_at = now(); RETURN NEW; END;
$$;

CREATE TABLE public.products (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  slug text NOT NULL UNIQUE,
  category text NOT NULL DEFAULT 'Home décor',
  short_description text NOT NULL DEFAULT '',
  description text NOT NULL DEFAULT '',
  price numeric(10,2),
  currency text NOT NULL DEFAULT 'NPR',
  image_url text,
  featured boolean NOT NULL DEFAULT false,
  published boolean NOT NULL DEFAULT true,
  sort_order integer NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT ON public.products TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.products TO authenticated;
GRANT ALL ON public.products TO service_role;
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view published products" ON public.products FOR SELECT TO anon, authenticated USING (published = true);
CREATE POLICY "Admins can view all products" ON public.products FOR SELECT TO authenticated USING (public.has_role(auth.uid(), 'admin'));
CREATE POLICY "Admins can insert products" ON public.products FOR INSERT TO authenticated WITH CHECK (public.has_role(auth.uid(), 'admin'));
CREATE POLICY "Admins can update products" ON public.products FOR UPDATE TO authenticated USING (public.has_role(auth.uid(), 'admin')) WITH CHECK (public.has_role(auth.uid(), 'admin'));
CREATE POLICY "Admins can delete products" ON public.products FOR DELETE TO authenticated USING (public.has_role(auth.uid(), 'admin'));
CREATE TRIGGER products_updated_at BEFORE UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TABLE public.projects (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  slug text NOT NULL UNIQUE,
  location text NOT NULL DEFAULT '',
  year text NOT NULL DEFAULT '',
  summary text NOT NULL DEFAULT '',
  description text NOT NULL DEFAULT '',
  cover_image_url text,
  gallery_urls text[] NOT NULL DEFAULT '{}',
  published boolean NOT NULL DEFAULT true,
  sort_order integer NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT ON public.projects TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.projects TO authenticated;
GRANT ALL ON public.projects TO service_role;
ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view published projects" ON public.projects FOR SELECT TO anon, authenticated USING (published = true);
CREATE POLICY "Admins can view all projects" ON public.projects FOR SELECT TO authenticated USING (public.has_role(auth.uid(), 'admin'));
CREATE POLICY "Admins can insert projects" ON public.projects FOR INSERT TO authenticated WITH CHECK (public.has_role(auth.uid(), 'admin'));
CREATE POLICY "Admins can update projects" ON public.projects FOR UPDATE TO authenticated USING (public.has_role(auth.uid(), 'admin')) WITH CHECK (public.has_role(auth.uid(), 'admin'));
CREATE POLICY "Admins can delete projects" ON public.projects FOR DELETE TO authenticated USING (public.has_role(auth.uid(), 'admin'));
CREATE TRIGGER projects_updated_at BEFORE UPDATE ON public.projects FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TABLE public.services (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  slug text NOT NULL UNIQUE,
  summary text NOT NULL DEFAULT '',
  details text NOT NULL DEFAULT '',
  price_label text NOT NULL DEFAULT 'Price on request',
  published boolean NOT NULL DEFAULT true,
  sort_order integer NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT ON public.services TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.services TO authenticated;
GRANT ALL ON public.services TO service_role;
ALTER TABLE public.services ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view published services" ON public.services FOR SELECT TO anon, authenticated USING (published = true);
CREATE POLICY "Admins can view all services" ON public.services FOR SELECT TO authenticated USING (public.has_role(auth.uid(), 'admin'));
CREATE POLICY "Admins can insert services" ON public.services FOR INSERT TO authenticated WITH CHECK (public.has_role(auth.uid(), 'admin'));
CREATE POLICY "Admins can update services" ON public.services FOR UPDATE TO authenticated USING (public.has_role(auth.uid(), 'admin')) WITH CHECK (public.has_role(auth.uid(), 'admin'));
CREATE POLICY "Admins can delete services" ON public.services FOR DELETE TO authenticated USING (public.has_role(auth.uid(), 'admin'));
CREATE TRIGGER services_updated_at BEFORE UPDATE ON public.services FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TABLE public.enquiries (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  email text NOT NULL,
  phone text NOT NULL DEFAULT '',
  interest text NOT NULL DEFAULT 'General',
  message text NOT NULL,
  handled boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now()
);
GRANT INSERT ON public.enquiries TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.enquiries TO authenticated;
GRANT ALL ON public.enquiries TO service_role;
ALTER TABLE public.enquiries ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can send an enquiry" ON public.enquiries FOR INSERT TO anon, authenticated WITH CHECK (true);
CREATE POLICY "Admins can view enquiries" ON public.enquiries FOR SELECT TO authenticated USING (public.has_role(auth.uid(), 'admin'));
CREATE POLICY "Admins can update enquiries" ON public.enquiries FOR UPDATE TO authenticated USING (public.has_role(auth.uid(), 'admin')) WITH CHECK (public.has_role(auth.uid(), 'admin'));
CREATE POLICY "Admins can delete enquiries" ON public.enquiries FOR DELETE TO authenticated USING (public.has_role(auth.uid(), 'admin'));

INSERT INTO public.products (name, slug, category, short_description, description, price, featured, sort_order) VALUES
('Woven Jute Floor Mat', 'woven-jute-floor-mat', 'Mats & Rugs', 'Hand-braided jute mat with a natural undyed finish.', 'A sturdy round floor mat braided by hand from locally sourced jute rope. Each coil is stitched by our artisans, giving every mat a slightly different character. Suitable for living rooms, entryways and meditation corners.', 3500, true, 1),
('Jute Coaster Set of Six', 'jute-coaster-set-of-six', 'Table & Kitchen', 'Six coiled coasters, heat resistant and fully biodegradable.', 'A set of six hand-coiled jute coasters finished with a soft natural binding. They protect your table from heat and moisture while adding an earthy texture to everyday dining.', 900, true, 2),
('Everyday Jute Tote Bag', 'everyday-jute-tote-bag', 'Bags', 'A roomy market tote with reinforced cotton handles.', 'Woven from jute fibre with reinforced cotton webbing handles and a lined base, this tote carries groceries, books or studio supplies. A practical alternative to plastic that only gets better with use.', 1800, true, 3),
('Jute Thread Earrings', 'jute-thread-earrings', 'Jewellery', 'Lightweight statement earrings wrapped in jute thread.', 'Featherlight earrings built on a brass frame and wrapped in fine jute thread, finished with hypoallergenic hooks. Available in natural, indigo and madder tones on request.', 650, true, 4),
('Braided Jute Mirror Frame', 'braided-jute-mirror-frame', 'Wall & Décor', 'A round mirror framed in thick braided jute rope.', 'A round wall mirror set inside a generous braided jute frame. The sunburst texture brings warmth to hallways, bedrooms and dressing corners, and can be made to a custom diameter.', 4800, true, 5),
('Layered Jute Wall Hanging', 'layered-jute-wall-hanging', 'Wall & Décor', 'A macramé-style wall piece in layered natural fibre.', 'A large wall hanging of knotted and fringed jute layers on a reclaimed wooden dowel. Made to order in your chosen width, it softens plain walls and absorbs sound.', 3200, false, 6),
('Reused Fabric Jute Cushion', 'reused-fabric-jute-cushion', 'Soft Furnishing', 'Cushion cover combining jute with reclaimed cotton offcuts.', 'A cushion cover that pairs a woven jute panel with reclaimed cotton offcuts from local tailoring units, following our Reuse and Recreation principle. Cover only, 40 x 40 cm.', 1400, false, 7),
('Jute Storage Basket', 'jute-storage-basket', 'Storage', 'A soft-sided basket that holds its shape beautifully.', 'A hand-coiled jute basket with rolled handles for blankets, toys or plant pots. Structured enough to stand on its own, soft enough to sit against a wall without scratching it.', 2200, false, 8);

INSERT INTO public.projects (title, slug, location, year, summary, description, sort_order) VALUES
('Warm Minimal Apartment Living Room', 'warm-minimal-apartment-living-room', 'Lalitpur, Nepal', '2025', 'A compact family living room rebuilt around natural fibre and daylight.', 'The brief was a calm, low-maintenance living room for a family of four. We kept the existing terrazzo floor, added a hand-braided jute rug, custom jute wall panels for acoustics and a reclaimed timber media unit. Locally made cushions and a braided mirror frame complete the space.', 1),
('Café Interior in Natural Fibre', 'cafe-interior-in-natural-fibre', 'Kathmandu, Nepal', '2025', 'A twenty-two seat café styled with woven partitions and warm lighting.', 'A neighbourhood café that needed personality without heavy construction. We designed woven jute partitions to break the long room into pockets, added layered wall hangings behind the counter and specified warm dimmable lighting so the space works from morning coffee through evening.', 2),
('Sustainable Home Office Corner', 'sustainable-home-office-corner', 'Bhaktapur, Nepal', '2024', 'A working corner built almost entirely from reused and local materials.', 'A small home office carved out of a bedroom for a freelance client. The desk was rebuilt from an old dining table, storage baskets replaced plastic boxes, and a jute pinboard doubles as sound softening for video calls.', 3),
('Handcrafted Gift Studio Display', 'handcrafted-gift-studio-display', 'Kathmandu, Nepal', '2024', 'A pop-up retail display for a seasonal craft exhibition.', 'A modular display system for a craft exhibition stall, built from reclaimed crates and jute rope so it could be packed flat and reused across three events. Product lighting and signage were designed to sit within the same warm palette.', 4);

INSERT INTO public.services (title, slug, summary, details, price_label, sort_order) VALUES
('Interior Design Consultation', 'interior-design-consultation', 'A focused session to plan layout, colour, materials and lighting for your space.', 'Includes a site visit or video walkthrough, measurement review, a mood direction with material samples, a furniture and lighting layout, and a written summary of recommendations you can act on yourself or hand to a contractor.', 'Price on request', 1),
('Full Interior Styling', 'full-interior-styling', 'End to end styling for homes, cafés and studios, from concept to installation.', 'Covers concept development, material and finish selection, custom handcrafted pieces made for your space, coordination with local artisans and fabricators, and on-site styling on installation day.', 'Price on request', 2),
('Custom Handcrafted Commissions', 'custom-handcrafted-commissions', 'Made-to-measure jute mats, mirror frames, wall pieces and soft furnishing.', 'Tell us the dimensions, colour direction and where the piece will live. We share a sketch and a quotation, then handcraft it in our studio. Typical lead time is two to four weeks depending on size.', 'Quoted per piece', 3),
('Handcrafted Product Range', 'handcrafted-product-range', 'Ready-to-buy jute mats, coasters, bags, earrings, jewellery and décor.', 'Our standing collection of handcrafted pieces, made in small batches. Available individually or as curated gift sets for festivals, weddings and corporate gifting, with custom packaging on request.', 'From NPR 650', 4),
('Workshops and Artisan Training', 'workshops-and-artisan-training', 'Hands-on sessions in jute craft for groups, schools and women’s collectives.', 'A practical introduction to working with jute and reused materials, covering coiling, braiding and finishing. Designed for groups of eight to twenty, run at your venue or our studio, with all materials provided.', 'Price on request', 5);

-- ============================================================
-- Migration: 20260929165950_3c58d087-5e21-45b6-90b0-3a4046f1d0e9.sql
-- ============================================================
REVOKE ALL ON FUNCTION public.has_role(uuid, public.app_role) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.grant_first_user_admin() FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.set_updated_at() FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.has_role(uuid, public.app_role) TO authenticated, service_role;

-- ============================================================
-- Migration: 20260929170054_204dedeb-165c-44f4-a851-6e6b37c6aaf5.sql
-- ============================================================
CREATE POLICY "Admins can upload site images" ON storage.objects FOR INSERT TO authenticated WITH CHECK (bucket_id = 'site-images' AND public.has_role(auth.uid(), 'admin'));
CREATE POLICY "Admins can view site images" ON storage.objects FOR SELECT TO authenticated USING (bucket_id = 'site-images' AND public.has_role(auth.uid(), 'admin'));
CREATE POLICY "Admins can update site images" ON storage.objects FOR UPDATE TO authenticated USING (bucket_id = 'site-images' AND public.has_role(auth.uid(), 'admin')) WITH CHECK (bucket_id = 'site-images' AND public.has_role(auth.uid(), 'admin'));
CREATE POLICY "Admins can delete site images" ON storage.objects FOR DELETE TO authenticated USING (bucket_id = 'site-images' AND public.has_role(auth.uid(), 'admin'));

-- ============================================================
-- Migration: 20261026090000_phase0_security_hardening.sql
-- ============================================================
-- Phase 0 hardening: remove first-user admin bootstrap and protect enquiries.

DROP TRIGGER IF EXISTS on_auth_user_created_grant_role ON auth.users;
DROP FUNCTION IF EXISTS public.grant_first_user_admin();

-- Signups are closed even if Supabase's open-signup setting is re-enabled:
-- only emails in this allowlist may create an account.
CREATE TABLE IF NOT EXISTS public.owner_allowlist (
  email text PRIMARY KEY,
  created_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.owner_allowlist ENABLE ROW LEVEL SECURITY;

INSERT INTO public.owner_allowlist (email)
SELECT u.email
FROM auth.users u
JOIN public.user_roles r ON r.user_id = u.id AND r.role = 'admin'
WHERE u.email IS NOT NULL
ON CONFLICT DO NOTHING;

CREATE OR REPLACE FUNCTION public.enforce_owner_allowlist()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NEW.email IS NULL OR NOT EXISTS (
    SELECT 1
    FROM public.owner_allowlist
    WHERE lower(email) = lower(NEW.email)
  ) THEN
    RAISE EXCEPTION 'signup_not_allowed' USING ERRCODE = '42501';
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS enforce_owner_allowlist_trigger ON auth.users;
CREATE TRIGGER enforce_owner_allowlist_trigger
BEFORE INSERT ON auth.users
FOR EACH ROW EXECUTE FUNCTION public.enforce_owner_allowlist();

ALTER TABLE public.enquiries ADD COLUMN IF NOT EXISTS ip_hash text;

CREATE INDEX IF NOT EXISTS enquiries_ip_hash_created_at_idx
  ON public.enquiries (ip_hash, created_at DESC);

DROP POLICY IF EXISTS "Anyone can send an enquiry" ON public.enquiries;
REVOKE INSERT ON public.enquiries FROM anon, authenticated;

CREATE OR REPLACE FUNCTION public.create_enquiry(
  _name text,
  _email text,
  _phone text,
  _interest text,
  _message text,
  _ip_hash text
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  new_id uuid;
  recent_count integer;
BEGIN
  IF length(coalesce(_name, '')) < 2
     OR length(_name) > 120
     OR length(coalesce(_email, '')) < 3
     OR length(_email) > 180
     OR coalesce(_email, '') !~ '^[^@[:space:]]+@[^@[:space:]]+\.[^@[:space:]]+$'
     OR length(coalesce(_message, '')) < 5
     OR length(_message) > 2000
     OR length(coalesce(_phone, '')) > 40
     OR length(coalesce(_interest, '')) > 120 THEN
    RAISE EXCEPTION 'invalid_enquiry' USING ERRCODE = '22023';
  END IF;

  IF _ip_hash IS NOT NULL THEN
    SELECT count(*)
      INTO recent_count
      FROM public.enquiries
     WHERE ip_hash = _ip_hash
       AND created_at > now() - interval '1 hour';

    IF recent_count >= 5 THEN
      RAISE EXCEPTION 'rate_limited' USING ERRCODE = 'P0001';
    END IF;
  END IF;

  INSERT INTO public.enquiries (name, email, phone, interest, message, ip_hash)
  VALUES (
    trim(_name),
    lower(trim(_email)),
    coalesce(_phone, ''),
    coalesce(nullif(trim(_interest), ''), 'General'),
    trim(_message),
    _ip_hash
  )
  RETURNING id INTO new_id;

  RETURN new_id;
END;
$$;

REVOKE ALL ON FUNCTION public.create_enquiry(text, text, text, text, text, text) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.create_enquiry(text, text, text, text, text, text)
  TO service_role;

-- ============================================================
-- Migration: 20261026091000_site_images_bucket.sql
-- ============================================================
insert into storage.buckets (id, name, public)
values ('site-images', 'site-images', false)
on conflict (id) do nothing;

-- ============================================================
-- Allow the site owner to create their account.
-- The signup trigger rejects any email missing from this table,
-- so keep this list to the people who should own the site.
-- ============================================================
insert into public.owner_allowlist (email)
values ('abhijitupadhyay77@gmail.com')
on conflict (email) do nothing;
