import juteMat from "@/assets/product-jute-mat.jpg";
import juteCoasters from "@/assets/product-jute-coasters.jpg";
import juteTote from "@/assets/product-jute-tote.jpg";

export const SITE = {
  name: "KRITI'S KIRTI",
  tagline: "Interior Designing to Sustainable Creativity",
  founder: "Kriti Shrestha Upadhyaya",
  philosophy: "Think Local. Design Creatively. Build Sustainably.",
  origin: "Handcrafted in Nepal",
};

/**
 * Bundled placeholder photography for the starter catalogue, keyed by slug.
 * Anything uploaded in the admin area overrides these.
 */
export const FALLBACK_IMAGES: Record<string, string> = {
  "woven-jute-floor-mat": juteMat,
  "jute-coaster-set-of-six": juteCoasters,
  "everyday-jute-tote-bag": juteTote,
};

export function imageFor(slug: string, imageUrl?: string | null): string | null {
  return imageUrl || FALLBACK_IMAGES[slug] || null;
}

export function formatPrice(price: number | null, currency = "NPR"): string {
  if (price === null || price === undefined) return "Price on request";
  return `${currency} ${Math.round(price).toLocaleString("en-IN")}`;
}
