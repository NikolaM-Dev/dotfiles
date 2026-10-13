import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { Key } from "@earendil-works/pi-tui";

const MESSAGE = "Please continue";

export default function (pi: ExtensionAPI) {
  pi.registerShortcut(Key.shiftAlt("enter"), {
    description: "Send 'Please continue' to the agent",
    handler: async (ctx: ExtensionContext) => {
      try {
        if (ctx.isIdle()) {
          pi.sendUserMessage(MESSAGE);
          return;
        }
        // Agent is busy — queue as a follow-up so we don't clobber the current turn.
        pi.sendUserMessage(MESSAGE, { deliverAs: "followUp" });
        ctx.ui.notify("Queued 'Please continue' as a follow-up", "info");
      } catch (err) {
        const detail = err instanceof Error ? err.message : String(err);
        ctx.ui.notify(`Failed to send '${MESSAGE}': ${detail}`, "error");
      }
    },
  });
}
