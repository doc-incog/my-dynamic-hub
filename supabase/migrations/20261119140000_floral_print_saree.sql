-- Add the printed saree from the wall-art shoot as a catalogue entry.
-- It has no confirmed price yet, so price stays NULL and the site renders
-- "Price on request". The photo is bundled at src/assets/product-saree.webp and
-- mapped by slug in src/lib/site.ts.

INSERT INTO public.products (name, slug, category, short_description, description, price, featured, sort_order)
VALUES (
  'Floral Print Saree — Magenta',
  'floral-print-saree-magenta',
  'Textiles',
  'Deep magenta saree with a hand-drawn floral print.',
  'A fluid saree in deep magenta printed with a scattered floral motif and finished with a fine gold border. Shown here with our jute rug and braided rope mirror. Price on request while fabric options and lead times are confirmed.',
  NULL,
  false,
  10
)
ON CONFLICT (slug) DO NOTHING;
