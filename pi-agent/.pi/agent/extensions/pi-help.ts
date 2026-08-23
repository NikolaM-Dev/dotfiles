import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { createRequire } from "node:module";
import { dirname, join } from "node:path";
import { existsSync, readFileSync, realpathSync } from "node:fs";
import { fileURLToPath } from "node:url";

// Supported package names — the project was renamed from @mariozechner to @earendil-works.
const PACKAGE_NAMES = [
  "@earendil-works/pi-coding-agent",
  "@mariozechner/pi-coding-agent",
] as const;

function isPiPackageName(name?: string): boolean {
  return (PACKAGE_NAMES as readonly string[]).includes(name ?? "");
}

function findPiPackageRoot(startPath?: string): string | undefined {
  if (!startPath) return undefined;

  let resolvedStart: string;
  try {
    // startPath may be a file URL or a plain path.
    const asPath = startPath.startsWith("file://") ? fileURLToPath(startPath) : startPath;
    resolvedStart = realpathSync(asPath);
  } catch {
    return undefined;
  }

  let currentDir = dirname(resolvedStart);

  while (true) {
    const packageJsonPath = join(currentDir, "package.json");
    if (existsSync(packageJsonPath)) {
      try {
        const pkg = JSON.parse(readFileSync(packageJsonPath, "utf8")) as { name?: string };
        if (isPiPackageName(pkg.name)) return currentDir;
      } catch {
        // Ignore invalid JSON and keep walking.
      }
    }
    const parentDir = dirname(currentDir);
    if (parentDir === currentDir) return undefined;
    currentDir = parentDir;
  }
}

function resolvePiPackageRoot(): string {
  // 1) Try Node's resolver — covers npm installs. Try multiple bases because
  //    extensions loaded via jiti may not have pi in their local node_modules.
  const bases: (string | undefined)[] = [import.meta.url, process.argv[1]];
  for (const base of bases) {
    if (!base) continue;
    const baseForRequire = base.startsWith("file://") ? base : `file://${base}`;
    for (const pkgName of PACKAGE_NAMES) {
      try {
        const require = createRequire(baseForRequire);
        return dirname(require.resolve(`${pkgName}/package.json`));
      } catch {
        // Try next name / base.
      }
    }
  }

  // 2) Walk up from known entry points (covers install.sh / standalone builds).
  for (const start of [process.argv[1], import.meta.url]) {
    const found = findPiPackageRoot(start);
    if (found) return found;
  }

  throw new Error(
    `Could not locate the installed pi-coding-agent package (tried: ${PACKAGE_NAMES.join(", ")}).`,
  );
}

function buildHelpPrompt(question: string): string {
  const packageRoot = resolvePiPackageRoot();
  const readmePath = join(packageRoot, "README.md");
  const docsDir = join(packageRoot, "docs");
  const examplesDir = join(packageRoot, "examples");

  return [
    "You are answering a question about pi itself.",
    "",
    "Before answering:",
    `- Read pi's installed local README first: ${readmePath}`,
    `- Use pi's local docs directory to find the most relevant docs: ${docsDir}`,
    `- Use pi's local examples directory when examples would help: ${examplesDir}`,
    "- Follow markdown cross-references to related docs and examples before answering.",
    "- Do not answer from memory when the docs are available.",
    "- In the final answer, mention which file paths you inspected.",
    "",
    "Helpful topic guide:",
    `- extensions: ${join(docsDir, "extensions.md")}`,
    `- themes: ${join(docsDir, "themes.md")}`,
    `- skills: ${join(docsDir, "skills.md")}`,
    `- prompt templates: ${join(docsDir, "prompt-templates.md")}`,
    `- TUI/components: ${join(docsDir, "tui.md")}`,
    `- keybindings: ${join(docsDir, "keybindings.md")}`,
    `- SDK/integrations: ${join(docsDir, "sdk.md")}`,
    `- custom providers: ${join(docsDir, "custom-provider.md")}`,
    `- adding models: ${join(docsDir, "models.md")}`,
    `- packages: ${join(docsDir, "packages.md")}`,
    "",
    `Question: ${question}`,
  ].join("\n");
}

export default function (pi: ExtensionAPI) {
  pi.registerCommand("help", {
    description: "Ask a question about pi and have pi inspect its own docs before answering",
    handler: async (args, ctx) => {
      let question = args.trim();

      // No args → prompt interactively (TUI/RPC only).
      if (!question) {
        if (!ctx.hasUI) return;
        const value = await ctx.ui.input("Ask pi a question about pi", "How do I create an extension?");
        question = value?.trim() ?? "";
        if (!question) {
          ctx.ui.notify("Help request cancelled", "info");
          return;
        }
      }

      let message: string;
      try {
        message = buildHelpPrompt(question);
      } catch (err) {
        const detail = err instanceof Error ? err.message : String(err);
        ctx.ui.notify(`pi help failed: ${detail}`, "error");
        return;
      }

      // If the agent is idle, inject directly. Otherwise queue as follow-up
      // so we don't clobber the current turn.
      try {
        if (ctx.isIdle()) {
          pi.sendUserMessage(message);
          return;
        }
        pi.sendUserMessage(message, { deliverAs: "followUp" });
        ctx.ui.notify("Queued pi help as a follow-up", "info");
      } catch (err) {
        const detail = err instanceof Error ? err.message : String(err);
        ctx.ui.notify(`Failed to send help prompt: ${detail}`, "error");
      }
    },
  });
}
