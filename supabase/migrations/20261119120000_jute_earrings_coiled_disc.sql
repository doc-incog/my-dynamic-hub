-- Add the coiled-disc variant of the jute thread earrings.
-- Real product photography for both earring designs lives in src/assets
-- (product-jute-earrings.webp, product-jute-earrings-coiled.webp) and is mapped
-- by slug in src/lib/site.ts, so no storage rows are needed here.

INSERT INTO public.products (name, slug, category, short_description, description, price, featured, sort_order)
VALUES (
  'Jute Thread Earrings - Coiled Disc',
  'jute-thread-earrings-coiled',
  'Jewellery',
  'Coiled jute disc earrings on aged-brass hooks.',
  'A rounder take on our jute thread earrings: two hand-coiled discs joined by a brass bead on an aged-brass hook. Light enough to wear all day, and each pair varies slightly because the coiling is done by hand.',
  650,
  true,
  5
)
ON CONFLICT (slug) DO NOTHING;

-- Keep the existing order stable: the new pair sits directly after the originals.
UPDATE public.products SET sort_order = 6 WHERE slug = 'braided-jute-mirror-frame';
UPDATE public.products SET sort_order = 7 WHERE slug = 'layered-jute-wall-hanging';
UPDATE public.products SET sort_order = 8 WHERE slug = 'reused-fabric-jute-cushion';
UPDATE public.products SET sort_order = 9 WHERE slug = 'jute-storage-basket';
