-- The saree card should show only its name, photo and "Price on request".
-- short_description is NOT NULL, so clear it to an empty string.

UPDATE public.products
SET short_description = '',
    updated_at = now()
WHERE slug = 'floral-print-saree-magenta';
