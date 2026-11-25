import { useEffect, useState } from "react";
import { Link, useRouterState } from "@tanstack/react-router";
import { Wifi } from "lucide-react";
import { Dialog, DialogContent, DialogDescription, DialogTitle } from "@/components/ui/dialog";

const KEY = "mills-wifi-prompt-seen";

export function WifiPrompt() {
  const pathname = useRouterState({ select: (s) => s.location.pathname });
  const [open, setOpen] = useState(false);
  const excluded = pathname.startsWith("/wifi") || pathname.startsWith("/admin");

  useEffect(() => {
    if (excluded) return;
    try {
      if (sessionStorage.getItem(KEY)) return;
      sessionStorage.setItem(KEY, "1");
    } catch {
      return;
    }
    const t = window.setTimeout(() => setOpen(true), 2500);
    return () => window.clearTimeout(t);
  }, [excluded]);

  if (excluded) return null;

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogContent className="max-w-sm text-center">
        <div className="mx-auto mb-2 flex h-14 w-14 items-center justify-center rounded-full bg-primary/15 text-primary">
          <Wifi className="h-7 w-7" />
        </div>
        <DialogTitle className="text-2xl">Need Wi-Fi?</DialogTitle>
        <DialogDescription>Get free guest Wi-Fi while you're at Mills Modern Social.</DialogDescription>
        <div className="mt-4 flex flex-col gap-2">
          <Link
            to="/wifi"
            onClick={() => setOpen(false)}
            className="rounded-full bg-primary px-6 py-3 font-semibold text-primary-foreground transition hover:opacity-90"
          >
            Click here to connect
          </Link>
          <button onClick={() => setOpen(false)} className="text-sm text-muted-foreground hover:text-foreground">
            No thanks
          </button>
        </div>
      </DialogContent>
    </Dialog>
  );
}
