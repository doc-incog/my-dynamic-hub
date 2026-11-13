import { createFileRoute } from "@tanstack/react-router";
import aboutFounder from "@/assets/about-founder.webp";
import aboutStudio from "@/assets/about-studio.jpg";
import heroInterior from "@/assets/hero-interior.jpg";
import { ButtonLink, Section, SectionHeading } from "@/components/site/Bits";
import { SITE } from "@/lib/site";

export const Route = createFileRoute("/about")({
  head: () => ({
    meta: [
      { title: "About Kriti Shrestha Upadhyaya — KRITI'S KIRTI" },
      {
        name: "description",
        content:
          "The story behind KRITI'S KIRTI: an interior designer's journey into handcrafted jute, reuse and recreation, and creating work for local artisans and women entrepreneurs in Nepal.",
      },
      { property: "og:title", content: "About KRITI'S KIRTI — Interior Design to Handcraft" },
      {
        property: "og:description",
        content:
          "Founded by Kriti Shrestha Upadhyaya, KRITI'S KIRTI connects interior design, art, sustainability and entrepreneurship, promoting the identity of Made in Nepal.",
      },
    ],
  }),
  component: About,
});

function AboutHero() {
  return (
    <section className="relative overflow-hidden border-b border-border surface-warm">
      {/* Bottom padding is dropped on mobile so the founder cut-out sits flush
          against the section border — the asset is trimmed to the subject, so any
          space below it reads as a mistake. */}
      <div className="mx-auto grid max-w-6xl items-center gap-12 px-5 pt-20 pb-0 sm:px-8 lg:min-h-[31.5rem] lg:grid-cols-[1.15fr_0.85fr] lg:gap-14 lg:py-0">
        <div className="relative z-10 max-w-[35rem] lg:self-center">
          <p className="eyebrow">Our story</p>
          <h1 className="mt-6 text-[2.5rem] leading-[1.05] text-foreground sm:text-5xl lg:text-[3.375rem]">
            A journey from interior design into handcrafted sustainability
          </h1>
          <p className="mt-6 max-w-[36rem] text-base leading-relaxed text-muted-foreground">
            {SITE.name} is a signature handcrafted initiative founded by {SITE.founder}, combining her experience in interior designing with her passion for creativity, local craftsmanship and sustainable living.
          </p>
        </div>
        <div className="relative hidden h-[28rem] self-end lg:block lg:w-[125%] lg:max-w-none">
          <img
            src={aboutFounder}
            alt={`${SITE.founder}, founder of ${SITE.name}`}
            width={1200}
            height={1003}
            loading="eager"
            fetchPriority="high"
            className="pointer-events-none absolute bottom-0 left-0 h-full w-auto max-w-none select-none object-contain object-left-bottom [filter:drop-shadow(0_28px_45px_rgba(44,34,26,0.18))]"
          />
        </div>
        <div className="w-full lg:hidden">
          <img
            src={aboutFounder}
            alt={`${SITE.founder}, founder of ${SITE.name}`}
            width={1200}
            height={1003}
            loading="eager"
            className="mx-auto block h-auto w-full max-w-sm object-contain object-bottom"
          />
        </div>
      </div>
    </section>
  );
}

function About() {
  return (
    <>
      <AboutHero />

      <Section className="max-w-6xl">
        <div className="grid gap-14 lg:grid-cols-[1.1fr_1fr] lg:items-start">
          <div className="space-y-6 text-base leading-relaxed text-muted-foreground">
            <p>
              The brand began with a simple observation: the materials already around us in Nepal —
              jute above all — are strong, beautiful and endlessly workable, yet so much of what we
              use at home is imported and short-lived.
            </p>
            <p>
              Working as an interior designer, Kriti kept returning to the same idea. A room feels
              different when the things inside it were made nearby, by hand, from something grown
              locally. So the studio started making them: jute mats, coasters, bags, earrings,
              jewellery, mirror frames and other décor pieces, each one finished by hand.
            </p>
            <p>
              Today that work runs in two directions. We design and style interiors for homes, cafés
              and studios, and we handcraft the pieces that fill them — sometimes for our own
              projects, often as commissions for other people's.
            </p>
            <p>
              Inspired by the principle of{" "}
              <strong className="text-foreground">Reuse &amp; Recreation</strong>, we look for the
              meaningful second life in materials, and create opportunities for local artisans,
              women entrepreneurs and home-based workers along the way.
            </p>
          </div>
          <div className="space-y-5">
            <img
              src={aboutStudio}
              alt="Hands working jute rope at a studio bench surrounded by woven samples"
              loading="lazy"
              width={1408}
              height={1008}
              className="w-full rounded-sm object-cover shadow-soft"
            />
            <div className="rounded-sm border border-border bg-secondary/40 p-6">
              <p className="eyebrow">Our philosophy</p>
              <p className="mt-3 font-display text-2xl leading-snug text-foreground">
                {SITE.philosophy}
              </p>
            </div>
          </div>
        </div>
      </Section>

      <section className="border-y border-border bg-secondary/40">
        <div className="mx-auto max-w-7xl px-5 py-20 sm:px-8">
          <SectionHeading
            eyebrow="What guides the work"
            title="Craft, community and the identity of Made in Nepal"
          />
          <div className="mt-12 grid gap-10 sm:grid-cols-2 lg:grid-cols-4">
            {[
              {
                title: "Interior design",
                body: "Layout, light, material and finish — planned so a space works as well as it looks.",
              },
              {
                title: "Art & craft",
                body: "Hand techniques like coiling, braiding and knotting, used with a designer's eye.",
              },
              {
                title: "Sustainability",
                body: "Natural fibre, reused material and repairable construction as the default, not an extra.",
              },
              {
                title: "Entrepreneurship",
                body: "Steady, fairly paid work for artisans, women entrepreneurs and home-based makers.",
              },
            ].map((item) => (
              <div key={item.title} className="border-t border-foreground/15 pt-5">
                <h3 className="text-lg text-foreground">{item.title}</h3>
                <p className="mt-2 text-sm leading-relaxed text-muted-foreground">{item.body}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      <Section>
        <div className="grid gap-12 lg:grid-cols-[1fr_1fr] lg:items-center">
          <img
            src={heroInterior}
            alt="A styled living room corner with jute rug, bench and braided mirror"
            loading="lazy"
            width={1600}
            height={1104}
            className="w-full rounded-sm object-cover shadow-soft"
          />
          <div>
            <SectionHeading
              eyebrow="Work with us"
              title="Every creation starts as a conversation"
              description="Whether you want one handcrafted piece or a whole room rethought, tell us what you are imagining and we will take it from there."
            />
            <div className="mt-9 flex flex-wrap gap-3">
              <ButtonLink to="/contact">Send an enquiry</ButtonLink>
              <ButtonLink to="/services" variant="outline">
                Services &amp; pricing
              </ButtonLink>
            </div>
          </div>
        </div>
      </Section>
    </>
  );
}
