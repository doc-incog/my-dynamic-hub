import { createFileRoute, Link } from "@tanstack/react-router";
import { PageHero, RouteError, RouteNotFound, Section } from "@/components/site/Bits";
import { SITE } from "@/lib/site";

const LAST_UPDATED = "19 November 2026";

export const Route = createFileRoute("/privacy")({
  head: () => ({
    meta: [
      { title: "Privacy & Enquiries — KRITI'S KIRTI" },
      {
        name: "description",
        content:
          "What KRITI'S KIRTI does with the details you send through the enquiry form, why we keep them, and how to ask for a copy or deletion.",
      },
      { property: "og:title", content: "Privacy & Enquiries — KRITI'S KIRTI" },
      {
        property: "og:description",
        content:
          "How KRITI'S KIRTI handles enquiry details: what we collect, who can see it, and how to have it removed.",
      },
    ],
  }),
  errorComponent: RouteError,
  notFoundComponent: RouteNotFound,
  component: Privacy,
});

const ITEMS: Array<{ heading: string; body: string }> = [
  {
    heading: "What we collect",
    body: "The enquiry form asks for your name, your email address, and optionally a phone number, the kind of work you're interested in, and your message. Nothing else is required, and the form never asks for payment details.",
  },
  {
    heading: "Why we keep it",
    body: "Your details are stored so we can read your enquiry, reply to it, and remember what was discussed if you get back in touch. We don't add you to a mailing list, and we don't sell or rent your details to anyone.",
  },
  {
    heading: "Who can see it",
    body: "Enquiries are visible only to the studio owner through the password-protected admin area. The website, database and photo storage run on trusted hosting providers (Cloudflare and Supabase), which process the data on our behalf.",
  },
  {
    heading: "Spam protection",
    body: "To keep the form usable, a one-way hash of the sender's IP address is stored with the enquiry and used only to count recent submissions from the same source. The raw IP address is never stored, and the hash is not used to identify you.",
  },
  {
    heading: "Cookies",
    body: "The public site sets no advertising or analytics cookies. A session cookie is created only when the studio owner signs in to manage the site.",
  },
  {
    heading: "How long we keep it",
    body: "Enquiries are kept while a project or order is active and for a reasonable period afterwards so we can answer follow-up questions. If you'd like your enquiry removed sooner, just ask and we'll delete it.",
  },
  {
    heading: "Your choices",
    body: "You can ask us to show you what we hold about you, correct it, or delete it. Call or message the studio and we'll take care of it — there's no form to fill in.",
  },
];

function Privacy() {
  return (
    <>
      <PageHero
        eyebrow="Privacy"
        title="Your details, and what happens to them"
        description="A short, plain-language note about the information you share when you send an enquiry — written to be read, not to hide behind."
      />

      <Section className="max-w-3xl">
        <p className="text-sm text-muted-foreground">Last updated {LAST_UPDATED}</p>
        <div className="mt-10 space-y-10">
          {ITEMS.map((item) => (
            <div key={item.heading}>
              <h2 className="text-xl text-foreground sm:text-2xl">{item.heading}</h2>
              <p className="mt-3 text-sm leading-relaxed text-muted-foreground sm:text-base">
                {item.body}
              </p>
            </div>
          ))}
          <div>
            <h2 className="text-xl text-foreground sm:text-2xl">Who we are</h2>
            <p className="mt-3 text-sm leading-relaxed text-muted-foreground sm:text-base">
              {SITE.name}, {SITE.address}. Founded by {SITE.founder} in {SITE.founded}. Reach the
              studio on{" "}
              <a href={SITE.phoneHref} className="text-foreground underline decoration-border">
                {SITE.phone}
              </a>{" "}
              or{" "}
              <a
                href={SITE.whatsapp}
                target="_blank"
                rel="noreferrer"
                className="text-foreground underline decoration-border"
              >
                WhatsApp
              </a>
              .
            </p>
          </div>
        </div>

        <p className="mt-12 text-sm text-muted-foreground">
          Questions about this note?{" "}
          <Link to="/contact" className="text-foreground underline decoration-border">
            Send an enquiry
          </Link>{" "}
          and we'll answer personally.
        </p>
      </Section>
    </>
  );
}
