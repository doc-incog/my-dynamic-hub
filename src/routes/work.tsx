import { createFileRoute, Link } from "@tanstack/react-router";
import { listProducts, listProjects } from "@/lib/content.functions";
import { ProductCard } from "@/components/site/ProductCard";
import {
  PageHero,
  RouteError,
  RouteNotFound,
  Section,
  SectionHeading,
} from "@/components/site/Bits";
import { imageFor } from "@/lib/site";

export const Route = createFileRoute("/work")({
  loader: async () => ({
    projects: await listProjects(),
    products: await listProducts(),
  }),
  head: () => ({
    meta: [
      { title: "Work — Interior Projects & Handcrafted Jute Pieces | KRITI'S KIRTI" },
      {
        name: "description",
        content:
          "Browse interior design projects across the Kathmandu Valley and our full collection of handcrafted jute mats, coasters, bags, jewellery and décor.",
      },
      { property: "og:title", content: "Work & Collection — KRITI'S KIRTI" },
      {
        property: "og:description",
        content:
          "Interior projects in natural fibre and the handcrafted jute collection, made in Nepal.",
      },
    ],
  }),
  errorComponent: RouteError,
  notFoundComponent: RouteNotFound,
  component: Work,
});

function Work() {
  const { projects, products } = Route.useLoaderData();

  return (
    <>
      <PageHero
        eyebrow="Portfolio"
        title="Spaces we've shaped and pieces we've made"
        description="Interior projects for homes, cafés and studios, alongside the handcrafted collection that so often finds its way into them."
      />

      <Section>
        <SectionHeading eyebrow="Interior projects" title="Selected spaces" />
        <div className="mt-12 grid gap-12 md:grid-cols-2">
          {projects.map((project, i) => {
            const cover = imageFor(project.slug, project.cover_image_url);
            return (
              <Link
                key={project.id}
                to="/work/$slug"
                params={{ slug: project.slug }}
                className={`group block ${i % 2 === 1 ? "md:mt-16" : ""}`}
              >
                <div className="overflow-hidden rounded-sm bg-secondary">
                  {cover ? (
                    <img
                      src={cover}
                      alt={project.title}
                      loading="lazy"
                      className="aspect-[4/3] w-full object-cover transition-transform duration-700 ease-out group-hover:scale-[1.03]"
                    />
                  ) : (
                    <div className="aspect-[4/3] w-full" />
                  )}
                </div>
                <div className="mt-5 flex items-baseline justify-between gap-4">
                  <h3 className="text-xl leading-snug text-foreground transition-colors group-hover:text-accent">
                    {project.title}
                  </h3>
                  <span className="shrink-0 text-xs text-muted-foreground">{project.year}</span>
                </div>
                <p className="eyebrow mt-2">{project.location}</p>
                <p className="mt-3 text-sm leading-relaxed text-muted-foreground">
                  {project.summary}
                </p>
              </Link>
            );
          })}
        </div>
      </Section>

      <section className="border-t border-border bg-secondary/30">
        <div className="mx-auto max-w-7xl px-5 py-20 sm:px-8 sm:py-24">
          <SectionHeading
            eyebrow="The collection"
            title="Handcrafted jute pieces"
            description="Every item is made in small batches. Ask about colours, sizes, gift sets and custom orders."
          />
          <div className="mt-12 grid gap-10 sm:grid-cols-2 lg:grid-cols-4">
            {products.map((product) => (
              <ProductCard key={product.id} product={product} />
            ))}
          </div>
        </div>
      </section>
    </>
  );
}
