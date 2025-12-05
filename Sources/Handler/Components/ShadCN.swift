struct ShTheme {
    static func getStyles() -> String {
        return """
            :root {
                --background: 0 0% 100%;
                --foreground: 222.2 84% 4.9%;
                --card: 0 0% 100%;
                --card-foreground: 222.2 84% 4.9%;
                --popover: 0 0% 100%;
                --popover-foreground: 222.2 84% 4.9%;
                --primary: 222.2 47.4% 11.2%;
                --primary-foreground: 210 40% 98%;
                --secondary: 210 40% 96.1%;
                --secondary-foreground: 222.2 47.4% 11.2%;
                --muted: 210 40% 96.1%;
                --muted-foreground: 215.4 16.3% 46.9%;
                --accent: 210 40% 96.1%;
                --accent-foreground: 222.2 47.4% 11.2%;
                --destructive: 0 84.2% 60.2%;
                --destructive-foreground: 210 40% 98%;
                --border: 214.3 31.8% 91.4%;
                --input: 214.3 31.8% 91.4%;
                --ring: 222.2 84% 4.9%;
                --radius: 0.5rem;
            }

            .dark {
                --background: 222.2 84% 4.9%;
                --foreground: 210 40% 98%;
                --card: 222.2 84% 4.9%;
                --card-foreground: 210 40% 98%;
                --popover: 222.2 84% 4.9%;
                --popover-foreground: 210 40% 98%;
                --primary: 210 40% 98%;
                --primary-foreground: 222.2 47.4% 11.2%;
                --secondary: 217.2 32.6% 17.5%;
                --secondary-foreground: 210 40% 98%;
                --muted: 217.2 32.6% 17.5%;
                --muted-foreground: 215 20.2% 65.1%;
                --accent: 217.2 32.6% 17.5%;
                --accent-foreground: 210 40% 98%;
                --destructive: 0 62.8% 30.6%;
                --destructive-foreground: 210 40% 98%;
                --border: 217.2 32.6% 17.5%;
                --input: 217.2 32.6% 17.5%;
                --ring: 212.7 26.8% 83.9%;
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                background-color: hsl(var(--background));
                color: hsl(var(--foreground));
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
                line-height: 1.5;
                transition: background-color 0.3s ease, color 0.3s ease;
            }

            /* Button Styles */
            .sh-btn {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                border-radius: var(--radius);
                font-size: 0.875rem;
                font-weight: 500;
                cursor: pointer;
                border: 1px solid transparent;
                transition: all 0.15s ease;
                outline: none;
                user-select: none;
            }

            .sh-btn:focus-visible {
                outline: 2px solid hsl(var(--ring));
                outline-offset: 2px;
            }

            .sh-btn:disabled {
                pointer-events: none;
                opacity: 0.5;
            }

            .sh-btn-default {
                background: hsl(var(--primary));
                color: hsl(var(--primary-foreground));
            }

            .sh-btn-default:hover {
                opacity: 0.9;
            }

            .sh-btn-secondary {
                background: hsl(var(--secondary));
                color: hsl(var(--secondary-foreground));
            }

            .sh-btn-secondary:hover {
                opacity: 0.8;
            }

            .sh-btn-destructive {
                background: hsl(var(--destructive));
                color: hsl(var(--destructive-foreground));
            }

            .sh-btn-destructive:hover {
                opacity: 0.9;
            }

            .sh-btn-outline {
                border: 1px solid hsl(var(--input));
                background: transparent;
                color: hsl(var(--foreground));
            }

            .sh-btn-outline:hover {
                background: hsl(var(--accent));
                color: hsl(var(--accent-foreground));
            }

            .sh-btn-ghost {
                background: transparent;
                color: hsl(var(--foreground));
            }

            .sh-btn-ghost:hover {
                background: hsl(var(--accent));
                color: hsl(var(--accent-foreground));
            }

            .sh-btn-sm { padding: 0.5rem 0.75rem; font-size: 0.75rem; }
            .sh-btn-md { padding: 0.625rem 1rem; }
            .sh-btn-lg { padding: 0.75rem 1.5rem; font-size: 1rem; }

            /* Card Styles */
            .sh-card {
                border: 1px solid hsl(var(--border));
                border-radius: calc(var(--radius) + 4px);
                background: hsl(var(--card));
                color: hsl(var(--card-foreground));
                box-shadow: 0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1);
                transition: all 0.2s ease;
            }

            .sh-card-header {
                padding: 1.5rem;
                display: flex;
                flex-direction: column;
                gap: 0.375rem;
            }

            .sh-card-title {
                font-size: 1.5rem;
                font-weight: 600;
                line-height: 1;
                letter-spacing: -0.025em;
            }

            .sh-card-description {
                font-size: 0.875rem;
                color: hsl(var(--muted-foreground));
            }

            .sh-card-content {
                padding: 1.5rem;
                padding-top: 0;
            }

            .sh-card-footer {
                padding: 1.5rem;
                padding-top: 0;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            /* Skeleton Styles */
            .sh-skeleton {
                background: hsl(var(--muted));
                border-radius: var(--radius);
                animation: sh-skeleton-pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
            }

            @keyframes sh-skeleton-pulse {
                0%, 100% { opacity: 1; }
                50% { opacity: 0.5; }
            }

            /* Badge Styles */
            .sh-badge {
                display: inline-flex;
                align-items: center;
                border-radius: 9999px;
                padding: 0.25rem 0.625rem;
                font-size: 0.75rem;
                font-weight: 600;
                transition: all 0.15s ease;
                border: 1px solid transparent;
            }

            .sh-badge-default {
                background: hsl(var(--primary));
                color: hsl(var(--primary-foreground));
            }

            .sh-badge-secondary {
                background: hsl(var(--secondary));
                color: hsl(var(--secondary-foreground));
            }

            .sh-badge-destructive {
                background: hsl(var(--destructive));
                color: hsl(var(--destructive-foreground));
            }

            .sh-badge-outline {
                border: 1px solid hsl(var(--border));
                color: hsl(var(--foreground));
            }

            /* Input Styles */
            .sh-input {
                display: flex;
                width: 100%;
                border-radius: var(--radius);
                border: 1px solid hsl(var(--input));
                background: hsl(var(--background));
                padding: 0.5rem 0.75rem;
                font-size: 0.875rem;
                color: hsl(var(--foreground));
                transition: all 0.15s ease;
                outline: none;
            }

            .sh-input:focus {
                border-color: hsl(var(--ring));
                box-shadow: 0 0 0 1px hsl(var(--ring));
            }

            .sh-input:disabled {
                opacity: 0.5;
                cursor: not-allowed;
            }

            /* Select Styles */
            .sh-select {
                position: relative;
                display: inline-block;
                width: 100%;
            }

            .sh-select-trigger {
                display: flex;
                align-items: center;
                justify-content: space-between;
                width: 100%;
                border-radius: var(--radius);
                border: 1px solid hsl(var(--input));
                background: hsl(var(--background));
                padding: 0.5rem 0.75rem;
                font-size: 0.875rem;
                color: hsl(var(--foreground));
                cursor: pointer;
                transition: all 0.15s ease;
                outline: none;
            }

            .sh-select-trigger:hover {
                border-color: hsl(var(--ring));
            }

            .sh-select-trigger:focus {
                border-color: hsl(var(--ring));
                box-shadow: 0 0 0 1px hsl(var(--ring));
            }

            .sh-select-content {
                position: absolute;
                top: calc(100% + 4px);
                left: 0;
                right: 0;
                z-index: 50;
                max-height: 16rem;
                overflow: auto;
                border-radius: var(--radius);
                border: 1px solid hsl(var(--border));
                background: hsl(var(--popover));
                box-shadow: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
                display: none;
            }

            .sh-select-content.open {
                display: block;
            }

            .sh-select-item {
                padding: 0.5rem 0.75rem;
                font-size: 0.875rem;
                cursor: pointer;
                transition: all 0.15s ease;
                outline: none;
            }

            .sh-select-item:hover {
                background: hsl(var(--accent));
                color: hsl(var(--accent-foreground));
            }

            .sh-select-item.selected {
                background: hsl(var(--accent));
                font-weight: 600;
            }

            /* Modal Styles */
            .sh-modal-overlay {
                position: fixed;
                inset: 0;
                z-index: 50;
                background: rgba(0, 0, 0, 0.8);
                display: none;
                align-items: center;
                justify-content: center;
                animation: sh-fade-in 0.15s ease-out;
            }

            .sh-modal-overlay.open {
                display: flex;
            }

            @keyframes sh-fade-in {
                from { opacity: 0; }
                to { opacity: 1; }
            }

            .sh-modal-content {
                position: relative;
                width: 90%;
                max-width: 32rem;
                background: hsl(var(--background));
                border: 1px solid hsl(var(--border));
                border-radius: calc(var(--radius) + 4px);
                box-shadow: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1);
                animation: sh-modal-slide-in 0.2s ease-out;
            }

            @keyframes sh-modal-slide-in {
                from {
                    opacity: 0;
                    transform: translateY(-1rem) scale(0.95);
                }
                to {
                    opacity: 1;
                    transform: translateY(0) scale(1);
                }
            }

            .sh-modal-header {
                padding: 1.5rem;
                padding-bottom: 1rem;
            }

            .sh-modal-title {
                font-size: 1.125rem;
                font-weight: 600;
                line-height: 1;
            }

            .sh-modal-description {
                font-size: 0.875rem;
                color: hsl(var(--muted-foreground));
                margin-top: 0.5rem;
            }

            .sh-modal-body {
                padding: 1.5rem;
                padding-top: 0;
            }

            .sh-modal-footer {
                padding: 1.5rem;
                padding-top: 0;
                display: flex;
                justify-content: flex-end;
                gap: 0.5rem;
            }

            .sh-modal-close {
                position: absolute;
                top: 1rem;
                right: 1rem;
                width: 1.5rem;
                height: 1.5rem;
                border-radius: var(--radius);
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                opacity: 0.7;
                transition: opacity 0.15s ease;
                background: transparent;
                border: none;
                color: hsl(var(--foreground));
            }

            .sh-modal-close:hover {
                opacity: 1;
            }

            /* Sidebar Styles */
            .sh-sidebar {
                position: fixed;
                top: 0;
                left: 0;
                bottom: 0;
                width: 16rem;
                background: hsl(var(--card));
                border-right: 1px solid hsl(var(--border));
                display: flex;
                flex-direction: column;
                transition: transform 0.3s ease;
                z-index: 40;
            }

            .sh-sidebar.collapsed {
                transform: translateX(-100%);
            }

            .sh-sidebar-header {
                padding: 1.5rem;
                border-bottom: 1px solid hsl(var(--border));
            }

            .sh-sidebar-content {
                flex: 1;
                overflow-y: auto;
                padding: 1rem;
            }

            .sh-sidebar-footer {
                padding: 1rem 1.5rem;
                border-top: 1px solid hsl(var(--border));
            }

            .sh-sidebar-item {
                display: flex;
                align-items: center;
                gap: 0.75rem;
                padding: 0.625rem 0.75rem;
                border-radius: var(--radius);
                font-size: 0.875rem;
                cursor: pointer;
                transition: all 0.15s ease;
                margin-bottom: 0.25rem;
                color: hsl(var(--foreground));
                text-decoration: none;
            }

            .sh-sidebar-item:hover {
                background: hsl(var(--accent));
                color: hsl(var(--accent-foreground));
            }

            .sh-sidebar-item.active {
                background: hsl(var(--accent));
                font-weight: 600;
            }

            /* Avatar Styles */
            .sh-avatar {
                position: relative;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                border-radius: 9999px;
                overflow: hidden;
                background: hsl(var(--muted));
            }

            .sh-avatar-sm { width: 2rem; height: 2rem; }
            .sh-avatar-md { width: 2.5rem; height: 2.5rem; }
            .sh-avatar-lg { width: 3rem; height: 3rem; }

            .sh-avatar-image {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .sh-avatar-fallback {
                width: 100%;
                height: 100%;
                display: flex;
                align-items: center;
                justify-content: center;
                background: hsl(var(--muted));
                color: hsl(var(--muted-foreground));
                font-size: 0.875rem;
                font-weight: 500;
            }

            /* Progress Styles */
            .sh-progress {
                width: 100%;
                height: 0.5rem;
                background: hsl(var(--secondary));
                border-radius: 9999px;
                overflow: hidden;
            }

            .sh-progress-bar {
                height: 100%;
                background: hsl(var(--primary));
                transition: width 0.3s ease;
            }

            /* Separator Styles */
            .sh-separator {
                background: hsl(var(--border));
            }

            .sh-separator-horizontal {
                height: 1px;
                width: 100%;
            }

            .sh-separator-vertical {
                width: 1px;
                height: 100%;
            }

            /* Tabs Styles */
            .sh-tabs {
                width: 100%;
            }

            .sh-tabs-list {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                border-radius: var(--radius);
                background: hsl(var(--muted));
                padding: 0.25rem;
                gap: 0.25rem;
            }

            .sh-tabs-trigger {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                padding: 0.5rem 0.75rem;
                font-size: 0.875rem;
                font-weight: 500;
                border-radius: calc(var(--radius) - 2px);
                cursor: pointer;
                transition: all 0.15s ease;
                background: transparent;
                border: none;
                color: hsl(var(--muted-foreground));
            }

            .sh-tabs-trigger:hover {
                color: hsl(var(--foreground));
            }

            .sh-tabs-trigger.active {
                background: hsl(var(--background));
                color: hsl(var(--foreground));
                box-shadow: 0 1px 3px 0 rgb(0 0 0 / 0.1);
            }

            .sh-tabs-content {
                margin-top: 1rem;
                display: none;
            }

            .sh-tabs-content.active {
                display: block;
            }
            """
    }
}

