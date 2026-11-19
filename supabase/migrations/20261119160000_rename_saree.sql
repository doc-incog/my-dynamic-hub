-- Rename the saree and align its copy. The slug stays unchanged so existing
-- links, the bundled photo mapping and any saved enquiry interest keep working.

UPDATE public.products
SET name = 'Floral Handpainted Saree',
    short_description = 'Handpainted floral saree in deep magenta.',
    description = 'A fluid saree in deep magenta with a handpainted floral motif and a fine gold border. Shown here with our jute rug and braided rope mirror. Price on request while fabric options and lead times are confirmed.',
    updated_at = now()
WHERE slug = 'floral-print-saree-magenta';
