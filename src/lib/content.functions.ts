import { createServerFn } from "@tanstack/react-start";
import { createClient } from "@supabase/supabase-js";
import { z } from "zod";
import type { Database } from "@/integrations/supabase/types";

export type Product = Database["public"]["Tables"]["products"]["Row"];
export type Project = Database["public"]["Tables"]["projects"]["Row"];
export type Service = Database["public"]["Tables"]["services"]["Row"];

function publicClient() {
  return createClient<Database>(
    process.env["SUPABASE_URL"]!,
    process.env["SUPABASE_PUBLISHABLE_KEY"]!,
    { auth: { storage: undefined, persistSession: false, autoRefreshToken: false } },
  );
}

/**
 * Images stored in the private "site-images" bucket are saved as bucket paths.
 * Turn those into time-limited viewable links; leave absolute URLs untouched.
 */
async function resolveImage(value: string | null): Promise<string | null> {
  if (!value) return null;
  if (/^https?:\/\//i.test(value) || value.startsWith("/")) return value;
  const { supabaseAdmin } = await import("@/integrations/supabase/client.server");
  const { data } = await supabaseAdmin.storage
    .from("site-images")
    .createSignedUrl(value, 60 * 60 * 24 * 7);
  return data?.signedUrl ?? null;
}

async function resolveMany(values: string[]): Promise<string[]> {
  const resolved = await Promise.all(values.map((v) => resolveImage(v)));
  return resolved.filter((v): v is string => Boolean(v));
}

async function withProductImages(rows: Product[]): Promise<Product[]> {
  return Promise.all(
    rows.map(async (row) => ({ ...row, image_url: await resolveImage(row.image_url) })),
  );
}

async function withProjectImages(rows: Project[]): Promise<Project[]> {
  return Promise.all(
    rows.map(async (row) => ({
      ...row,
      cover_image_url: await resolveImage(row.cover_image_url),
      gallery_urls: await resolveMany(row.gallery_urls ?? []),
    })),
  );
}

export const listProducts = createServerFn({ method: "GET" }).handler(async () => {
  const { data, error } = await publicClient()
    .from("products")
    .select("*")
    .eq("published", true)
    .order("sort_order", { ascending: true });
  if (error) throw new Error(error.message);
  return withProductImages(data ?? []);
});

export const listFeaturedProducts = createServerFn({ method: "GET" }).handler(async () => {
  const { data, error } = await publicClient()
    .from("products")
    .select("*")
    .eq("published", true)
    .eq("featured", true)
    .order("sort_order", { ascending: true })
    .limit(6);
  if (error) throw new Error(error.message);
  return withProductImages(data ?? []);
});

export const listProjects = createServerFn({ method: "GET" }).handler(async () => {
  const { data, error } = await publicClient()
    .from("projects")
    .select("*")
    .eq("published", true)
    .order("sort_order", { ascending: true });
  if (error) throw new Error(error.message);
  return withProjectImages(data ?? []);
});

export const listServices = createServerFn({ method: "GET" }).handler(async () => {
  const { data, error } = await publicClient()
    .from("services")
    .select("*")
    .eq("published", true)
    .order("sort_order", { ascending: true });
  if (error) throw new Error(error.message);
  return data ?? [];
});

export const getProjectBySlug = createServerFn({ method: "GET" })
  .inputValidator((data) => z.object({ slug: z.string().min(1) }).parse(data))
  .handler(async ({ data }) => {
    const client = publicClient();
    const { data: row, error } = await client
      .from("projects")
      .select("*")
      .eq("slug", data.slug)
      .eq("published", true)
      .maybeSingle();
    if (error) throw new Error(error.message);
    if (!row) return null;
    const [project] = await withProjectImages([row]);
    const { data: related } = await client
      .from("projects")
      .select("*")
      .eq("published", true)
      .neq("slug", data.slug)
      .order("sort_order", { ascending: true })
      .limit(3);
    return { project, related: await withProjectImages(related ?? []) };
  });

export const submitEnquiry = createServerFn({ method: "POST" })
  .inputValidator((data) =>
    z
      .object({
        name: z.string().trim().min(2).max(120),
        email: z.string().trim().email().max(180),
        phone: z.string().trim().max(40).optional().default(""),
        interest: z.string().trim().max(120).optional().default("General"),
        message: z.string().trim().min(5).max(2000),
      })
      .parse(data),
  )
  .handler(async ({ data }) => {
    const { error } = await publicClient().from("enquiries").insert({
      name: data.name,
      email: data.email,
      phone: data.phone,
      interest: data.interest,
      message: data.message,
    });
    if (error) throw new Error(error.message);
    return { ok: true as const };
  });