struct ShButton {
    static func render(
        varName: String,
        text: String,
        variant: String = "default",
        size: String = "md",
        disabled: Bool = false
    ) -> String {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("button"))
            jsVar(varName).addClass("sh-btn")
            jsVar(varName).setTextContent(text)

            jsIf(jsBool(disabled)) {
                jsVar(varName).setAttribute("disabled", value: "true")
            }

            jsSwitch(
                jsString(variant),
                cases: [
                    jsSwitchCase(jsString("secondary")) {
                        jsVar(varName).addClass("sh-btn-secondary")
                    },
                    jsSwitchCase(jsString("destructive")) {
                        jsVar(varName).addClass("sh-btn-destructive")
                    },
                    jsSwitchCase(jsString("ghost")) {
                        jsVar(varName).addClass("sh-btn-ghost")
                    },
                    jsSwitchCase(jsString("outline")) {
                        jsVar(varName).addClass("sh-btn-outline")
                    },
                ],
                default: [
                    jsVar(varName).addClass("sh-btn-default")
                ])

            jsSwitch(
                jsString(size),
                cases: [
                    jsSwitchCase(jsString("sm")) {
                        jsVar(varName).addClass("sh-btn-sm")
                    },
                    jsSwitchCase(jsString("lg")) {
                        jsVar(varName).addClass("sh-btn-lg")
                    },
                ],
                default: [
                    jsVar(varName).addClass("sh-btn-md")
                ])
        }
    }
}

