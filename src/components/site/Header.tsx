import { Link } from "@tanstack/react-router";
import { useState } from "react";
import { Menu, X } from "lucide-react";
import { NAV_LINKS, SITE } from "@/lib/site";
import { useSiteSession } from "@/hooks/useSiteSession";
import { cn } from "@/lib/utils";

export function Header() {
  const [open, setOpen] = useState(false);
  const { user } = useSiteSession();

  return (
    <header className="sticky top-0 z-40 border-b border-border/70 bg-background/85 backdrop-blur-md">
      <div className="mx-auto flex max-w-7xl items-center justify-between gap-6 px-5 py-4 sm:px-8">
        <Link to="/" className="group flex flex-col leading-none" onClick={() => setOpen(false)}>
          <span className="font-display text-lg font-semibold tracking-[0.12em] text-foreground sm:text-xl">
            {SITE.name}
          </span>
          <span className="mt-1 hidden text-[0.6rem] font-semibold uppercase tracking-[0.28em] text-muted-foreground sm:block">
            {SITE.origin}
          </span>
        </Link>

        <nav className="hidden items-center gap-8 md:flex">
          {NAV_LINKS.map((link) => (
            <Link
              key={link.to}
              to={link.to}
              activeOptions={{ exact: link.to === "/" }}
              className="relative text-sm font-medium text-muted-foreground transition-colors hover:text-foreground data-[status=active]:text-foreground"
            >
              {link.label}
            </Link>
          ))}
        </nav>

        <div className="hidden items-center gap-3 md:flex">
          {user ? (
            <Link
              to="/admin"
              className="rounded-sm border border-border px-3 py-2 text-xs font-semibold uppercase tracking-[0.16em] text-foreground transition-colors hover:bg-secondary"
            >
              Studio
            </Link>
          ) : null}
          <Link
            to="/contact"
            className="rounded-sm bg-primary px-5 py-2.5 text-xs font-semibold uppercase tracking-[0.16em] text-primary-foreground transition-colors hover:bg-primary/90"
          >
            Enquire
          </Link>
        </div>

        <button
          type="button"
          aria-label={open ? "Close menu" : "Open menu"}
          onClick={() => setOpen((v) => !v)}
          className="inline-flex items-center justify-center rounded-sm border border-border p-2 text-foreground md:hidden"
        >
          {open ? <X className="size-5" /> : <Menu className="size-5" />}
        </button>
      </div>

      <div
        className={cn(
          "overflow-hidden border-t border-border/70 bg-background md:hidden",
          open ? "block" : "hidden",
        )}
      >
        <nav className="flex flex-col px-5 py-3">
          {NAV_LINKS.map((link) => (
            <Link
              key={link.to}
              to={link.to}
              activeOptions={{ exact: link.to === "/" }}
              onClick={() => setOpen(false)}
              className="border-b border-border/60 py-3 text-sm font-medium text-muted-foreground last:border-b-0 data-[status=active]:text-foreground"
            >
              {link.label}
            </Link>
          ))}
          {user ? (
            <Link
              to="/admin"
              onClick={() => setOpen(false)}
              className="py-3 text-sm font-medium text-muted-foreground"
            >
              Studio
            </Link>
          ) : null}
        </nav>
      </div>
    </header>
  );
}
