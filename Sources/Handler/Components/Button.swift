struct ShButton {
    static func render(
        varName: String, text: String, variant: String = "default", size: String = "md"
    ) -> String {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("button"))
            jsVar(varName).addClass("sh-btn")
            jsVar(varName).setTextContent(text)

            // Variant class
            jsSwitch(
                jsString(variant),
                cases: [
                    jsSwitchCase(jsString("secondary")) {
                        jsVar(varName).addClass("sh-btn-secondary")
                    },
                    jsSwitchCase(jsString("destructive")) {
                        jsVar(varName).addClass("sh-btn-destructive")
                    },
                    jsSwitchCase(jsString("ghost")) { jsVar(varName).addClass("sh-btn-ghost") },
                    jsSwitchCase(jsString("outline")) { jsVar(varName).addClass("sh-btn-outline") },
                ],
                default: [
                    jsVar(varName).addClass("sh-btn-default")
                ])

            // Size class
            jsSwitch(
                jsString(size),
                cases: [
                    jsSwitchCase(jsString("sm")) { jsVar(varName).addClass("sh-btn-sm") },
                    jsSwitchCase(jsString("lg")) { jsVar(varName).addClass("sh-btn-lg") },
                ],
                default: [
                    jsVar(varName).addClass("sh-btn-md")
                ])
        }
    }
}