struct ShCard {
    static func render(varName: String) -> String {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("div"))
            jsVar(varName).addClass("sh-card")
        }
    }

    static func header(into card: String, varName: String) -> String {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("div"))
            jsVar(varName).addClass("sh-card-header")
            jsVar(card).appendChild(jsVar(varName))
        }
    }

    static func title(into header: String, varName: String, text: String) -> String {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("h3"))
            jsVar(varName).addClass("sh-card-title")
            jsVar(varName).setTextContent(text)
            jsVar(header).appendChild(jsVar(varName))
        }
    }

    static func description(into header: String, varName: String, text: String) -> String {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("p"))
            jsVar(varName).addClass("sh-card-description")
            jsVar(varName).setTextContent(text)
            jsVar(header).appendChild(jsVar(varName))
        }
    }

    static func content(into card: String, varName: String) -> String {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("div"))
            jsVar(varName).addClass("sh-card-content")
            jsVar(card).appendChild(jsVar(varName))
        }
    }

    static func footer(into card: String, varName: String) -> String {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("div"))
            jsVar(varName).addClass("sh-card-footer")
            jsVar(card).appendChild(jsVar(varName))
        }
    }
}

struct ShSkeleton {
    static func render(varName: String, width: String = "100%", height: String = "1rem") -> String {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("div"))
            jsVar(varName).addClass("sh-skeleton")
            jsVar(varName).setStyle("width", value: width)
            jsVar(varName).setStyle("height", value: height)
        }
    }
}

