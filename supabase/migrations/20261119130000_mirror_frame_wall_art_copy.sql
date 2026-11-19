-- The mirror frame now ships with real photography (a diamond jute wall piece),
-- so the catalogue copy describes that piece instead of a round sunburst mirror.
-- The photo itself is bundled at src/assets/product-jute-mirror.webp and mapped
-- by slug in src/lib/site.ts.

UPDATE public.products
SET
  short_description = 'A diamond jute wall mirror with braided rope and carved leaves.',
  description = 'A diamond-shaped wall piece in natural jute: a burlap panel bordered by a slim wooden frame, with a braided jute rope ring and hand-carved jute leaves and rosettes around the glass. Made to order in your chosen size.',
  updated_at = now()
WHERE slug = 'braided-jute-mirror-frame';
