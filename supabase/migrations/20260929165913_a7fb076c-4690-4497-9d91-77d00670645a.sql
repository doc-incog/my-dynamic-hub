
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