struct ShBadge {
    static func render(varName: String, text: String, variant: String = "default") -> String {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("span"))
            jsVar(varName).addClass("sh-badge")
            jsVar(varName).setTextContent(text)

            jsSwitch(
                jsString(variant),
                cases: [
                    jsSwitchCase(jsString("secondary")) {
                        jsVar(varName).addClass("sh-badge-secondary")
                    },
                    jsSwitchCase(jsString("destructive")) {
                        jsVar(varName).addClass("sh-badge-destructive")
                    },
                    jsSwitchCase(jsString("outline")) {
                        jsVar(varName).addClass("sh-badge-outline")
                    },
                ],
                default: [
                    jsVar(varName).addClass("sh-badge-default")
                ])
        }
    }
}

struct ShInput {
    static func render(
        varName: String,
        placeholder: String = "",
        type: String = "text",
        disabled: Bool = false
    ) -> String {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("input"))
            jsVar(varName).addClass("sh-input")
            jsVar(varName).setAttribute("type", value: type)
            jsVar(varName).setAttribute("placeholder", value: placeholder)

            jsIf(jsBool(disabled)) {
                jsVar(varName).setAttribute("disabled", value: "true")
            }
        }
    }
}

struct ShSelect {
    static func render(varName: String) -> String {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("div"))
            jsVar(varName).addClass("sh-select")
        }
    }

    static func trigger(into select: String, varName: String, placeholder: String = "Select...")
        -> String
    {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("div"))
            jsVar(varName).addClass("sh-select-trigger")
            jsVar(varName).setAttribute("tabindex", value: "0")
            jsVar(varName).setTextContent(placeholder)
            jsVar(select).appendChild(jsVar(varName))
        }
    }

    static func content(into select: String, varName: String) -> String {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("div"))
            jsVar(varName).addClass("sh-select-content")
            jsVar(select).appendChild(jsVar(varName))
        }
    }

    static func item(into content: String, varName: String, text: String, value: String) -> String {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("div"))
            jsVar(varName).addClass("sh-select-item")
            jsVar(varName).setTextContent(text)
            jsVar(varName).setAttribute("data-value", value: value)
            jsVar(varName).setAttribute("tabindex", value: "0")
            jsVar(content).appendChild(jsVar(varName))
        }
    }
}

