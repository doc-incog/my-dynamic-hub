import juteMat from "@/assets/product-jute-mat.jpg";
import juteCoasters from "@/assets/product-jute-coasters.jpg";
import juteTote from "@/assets/product-jute-tote.jpg";
import juteEarrings from "@/assets/product-jute-earrings.jpg";
import juteMirror from "@/assets/product-jute-mirror.jpg";
import juteWallHanging from "@/assets/product-jute-wall-hanging.jpg";
import juteCushion from "@/assets/product-jute-cushion.jpg";
import juteBasket from "@/assets/product-jute-basket.jpg";
import heroInterior from "@/assets/hero-interior.jpg";
import projectCafe from "@/assets/project-cafe.jpg";
import projectHomeOffice from "@/assets/project-home-office.jpg";
import projectDisplay from "@/assets/project-display.jpg";

export const SITE = {
  name: "KRITI'S KIRTI",
  tagline: "Interior Designing to Sustainable Creativity",
  founder: "Kriti Shrestha Upadhyaya",
  philosophy: "Think Local. Design Creatively. Build Sustainably.",
  principle: "Reuse & Recreation",
  origin: "Made in Nepal",
};

export const NAV_LINKS = [
  { to: "/", label: "Home" },
  { to: "/about", label: "About" },
  { to: "/services", label: "Services" },
  { to: "/work", label: "Work" },
  { to: "/contact", label: "Contact" },
] as const;

/**
 * Bundled placeholder photography for the starter catalogue, keyed by slug.
 * Anything uploaded in the owner's admin area replaces these.
 */
export const FALLBACK_IMAGES: Record<string, string> = {
  "woven-jute-floor-mat": juteMat,
  "jute-coaster-set-of-six": juteCoasters,
  "everyday-jute-tote-bag": juteTote,
  "jute-thread-earrings": juteEarrings,
  "braided-jute-mirror-frame": juteMirror,
  "layered-jute-wall-hanging": juteWallHanging,
  "reused-fabric-jute-cushion": juteCushion,
  "jute-storage-basket": juteBasket,
  "warm-minimal-apartment-living-room": heroInterior,
  "cafe-interior-in-natural-fibre": projectCafe,
  "sustainable-home-office-corner": projectHomeOffice,
  "handcrafted-gift-studio-display": projectDisplay,
};

export function imageFor(slug: string, imageUrl?: string | null): string | null {
  return imageUrl || FALLBACK_IMAGES[slug] || null;
}

export function formatPrice(price: number | null, currency = "NPR"): string {
  if (price === null || price === undefined) return "Price on request";
  return `${currency} ${Math.round(price).toLocaleString("en-IN")}`;
}
