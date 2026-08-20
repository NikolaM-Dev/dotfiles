import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { execFile } from "node:child_process";

const STATUS_KEY = "pi-auto-update";
const CHECK_INTERVAL_MS = 6 * 60 * 60 * 1000;

let lastCheck = 0;
let running = false;

const MAX_RETRIES = 3;
const RETRY_DELAY_MS = 5000;

function sleep(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

function run(command: string, args: string[], env?: NodeJS.ProcessEnv, retries = MAX_RETRIES): Promise<{ stdout: string; stderr: string }> {
  return new Promise((resolve, reject) => {
    execFile(command, args, { env: { ...process.env, ...env }, maxBuffer: 1024 * 1024 * 10 }, async (error, stdout, stderr) => {
      if (error) {
        if (retries > 0) {
          await sleep(RETRY_DELAY_MS);
          try {
            const result = await run(command, args, env, retries - 1);
            resolve(result);
          } catch (retryError) {
            reject(retryError);
          }
          return;
        }
        reject(new Error(`${command} ${args.join(" ")} failed\n${stderr || stdout || String(error)}`));
        return;
      }
      resolve({ stdout: String(stdout), stderr: String(stderr) });
    });
  });
}

function parseVersion(text: string): string | undefined {
  return text.match(/\d+\.\d+\.\d+(?:[-+][0-9A-Za-z.-]+)?/)?.[0];
}

function compareVersions(a: string, b: string): number {
  const pa = a.split(/[.-]/).map((part) => Number.parseInt(part, 10));
  const pb = b.split(/[.-]/).map((part) => Number.parseInt(part, 10));
  for (let i = 0; i < Math.max(pa.length, pb.length); i++) {
    const na = Number.isFinite(pa[i]) ? pa[i] : 0;
    const nb = Number.isFinite(pb[i]) ? pb[i] : 0;
    if (na !== nb) return na > nb ? 1 : -1;
  }
  return 0;
}

async function latestVersion(retries = MAX_RETRIES): Promise<string> {
  try {
    const response = await fetch("https://pi.dev/api/latest-version");
    if (!response.ok) throw new Error(`latest-version returned HTTP ${response.status}`);
    const body = await response.text();
    return parseVersion(body) ?? body.trim();
  } catch (error) {
    if (retries > 0) {
      await sleep(RETRY_DELAY_MS);
      return latestVersion(retries - 1);
    }
    throw error;
  }
}

async function maybeUpdate(ctx: ExtensionContext) {
  if (running) return;
  if (Date.now() - lastCheck < CHECK_INTERVAL_MS) return;

  running = true;
  lastCheck = Date.now();
  ctx.ui.setStatus(STATUS_KEY, "checking pi update…");

  try {
    const current = parseVersion((await run("pi", ["--version"])).stdout);
    const latest = await latestVersion();

    if (!current || !latest || compareVersions(latest, current) <= 0) {
      ctx.ui.setStatus(STATUS_KEY, current ? `pi ${current} up to date` : "pi up to date");
      setTimeout(() => ctx.ui.setStatus(STATUS_KEY, undefined), 5000);
      return;
    }

    ctx.ui.notify(`Pi update available: ${current} → ${latest}. Running pi update --self automatically…`, "info");
    ctx.ui.setStatus(STATUS_KEY, `updating pi ${current} → ${latest}…`);

    await run("pi", ["update", "--self"], {
      // Avoid nested startup version checks in the updater subprocess.
      PI_SKIP_VERSION_CHECK: "1",
    });

    ctx.ui.notify("Pi update finished. Quitting now; restart pi manually to use the updated version.", "info");
    ctx.ui.setStatus(STATUS_KEY, "updated; quitting…");
    ctx.shutdown();
  } catch (error) {
    ctx.ui.notify(`Pi update check failed: ${error instanceof Error ? error.message : String(error)}`, "error");
    ctx.ui.setStatus(STATUS_KEY, "update check failed");
  } finally {
    running = false;
  }
}

export default function (pi: ExtensionAPI) {
  pi.on("session_start", async (event, ctx) => {
    if (event.reason === "reload") return;
    // Let the UI finish starting before doing network/process work.
    setTimeout(() => void maybeUpdate(ctx), 1000);
  });
}
