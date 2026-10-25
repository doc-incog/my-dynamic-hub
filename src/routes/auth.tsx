import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useEffect, useState, type FormEvent } from "react";
import { toast } from "sonner";
import { supabase } from "@/integrations/supabase/client";
import { lovable } from "@/integrations/lovable";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { SITE } from "@/lib/site";

export const Route = createFileRoute("/auth")({
  head: () => ({
    meta: [
      { title: "Owner login — KRITI'S KIRTI" },
      { name: "description", content: "Sign in to manage the KRITI'S KIRTI website." },
      { property: "og:title", content: "Owner login — KRITI'S KIRTI" },
      { property: "og:description", content: "Private studio area for the site owner." },
      { name: "robots", content: "noindex" },
    ],
  }),
  component: AuthPage,
});

function AuthPage() {
  const navigate = useNavigate();
  const [mode, setMode] = useState<"signin" | "signup">("signin");
  const [busy, setBusy] = useState(false);
  const [checkEmail, setCheckEmail] = useState(false);

  useEffect(() => {
    supabase.auth.getSession().then(({ data }) => {
      if (data.session) navigate({ to: "/admin", replace: true });
    });
    const { data } = supabase.auth.onAuthStateChange((event, session) => {
      if (event === "SIGNED_IN" && session) navigate({ to: "/admin", replace: true });
    });
    return () => data.subscription.unsubscribe();
  }, [navigate]);

  async function onSubmit(e: FormEvent<HTMLFormElement>) {
    e.preventDefault();
    const fd = new FormData(e.currentTarget);
    const email = String(fd.get("email"));
    const password = String(fd.get("password"));
    setBusy(true);
    try {
      if (mode === "signin") {
        const { error } = await supabase.auth.signInWithPassword({ email, password });
        if (error) throw error;
      } else {
        const { data, error } = await supabase.auth.signUp({
          email,
          password,
          options: { emailRedirectTo: `${window.location.origin}/admin` },
        });
        if (error) throw error;
        if (!data.session) setCheckEmail(true);
      }
    } catch (err) {
      toast.error(err instanceof Error ? err.message : "Something went wrong");
    } finally {
      setBusy(false);
    }
  }

  async function google() {
    const result = await lovable.auth.signInWithOAuth("google", {
      redirect_uri: `${window.location.origin}/auth`,
    });
    if (result.error) toast.error("Google sign-in didn't complete. Please try again.");
  }

  return (
    <div className="surface-warm flex min-h-[75vh] items-center justify-center px-5 py-16">
      <div className="w-full max-w-md rounded-sm border border-border bg-card p-8 shadow-soft sm:p-10">
        <p className="eyebrow">{SITE.name} studio</p>
        <h1 className="mt-3 text-3xl text-foreground">
          {mode === "signin" ? "Owner login" : "Create the owner account"}
        </h1>
        <p className="mt-2 text-sm text-muted-foreground">
          {mode === "signin"
            ? "Manage products, projects, services and enquiries."
            : "The first account created becomes the site owner."}
        </p>

        {checkEmail ? (
          <p className="mt-8 rounded-sm border border-border bg-secondary/50 p-4 text-sm text-foreground">
            Check your inbox and click the confirmation link to finish setting up your account.
          </p>
        ) : (
          <>
            <form onSubmit={onSubmit} className="mt-8 space-y-5">
              <div className="space-y-2">
                <Label htmlFor="email">Email</Label>
                <Input id="email" name="email" type="email" required autoComplete="email" />
              </div>
              <div className="space-y-2">
                <Label htmlFor="password">Password</Label>
                <Input
                  id="password"
                  name="password"
                  type="password"
                  required
                  minLength={8}
                  autoComplete={mode === "signin" ? "current-password" : "new-password"}
                />
              </div>
              <button
                type="submit"
                disabled={busy}
                className="w-full rounded-sm bg-primary px-5 py-3 text-xs font-semibold uppercase tracking-[0.18em] text-primary-foreground transition-colors hover:bg-primary/90 disabled:opacity-60"
              >
                {busy ? "Please wait…" : mode === "signin" ? "Sign in" : "Create account"}
              </button>
            </form>
            <div className="my-6 flex items-center gap-3 text-xs text-muted-foreground">
              <span className="h-px flex-1 bg-border" /> or <span className="h-px flex-1 bg-border" />
            </div>
            <button
              type="button"
              onClick={google}
              className="w-full rounded-sm border border-border px-5 py-3 text-xs font-semibold uppercase tracking-[0.18em] text-foreground transition-colors hover:bg-secondary"
            >
              Continue with Google
            </button>
          </>
        )}

        <button
          type="button"
          onClick={() => {
            setMode(mode === "signin" ? "signup" : "signin");
            setCheckEmail(false);
          }}
          className="mt-6 text-xs text-muted-foreground underline-offset-4 hover:text-foreground hover:underline"
        >
          {mode === "signin" ? "First time here? Create the owner account" : "Already have an account? Sign in"}
        </button>
      </div>
    </div>
  );
}
