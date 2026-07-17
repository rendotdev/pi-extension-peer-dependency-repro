import { Type } from "typebox";

export default function (pi) {
  pi.registerTool({
    name: "typebox_peer_repro",
    label: "TypeBox peer repro",
    description: "A minimal tool whose schema imports Pi's documented TypeBox peer dependency.",
    parameters: Type.Object({}),
    async execute() {
      return {
        content: [{ type: "text", text: "The TypeBox peer dependency resolved." }],
        details: {},
      };
    },
  });
}
