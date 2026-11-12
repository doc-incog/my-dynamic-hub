import { Link } from "@tanstack/react-router";
import { Facebook, Instagram, MapPin, MessageCircle, Phone } from "lucide-react";
import { NAV_LINKS, SITE } from "@/lib/site";

export function Footer() {
  return (
    <footer className="mt-24 border-t border-border bg-secondary/40">
      <div className="mx-auto grid max-w-7xl gap-12 px-5 py-16 sm:px-8 md:grid-cols-[1.4fr_1fr_1fr]">
        <div>
          <p className="font-display text-xl font-semibold tracking-[0.1em] text-foreground">
            {SITE.name}
          </p>
          <p className="mt-3 max-w-sm text-sm leading-relaxed text-muted-foreground">
            {SITE.tagline}. A signature handcrafted initiative founded by {SITE.founder}, turning
            locally available and eco-friendly materials into functional, decorative pieces for
            everyday life and interior spaces.
          </p>
          <p className="eyebrow mt-6">{SITE.philosophy}</p>
        </div>

        <div>
          <p className="eyebrow">Explore</p>
          <ul className="mt-4 space-y-2.5">
            {NAV_LINKS.map((link) => (
              <li key={link.to}>
                <Link
                  to={link.to}
                  className="text-sm text-muted-foreground transition-colors hover:text-foreground"
                >
                  {link.label}
                </Link>
              </li>
            ))}
          </ul>
        </div>

        <div>
          <p className="eyebrow">Studio</p>
          <ul className="mt-4 space-y-2.5 text-sm text-muted-foreground">
            <li className="flex items-start gap-2">
              <MapPin className="mt-0.5 size-4 shrink-0 text-accent" aria-hidden="true" />
              <span>{SITE.address}</span>
            </li>
            <li className="flex items-start gap-2">
              <Phone className="mt-0.5 size-4 shrink-0 text-accent" aria-hidden="true" />
              <a href={SITE.phoneHref} className="transition-colors hover:text-foreground">
                {SITE.phone}
              </a>
            </li>
            <li className="flex items-start gap-2">
              <MessageCircle className="mt-0.5 size-4 shrink-0 text-accent" aria-hidden="true" />
              <a
                href={SITE.whatsapp}
                target="_blank"
                rel="noreferrer"
                className="transition-colors hover:text-foreground"
              >
                Message on WhatsApp
              </a>
            </li>
            {SITE.email ? (
              <li>
                <a href={`mailto:${SITE.email}`} className="transition-colors hover:text-foreground">
                  {SITE.email}
                </a>
              </li>
            ) : null}
            <li>
              <Link to="/contact" className="transition-colors hover:text-foreground">
                Send an enquiry
              </Link>
            </li>
          </ul>
          <div className="mt-5 flex items-center gap-3">
            <a
              href={SITE.instagram}
              target="_blank"
              rel="noreferrer"
              aria-label={`${SITE.name} on Instagram`}
              className="rounded-sm border border-border p-2 text-muted-foreground transition-colors hover:border-accent hover:text-foreground"
            >
              <Instagram className="size-4" />
            </a>
            <a
              href={SITE.facebook}
              target="_blank"
              rel="noreferrer"
              aria-label={`${SITE.name} on Facebook`}
              className="rounded-sm border border-border p-2 text-muted-foreground transition-colors hover:border-accent hover:text-foreground"
            >
              <Facebook className="size-4" />
            </a>
            <a
              href={SITE.whatsapp}
              target="_blank"
              rel="noreferrer"
              aria-label={`${SITE.name} on WhatsApp`}
              className="rounded-sm border border-border p-2 text-muted-foreground transition-colors hover:border-accent hover:text-foreground"
            >
              <MessageCircle className="size-4" />
            </a>
          </div>
        </div>
      </div>

      <div className="border-t border-border/70">
        <div className="mx-auto flex max-w-7xl flex-col gap-3 px-5 py-6 text-xs text-muted-foreground sm:flex-row sm:items-center sm:justify-between sm:px-8">
          <p>
            &copy; {new Date().getFullYear()} {SITE.name}. {SITE.origin}.
          </p>
          <div className="flex items-center gap-5">
            <span>{SITE.principle}</span>
            <Link to="/auth" className="transition-colors hover:text-foreground">
              Owner login
            </Link>
          </div>
        </div>
      </div>
    </footer>
  );
}
