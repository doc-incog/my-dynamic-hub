-- Retire the original open-ring pair from the catalogue.
-- Unpublished rather than deleted so the row, its slug and its photo mapping
-- (src/assets/product-jute-earrings.webp) survive and can be restored by
-- setting published back to true.

UPDATE public.products
SET published = false, updated_at = now()
WHERE slug = 'jute-thread-earrings';
