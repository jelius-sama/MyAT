struct ShCard {
    static func render(varName: String) -> String {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("div"))
            jsVar(varName).addClass("sh-card")
        }.jsSafe
    }

    static func header(into card: String, varName: String) -> String {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("div"))
            jsVar(varName).addClass("sh-card-header")
            jsVar(card).appendChild(jsVar(varName))
        }.jsSafe
    }

    static func content(into card: String, varName: String) -> String {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("div"))
            jsVar(varName).addClass("sh-card-content")
            jsVar(card).appendChild(jsVar(varName))
        }.jsSafe
    }

    static func footer(into card: String, varName: String) -> String {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("div"))
            jsVar(varName).addClass("sh-card-footer")
            jsVar(card).appendChild(jsVar(varName))
        }.jsSafe
    }
}
