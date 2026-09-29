import { Link } from "@tanstack/react-router";
import type { Product } from "@/lib/content.functions";
import { formatPrice, imageFor } from "@/lib/site";

export function ProductCard({ product }: { product: Product }) {
  const image = imageFor(product.slug, product.image_url);

  return (
    <article className="group flex flex-col">
      <div className="relative overflow-hidden rounded-sm bg-secondary">
        {image ? (
          <img
            src={image}
            alt={product.name}
            loading="lazy"
            className="aspect-square w-full object-cover transition-transform duration-700 ease-out group-hover:scale-[1.04]"
          />
        ) : (
          <div className="flex aspect-square w-full items-center justify-center text-xs uppercase tracking-[0.2em] text-muted-foreground">
            Photo coming soon
          </div>
        )}
        <span className="absolute left-3 top-3 rounded-sm bg-background/90 px-2.5 py-1 text-[0.6rem] font-semibold uppercase tracking-[0.18em] text-muted-foreground">
          {product.category}
        </span>
      </div>
      <h3 className="mt-4 text-lg leading-snug text-foreground">{product.name}</h3>
      <p className="mt-2 flex-1 text-sm leading-relaxed text-muted-foreground">
        {product.short_description}
      </p>
      <div className="mt-4 flex items-center justify-between border-t border-border pt-4">
        <span className="text-sm font-semibold text-foreground">
          {formatPrice(product.price === null ? null : Number(product.price), product.currency)}
        </span>
        <Link
          to="/contact"
          search={{ interest: product.name }}
          className="text-xs font-semibold uppercase tracking-[0.16em] text-accent transition-colors hover:text-foreground"
        >
          Enquire
        </Link>
      </div>
    </article>
  );
}