struct ShModal {
    static func render(varName: String) -> String {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("div"))
            jsVar(varName).addClass("sh-modal-overlay")
        }
    }

    static func content(into modal: String, varName: String) -> String {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("div"))
            jsVar(varName).addClass("sh-modal-content")
            jsVar(modal).appendChild(jsVar(varName))
        }
    }

    static func header(into content: String, varName: String) -> String {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("div"))
            jsVar(varName).addClass("sh-modal-header")
            jsVar(content).appendChild(jsVar(varName))
        }
    }

    static func title(into header: String, varName: String, text: String) -> String {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("h2"))
            jsVar(varName).addClass("sh-modal-title")
            jsVar(varName).setTextContent(text)
            jsVar(header).appendChild(jsVar(varName))
        }
    }

    static func description(into header: String, varName: String, text: String) -> String {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("p"))
            jsVar(varName).addClass("sh-modal-description")
            jsVar(varName).setTextContent(text)
            jsVar(header).appendChild(jsVar(varName))
        }
    }

    static func body(into content: String, varName: String) -> String {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("div"))
            jsVar(varName).addClass("sh-modal-body")
            jsVar(content).appendChild(jsVar(varName))
        }
    }

    static func footer(into content: String, varName: String) -> String {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("div"))
            jsVar(varName).addClass("sh-modal-footer")
            jsVar(content).appendChild(jsVar(varName))
        }
    }

    static func close(into content: String, varName: String) -> String {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("button"))
            jsVar(varName).addClass("sh-modal-close")
            jsVar(varName).setTextContent("×")
            jsVar(content).appendChild(jsVar(varName))
        }
    }
}

struct ShSidebar {
    static func render(varName: String) -> String {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("aside"))
            jsVar(varName).addClass("sh-sidebar")
        }
    }

    static func header(into sidebar: String, varName: String) -> String {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("div"))
            jsVar(varName).addClass("sh-sidebar-header")
            jsVar(sidebar).appendChild(jsVar(varName))
        }
    }

    static func content(into sidebar: String, varName: String) -> String {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("div"))
            jsVar(varName).addClass("sh-sidebar-content")
            jsVar(sidebar).appendChild(jsVar(varName))
        }
    }

    static func footer(into sidebar: String, varName: String) -> String {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("div"))
            jsVar(varName).addClass("sh-sidebar-footer")
            jsVar(sidebar).appendChild(jsVar(varName))
        }
    }

    static func item(into content: String, varName: String, text: String, href: String = "#")
        -> String
    {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("a"))
            jsVar(varName).addClass("sh-sidebar-item")
            jsVar(varName).setTextContent(text)
            jsVar(varName).setAttribute("href", value: href)
            jsVar(content).appendChild(jsVar(varName))
        }
    }
}

struct ShAvatar {
    static func render(varName: String, size: String = "md") -> String {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("div"))
            jsVar(varName).addClass("sh-avatar")

            jsSwitch(
                jsString(size),
                cases: [
                    jsSwitchCase(jsString("sm")) {
                        jsVar(varName).addClass("sh-avatar-sm")
                    },
                    jsSwitchCase(jsString("lg")) {
                        jsVar(varName).addClass("sh-avatar-lg")
                    },
                ],
                default: [
                    jsVar(varName).addClass("sh-avatar-md")
                ])
        }
    }

    static func image(into avatar: String, varName: String, src: String, alt: String = "") -> String
    {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("img"))
            jsVar(varName).addClass("sh-avatar-image")
            jsVar(varName).setAttribute("src", value: src)
            jsVar(varName).setAttribute("alt", value: alt)
            jsVar(avatar).appendChild(jsVar(varName))
        }
    }

    static func fallback(into avatar: String, varName: String, text: String) -> String {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("div"))
            jsVar(varName).addClass("sh-avatar-fallback")
            jsVar(varName).setTextContent(text)
            jsVar(avatar).appendChild(jsVar(varName))
        }
    }
}

struct ShProgress {
    static func render(varName: String, value: Int = 0) -> String {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("div"))
            jsVar(varName).addClass("sh-progress")

            jsConst("\(varName)Bar", value: document.createElement("div"))
            jsVar("\(varName)Bar").addClass("sh-progress-bar")
            jsVar("\(varName)Bar").setStyle("width", value: "\(value)%")
            jsVar(varName).appendChild(jsVar("\(varName)Bar"))
        }
    }
}

struct ShSeparator {
    static func render(varName: String, orientation: String = "horizontal") -> String {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("div"))
            jsVar(varName).addClass("sh-separator")

            jsSwitch(
                jsString(orientation),
                cases: [
                    jsSwitchCase(jsString("vertical")) {
                        jsVar(varName).addClass("sh-separator-vertical")
                    }
                ],
                default: [
                    jsVar(varName).addClass("sh-separator-horizontal")
                ])
        }
    }
}

struct ShTabs {
    static func render(varName: String) -> String {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("div"))
            jsVar(varName).addClass("sh-tabs")
        }
    }

    static func list(into tabs: String, varName: String) -> String {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("div"))
            jsVar(varName).addClass("sh-tabs-list")
            jsVar(tabs).appendChild(jsVar(varName))
        }
    }

    static func trigger(into list: String, varName: String, text: String, value: String) -> String {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("button"))
            jsVar(varName).addClass("sh-tabs-trigger")
            jsVar(varName).setTextContent(text)
            jsVar(varName).setAttribute("data-value", value: value)
            jsVar(list).appendChild(jsVar(varName))
        }
    }

    static func content(into tabs: String, varName: String, value: String) -> String {
        return JSProcessor.process {
            jsConst(varName, value: document.createElement("div"))
            jsVar(varName).addClass("sh-tabs-content")
            jsVar(varName).setAttribute("data-value", value: value)
            jsVar(tabs).appendChild(jsVar(varName))
        }
    }
}
