func Home(request: HTTPRequest) -> HTTPResponse {
    let homeJS =
        JSProcessor.createAsyncFunction(name: "initApp") {
            // Root & shell
            jsConst("root", value: document.getElementById("root"))

            jsConst("shell", value: document.createElement("div"))
            jsVar("shell").addClass("app-shell")

            // SIDEBAR ----------------------------------------------------------------
            jsConst("sidebar", value: document.createElement("aside"))
            jsVar("sidebar").addClass("sidebar")

            // Sidebar header (logo + close on mobile)
            jsConst("sidebarHeader", value: document.createElement("div"))
            jsVar("sidebarHeader").addClass("sidebar-header")

            jsConst("logoRow", value: document.createElement("div"))
            jsVar("logoRow").addClass("logo-row")

            jsConst("logoMark", value: document.createElement("div"))
            jsVar("logoMark").addClass("logo-mark")

            jsConst("logoText", value: document.createElement("div"))
            jsVar("logoText").addClass("logo-text")

            jsConst("logoTitle", value: document.createElement("div"))
            jsVar("logoTitle").addClass("logo-title")
            jsVar("logoTitle").setTextContent("AniTrack")

            jsConst("logoSubtitle", value: document.createElement("div"))
            jsVar("logoSubtitle").addClass("logo-subtitle")
            jsVar("logoSubtitle").setTextContent("Your anime, in order.")

            jsVar("logoText").appendChild(jsVar("logoTitle"))
            jsVar("logoText").appendChild(jsVar("logoSubtitle"))

            jsVar("logoRow").appendChild(jsVar("logoMark"))
            jsVar("logoRow").appendChild(jsVar("logoText"))

            jsConst("sidebarClose", value: document.createElement("button"))
            jsVar("sidebarClose").addClass("sidebar-close")
            jsVar("sidebarClose").setAttribute("aria-label", value: "Close sidebar")
            JSStatement(code: "sidebarClose.innerHTML = '&#x2715;'")

            jsVar("sidebarHeader").appendChild(jsVar("logoRow"))
            jsVar("sidebarHeader").appendChild(jsVar("sidebarClose"))

            // Sidebar nav
            jsConst("nav", value: document.createElement("nav"))
            jsVar("nav").addClass("sidebar-nav")

            jsConst("navList", value: document.createElement("ul"))
            jsVar("navList").addClass("nav-list")

            // Helper for nav items via raw JS
            JSStatement(
                code: """
                    const navItemsData = [
                      { label: 'Home', active: true },
                      { label: 'Discover', active: false },
                      { label: 'Lists', active: false },
                      { label: 'Profile', active: false },
                    ];
                    """
            )

            jsFor(variable: "i", from: 0, to: 4) {
                jsConst("li", value: document.createElement("li"))

                jsConst("btn", value: document.createElement("button"))
                jsVar("btn").addClass("nav-item")

                JSStatement(
                    code: """
                        const navItem = navItemsData[i];
                        btn.textContent = navItem.label;
                        if (navItem.active) {
                          btn.classList.add('nav-item-active');
                        }
                        """
                )

                jsVar("li").appendChild(jsVar("btn"))
                jsVar("navList").appendChild(jsVar("li"))
            }

            jsVar("nav").appendChild(jsVar("navList"))

            // Sidebar user summary
            jsConst("sidebarFooter", value: document.createElement("div"))
            jsVar("sidebarFooter").addClass("sidebar-footer")

            jsConst("userCard", value: document.createElement("div"))
            jsVar("userCard").addClass("user-card")

            jsConst("userAvatar", value: document.createElement("div"))
            jsVar("userAvatar").addClass("user-avatar")

            jsConst("userDetails", value: document.createElement("div"))
            jsVar("userDetails").addClass("user-details")

            jsConst("userName", value: document.createElement("div"))
            jsVar("userName").addClass("user-name")
            jsVar("userName").setTextContent("Kazuma")

            jsConst("userMetaLine", value: document.createElement("div"))
            jsVar("userMetaLine").addClass("user-meta-line")
            jsVar("userMetaLine").setTextContent("Watching 12 · Completed 138")

            jsVar("userDetails").appendChild(jsVar("userName"))
            jsVar("userDetails").appendChild(jsVar("userMetaLine"))

            jsVar("userCard").appendChild(jsVar("userAvatar"))
            jsVar("userCard").appendChild(jsVar("userDetails"))

            jsVar("sidebarFooter").appendChild(jsVar("userCard"))

            jsVar("sidebar").appendChild(jsVar("sidebarHeader"))
            jsVar("sidebar").appendChild(jsVar("nav"))
            jsVar("sidebar").appendChild(jsVar("sidebarFooter"))

            // Sidebar backdrop (mobile)
            jsConst("sidebarBackdrop", value: document.createElement("div"))
            jsVar("sidebarBackdrop").addClass("sidebar-backdrop")

            // MAIN -------------------------------------------------------------------
            jsConst("main", value: document.createElement("main"))
            jsVar("main").addClass("main")

            // Top bar
            jsConst("topBar", value: document.createElement("header"))
            jsVar("topBar").addClass("top-bar")

            jsConst("leftTop", value: document.createElement("div"))
            jsVar("leftTop").addClass("top-left")

            jsConst("sidebarToggle", value: document.createElement("button"))
            jsVar("sidebarToggle").addClass("sidebar-toggle")
            jsVar("sidebarToggle").setAttribute("aria-label", value: "Toggle navigation")
            JSStatement(
                code: """
                    sidebarToggle.innerHTML = '<span></span><span></span>';
                    """
            )

            jsConst("pageTitleBlock", value: document.createElement("div"))
            jsVar("pageTitleBlock").addClass("page-title-block")

            jsConst("pageTitle", value: document.createElement("h1"))
            jsVar("pageTitle").addClass("page-title")
            jsVar("pageTitle").setTextContent("Home")

            jsConst("pageSubtitle", value: document.createElement("p"))
            jsVar("pageSubtitle").addClass("page-subtitle")
            jsVar("pageSubtitle").setTextContent(
                "Catch up on this week’s episodes and discover what to watch next.")

            jsVar("pageTitleBlock").appendChild(jsVar("pageTitle"))
            jsVar("pageTitleBlock").appendChild(jsVar("pageSubtitle"))

            jsVar("leftTop").appendChild(jsVar("sidebarToggle"))
            jsVar("leftTop").appendChild(jsVar("pageTitleBlock"))

            jsConst("rightTop", value: document.createElement("div"))
            jsVar("rightTop").addClass("top-right")

            jsConst("smallStat", value: document.createElement("div"))
            jsVar("smallStat").addClass("top-stat")
            JSStatement(
                code: """
                    smallStat.innerHTML = '<span class="label">Days watched</span><span class="value">43.7</span>';
                    """
            )

            jsVar("rightTop").appendChild(jsVar("smallStat"))

            jsVar("topBar").appendChild(jsVar("leftTop"))
            jsVar("topBar").appendChild(jsVar("rightTop"))

            // Content wrapper
            jsConst("content", value: document.createElement("div"))
            jsVar("content").addClass("content")

            // SECTION 1: Weekly releases ---------------------------------------------
            JSStatement(
                code: """
                    const weeklyReleases = [
                      { title: "Frieren: Beyond Journey\'s End", episode: "Ep 8 · Journey\'s Library", airing: "Today · 7:30 PM", status: "Next up" },
                      { title: "Solo Leveling", episode: "Ep 5 · The Job Change", airing: "Tomorrow · 9:00 PM", status: "This week" },
                      { title: "Blue Lock 2nd Season", episode: "Ep 3 · Rivalry", airing: "Sun · 10:30 PM", status: "This week" }
                    ];
                    """
            )

            jsConst("weeklySection", value: document.createElement("section"))
            jsVar("weeklySection").addClass("section")

            jsConst("weeklyHeader", value: document.createElement("div"))
            jsVar("weeklyHeader").addClass("section-header")

            jsConst("weeklyHeaderText", value: document.createElement("div"))
            jsVar("weeklyHeaderText").addClass("section-header-text")

            jsConst("weeklyTitle", value: document.createElement("h2"))
            jsVar("weeklyTitle").addClass("section-title")
            jsVar("weeklyTitle").setTextContent("This week’s releases")

            jsConst("weeklySubtitle", value: document.createElement("p"))
            jsVar("weeklySubtitle").addClass("section-subtitle")
            jsVar("weeklySubtitle").setTextContent(
                "Episodes airing this week from shows you’re already watching.")

            jsVar("weeklyHeaderText").appendChild(jsVar("weeklyTitle"))
            jsVar("weeklyHeaderText").appendChild(jsVar("weeklySubtitle"))

            jsConst("weeklyAction", value: document.createElement("button"))
            jsVar("weeklyAction").addClass("text-button")
            jsVar("weeklyAction").setTextContent("View airing schedule")

            jsVar("weeklyHeader").appendChild(jsVar("weeklyHeaderText"))
            jsVar("weeklyHeader").appendChild(jsVar("weeklyAction"))

            jsConst("weeklyRow", value: document.createElement("div"))
            jsVar("weeklyRow").addClass("card-row")

            jsFor(variable: "i", from: 0, to: 3) {
                jsConst("card", value: document.createElement("article"))
                jsVar("card").addClass("episode-card")

                jsConst("thumb", value: document.createElement("div"))
                jsVar("thumb").addClass("episode-thumb")

                jsConst("body", value: document.createElement("div"))
                jsVar("body").addClass("episode-body")

                jsConst("titleRow", value: document.createElement("div"))
                jsVar("titleRow").addClass("episode-title-row")

                jsConst("epTitle", value: document.createElement("h3"))
                jsVar("epTitle").addClass("episode-title")

                jsConst("statusPill", value: document.createElement("span"))
                jsVar("statusPill").addClass("status-pill")

                jsConst("meta", value: document.createElement("div"))
                jsVar("meta").addClass("episode-meta")

                jsConst("episodeText", value: document.createElement("span"))
                jsVar("episodeText").addClass("episode-text")

                jsConst("airingText", value: document.createElement("span"))
                jsVar("airingText").addClass("airing-text")

                jsConst("controls", value: document.createElement("div"))
                jsVar("controls").addClass("episode-controls")

                jsConst("primary", value: document.createElement("button"))
                jsVar("primary").addClass("btn")
                jsVar("primary").addClass("btn-primary")
                jsVar("primary").setTextContent("Play next")

                jsConst("secondary", value: document.createElement("button"))
                jsVar("secondary").addClass("btn")
                jsVar("secondary").addClass("btn-ghost")
                jsVar("secondary").setTextContent("Details")

                JSStatement(
                    code: """
                        const w = weeklyReleases[i];
                        epTitle.textContent = w.title;
                        statusPill.textContent = w.status;
                        episodeText.textContent = w.episode;
                        airingText.textContent = w.airing;
                        """
                )

                jsVar("titleRow").appendChild(jsVar("epTitle"))
                jsVar("titleRow").appendChild(jsVar("statusPill"))

                jsVar("meta").appendChild(jsVar("episodeText"))
                jsVar("meta").appendChild(jsVar("airingText"))

                jsVar("controls").appendChild(jsVar("primary"))
                jsVar("controls").appendChild(jsVar("secondary"))

                jsVar("body").appendChild(jsVar("titleRow"))
                jsVar("body").appendChild(jsVar("meta"))
                jsVar("body").appendChild(jsVar("controls"))

                jsVar("card").appendChild(jsVar("thumb"))
                jsVar("card").appendChild(jsVar("body"))

                jsVar("weeklyRow").appendChild(jsVar("card"))
            }

            jsVar("weeklySection").appendChild(jsVar("weeklyHeader"))
            jsVar("weeklySection").appendChild(jsVar("weeklyRow"))

            // SECTION 2: Continue watching -------------------------------------------
            JSStatement(
                code: """
                    const continueWatching = [
                      { title: 'Bocchi the Rock!', progress: 'Ep 9 / 12', score: '9.0', label: 'Slice of life' },
                      { title: 'Mushoku Tensei II', progress: 'Ep 4 / 12', score: '8.7', label: 'Fantasy' },
                      { title: 'Kaguya-sama: Love is War', progress: 'Ep 6 / 12', score: '9.1', label: 'RomCom' }
                    ];
                    """
            )

            jsConst("continueSection", value: document.createElement("section"))
            jsVar("continueSection").addClass("section")

            jsConst("continueHeader", value: document.createElement("div"))
            jsVar("continueHeader").addClass("section-header")

            jsConst("continueHeaderText", value: document.createElement("div"))
            jsVar("continueHeaderText").addClass("section-header-text")

            jsConst("continueTitle", value: document.createElement("h2"))
            jsVar("continueTitle").addClass("section-title")
            jsVar("continueTitle").setTextContent("Continue watching")

            jsConst("continueSubtitle", value: document.createElement("p"))
            jsVar("continueSubtitle").addClass("section-subtitle")
            jsVar("continueSubtitle").setTextContent(
                "Resume exactly where you left off, across all ongoing series.")

            jsVar("continueHeaderText").appendChild(jsVar("continueTitle"))
            jsVar("continueHeaderText").appendChild(jsVar("continueSubtitle"))

            jsConst("continueAction", value: document.createElement("button"))
            jsVar("continueAction").addClass("text-button")
            jsVar("continueAction").setTextContent("View full list")

            jsVar("continueHeader").appendChild(jsVar("continueHeaderText"))
            jsVar("continueHeader").appendChild(jsVar("continueAction"))

            jsConst("continueRow", value: document.createElement("div"))
            jsVar("continueRow").addClass("card-row")

            jsFor(variable: "i", from: 0, to: 3) {
                jsConst("card", value: document.createElement("article"))
                jsVar("card").addClass("media-card")

                jsConst("thumb", value: document.createElement("div"))
                jsVar("thumb").addClass("media-thumb")

                jsConst("body", value: document.createElement("div"))
                jsVar("body").addClass("media-body")

                jsConst("titleRow", value: document.createElement("div"))
                jsVar("titleRow").addClass("media-title-row")

                jsConst("title", value: document.createElement("h3"))
                jsVar("title").addClass("media-title")

                jsConst("tag", value: document.createElement("span"))
                jsVar("tag").addClass("media-tag")

                jsConst("metaRow", value: document.createElement("div"))
                jsVar("metaRow").addClass("media-meta-row")

                jsConst("progressLabel", value: document.createElement("span"))
                jsVar("progressLabel").addClass("meta-pill")

                jsConst("scoreLabel", value: document.createElement("span"))
                jsVar("scoreLabel").addClass("meta-pill")

                jsConst("progressBar", value: document.createElement("div"))
                jsVar("progressBar").addClass("progress-bar")

                jsConst("progressFill", value: document.createElement("div"))
                jsVar("progressFill").addClass("progress-bar-fill")

                JSStatement(
                    code: """
                        const c = continueWatching[i];
                        title.textContent = c.title;
                        tag.textContent = c.label;
                        progressLabel.textContent = c.progress;
                        scoreLabel.textContent = `Score ${c.score}`;
                        const match = /Ep\\s*(\\d+)\\s*\\/\\s*(\\d+)/.exec(c.progress);
                        if (match) {
                          const current = Number(match[1]);
                          const total = Number(match[2]) || 1;
                          const pct = Math.min(100, Math.max(0, (current / total) * 100));
                          progressFill.style.width = pct + '%';
                        } else {
                          progressFill.style.width = '40%';
                        }
                        """
                )

                jsVar("progressBar").appendChild(jsVar("progressFill"))

                jsVar("metaRow").appendChild(jsVar("progressLabel"))
                jsVar("metaRow").appendChild(jsVar("scoreLabel"))

                jsVar("titleRow").appendChild(jsVar("title"))
                jsVar("titleRow").appendChild(jsVar("tag"))

                jsVar("body").appendChild(jsVar("titleRow"))
                jsVar("body").appendChild(jsVar("metaRow"))
                jsVar("body").appendChild(jsVar("progressBar"))

                jsVar("card").appendChild(jsVar("thumb"))
                jsVar("card").appendChild(jsVar("body"))

                jsVar("continueRow").appendChild(jsVar("card"))
            }

            jsVar("continueSection").appendChild(jsVar("continueHeader"))
            jsVar("continueSection").appendChild(jsVar("continueRow"))

            // SECTION 3: Suggested anime ---------------------------------------------
            JSStatement(
                code: """
                    const suggestedAnime = [
                      { title: 'Oshi no Ko', reason: 'Because you liked Kaguya-sama', tag: 'Drama · Idol' },
                      { title: 'Violet Evergarden', reason: 'Because you liked emotional dramas', tag: 'Drama · Fantasy' },
                      { title: 'Odd Taxi', reason: 'Because you liked smart, character-driven stories', tag: 'Mystery · Drama' },
                      { title: 'Mob Psycho 100', reason: 'Because you liked offbeat action', tag: 'Action · Comedy' }
                    ];
                    """
            )

            jsConst("suggestedSection", value: document.createElement("section"))
            jsVar("suggestedSection").addClass("section")

            jsConst("suggestedHeader", value: document.createElement("div"))
            jsVar("suggestedHeader").addClass("section-header")

            jsConst("suggestedHeaderText", value: document.createElement("div"))
            jsVar("suggestedHeaderText").addClass("section-header-text")

            jsConst("suggestedTitle", value: document.createElement("h2"))
            jsVar("suggestedTitle").addClass("section-title")
            jsVar("suggestedTitle").setTextContent("Because you might like")

            jsConst("suggestedSubtitle", value: document.createElement("p"))
            jsVar("suggestedSubtitle").addClass("section-subtitle")
            jsVar("suggestedSubtitle").setTextContent(
                "Recommendations tuned to your list and current mood.")

            jsVar("suggestedHeaderText").appendChild(jsVar("suggestedTitle"))
            jsVar("suggestedHeaderText").appendChild(jsVar("suggestedSubtitle"))

            jsConst("suggestedAction", value: document.createElement("button"))
            jsVar("suggestedAction").addClass("text-button")
            jsVar("suggestedAction").setTextContent("Open full recommendations")

            jsVar("suggestedHeader").appendChild(jsVar("suggestedHeaderText"))
            jsVar("suggestedHeader").appendChild(jsVar("suggestedAction"))

            jsConst("suggestedGrid", value: document.createElement("div"))
            jsVar("suggestedGrid").addClass("suggested-grid")

            jsFor(variable: "i", from: 0, to: 4) {
                jsConst("card", value: document.createElement("article"))
                jsVar("card").addClass("suggested-card")

                jsConst("topRow", value: document.createElement("div"))
                jsVar("topRow").addClass("suggested-top-row")

                jsConst("title", value: document.createElement("h3"))
                jsVar("title").addClass("suggested-title")

                jsConst("tag", value: document.createElement("span"))
                jsVar("tag").addClass("suggested-tag")

                jsConst("reason", value: document.createElement("p"))
                jsVar("reason").addClass("suggested-reason")

                jsConst("addButton", value: document.createElement("button"))
                jsVar("addButton").addClass("btn")
                jsVar("addButton").addClass("btn-soft")
                jsVar("addButton").setTextContent("Add to plan to watch")

                JSStatement(
                    code: """
                        const s = suggestedAnime[i];
                        title.textContent = s.title;
                        tag.textContent = s.tag;
                        reason.textContent = s.reason;
                        """
                )

                jsVar("topRow").appendChild(jsVar("title"))
                jsVar("topRow").appendChild(jsVar("tag"))

                jsVar("card").appendChild(jsVar("topRow"))
                jsVar("card").appendChild(jsVar("reason"))
                jsVar("card").appendChild(jsVar("addButton"))

                jsVar("suggestedGrid").appendChild(jsVar("card"))
            }

            jsVar("suggestedSection").appendChild(jsVar("suggestedHeader"))
            jsVar("suggestedSection").appendChild(jsVar("suggestedGrid"))

            // Assemble content
            jsVar("content").appendChild(jsVar("weeklySection"))
            jsVar("content").appendChild(jsVar("continueSection"))
            jsVar("content").appendChild(jsVar("suggestedSection"))

            jsVar("main").appendChild(jsVar("topBar"))
            jsVar("main").appendChild(jsVar("content"))

            jsVar("shell").appendChild(jsVar("sidebar"))
            jsVar("shell").appendChild(jsVar("sidebarBackdrop"))
            jsVar("shell").appendChild(jsVar("main"))

            jsVar("root").appendChild(jsVar("shell"))

            // INTERACTIONS -----------------------------------------------------------
            // Sidebar toggle (mobile)
            jsVar("sidebarToggle").addEventListener(
                "click",
                handler: jsArrowFunction(parameters: []) {
                    JSStatement(code: "shell.classList.toggle('sidebar-open');")
                })

            jsVar("sidebarClose").addEventListener(
                "click",
                handler: jsArrowFunction(parameters: []) {
                    JSStatement(code: "shell.classList.remove('sidebar-open');")
                })

            jsVar("sidebarBackdrop").addEventListener(
                "click",
                handler: jsArrowFunction(parameters: []) {
                    JSStatement(code: "shell.classList.remove('sidebar-open');")
                })

            // Simple button feedback
            JSStatement(
                code: """
                    document.querySelectorAll('.btn-primary').forEach(btn => {
                      btn.addEventListener('click', () => {
                        btn.classList.add('btn-pressed');
                        setTimeout(() => btn.classList.remove('btn-pressed'), 180);
                      });
                    });
                    """
            )
        }
        + JSProcessor.process {
            JSStatement(code: "document.addEventListener('DOMContentLoaded', initApp);")
        }

    let htmlContent = """
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>AniTrack · Home</title>
            <style>
                :root {
                    --bg: #f5f5f7;
                    --bg-elevated: #ffffff;
                    --sidebar-bg: #fbfbfd;
                    --border-subtle: #e5e5ea;
                    --border-strong: #d1d1d6;
                    --text-primary: #111827;
                    --text-secondary: #6b7280;
                    --accent: #007aff;
                    --accent-soft: rgba(0, 122, 255, 0.08);
                    --accent-soft-strong: rgba(0, 122, 255, 0.15);
                    --radius-lg: 18px;
                    --radius-xl: 22px;
                    --shadow-soft: 0 18px 40px rgba(15, 23, 42, 0.12);
                    --shadow-card: 0 10px 30px rgba(15, 23, 42, 0.08);
                }

                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }

                html, body {
                    height: 100%;
                }

                body {
                    font-family: -apple-system, BlinkMacSystemFont, "SF Pro Text", system-ui, sans-serif;
                    background: var(--bg);
                    color: var(--text-primary);
                    display: flex;
                    align-items: stretch;
                    justify-content: center;
                    -webkit-font-smoothing: antialiased;
                }

                #root {
                    width: 100%;
                    height: 100%;
                    margin: 0 auto;
                }

                .app-shell {
                    display: grid;
                    grid-template-columns: 260px minmax(0, 1fr);
                    background: var(--bg-elevated);
                    border-radius: var(--radius-xl);
                    border: 1px solid var(--border-subtle);
                    box-shadow: var(--shadow-soft);
                    height: 100%;
                    position: relative;
                    transition: box-shadow 0.2s ease, transform 0.2s ease;
                }

                .app-shell.sidebar-open {
                    transform: translateX(0);
                }

                .sidebar {
                    background: var(--sidebar-bg);
                    border-right: 1px solid var(--border-subtle);
                    display: flex;
                    flex-direction: column;
                    padding: 16px 16px 12px;
                    gap: 16px;
                    position: relative;
                    z-index: 20;
                }

                .sidebar-header {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    gap: 8px;
                    padding-bottom: 12px;
                    border-bottom: 1px solid rgba(0, 0, 0, 0.03);
                }

                .logo-row {
                    display: flex;
                    align-items: center;
                    gap: 10px;
                }

                .logo-mark {
                    width: 26px;
                    height: 26px;
                    border-radius: 8px;
                    background:
                        linear-gradient(135deg, #0ea5e9, #6366f1);
                    box-shadow:
                        0 8px 16px rgba(37, 99, 235, 0.35),
                        0 0 0 1px rgba(255, 255, 255, 0.9);
                }

                .logo-text {
                    display: flex;
                    flex-direction: column;
                    gap: 2px;
                }

                .logo-title {
                    font-weight: 600;
                    font-size: 0.95rem;
                    letter-spacing: -0.02em;
                }

                .logo-subtitle {
                    font-size: 0.75rem;
                    color: var(--text-secondary);
                }

                .sidebar-close {
                    border: none;
                    background: transparent;
                    color: var(--text-secondary);
                    font-size: 1rem;
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    width: 26px;
                    height: 26px;
                    border-radius: 999px;
                    cursor: pointer;
                    transition: background 0.15s ease, color 0.15s ease;
                }

                .sidebar-close:hover {
                    background: rgba(0, 0, 0, 0.04);
                    color: var(--text-primary);
                }

                .sidebar-nav {
                    flex: 1;
                }

                .nav-list {
                    list-style: none;
                    display: flex;
                    flex-direction: column;
                    gap: 4px;
                    margin-top: 4px;
                }

                .nav-item {
                    width: 100%;
                    text-align: left;
                    border-radius: 10px;
                    border: 1px solid transparent;
                    padding: 9px 10px;
                    font-size: 0.86rem;
                    background: transparent;
                    color: var(--text-primary);
                    cursor: pointer;
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    transition: background 0.15s ease, border-color 0.15s ease, transform 0.12s ease;
                }

                .nav-item::after {
                    content: "›";
                    font-size: 0.8rem;
                    color: var(--text-secondary);
                }

                .nav-item:hover {
                    background: rgba(0, 0, 0, 0.02);
                    border-color: var(--border-subtle);
                    transform: translateY(-1px);
                }

                .nav-item-active {
                    background: rgba(0, 122, 255, 0.08);
                    border-color: rgba(0, 122, 255, 0.25);
                }

                .sidebar-footer {
                    padding-top: 12px;
                    border-top: 1px solid rgba(0, 0, 0, 0.04);
                }

                .user-card {
                    display: flex;
                    align-items: center;
                    gap: 10px;
                    padding: 8px 10px;
                    border-radius: 12px;
                    background: rgba(255, 255, 255, 0.9);
                    border: 1px solid var(--border-subtle);
                }

                .user-avatar {
                    width: 32px;
                    height: 32px;
                    border-radius: 999px;
                    background:
                        radial-gradient(circle at 10% 0%, #0ea5e9, #6366f1);
                }

                .user-details {
                    display: flex;
                    flex-direction: column;
                    gap: 2px;
                }

                .user-name {
                    font-size: 0.85rem;
                    font-weight: 500;
                }

                .user-meta-line {
                    font-size: 0.76rem;
                    color: var(--text-secondary);
                }

                .sidebar-backdrop {
                    position: fixed;
                    inset: 0;
                    background: rgba(0, 0, 0, 0.18);
                    opacity: 0;
                    pointer-events: none;
                    transition: opacity 0.18s ease;
                    z-index: 10;
                }

                .app-shell.sidebar-open .sidebar-backdrop {
                    opacity: 1;
                    pointer-events: auto;
                }

                /* MAIN ------------------------------------------------------------------- */
                .main {
                    display: flex;
                    flex-direction: column;
                    background: var(--bg-elevated);
                }

                .top-bar {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    padding: 16px 20px 12px;
                    border-bottom: 1px solid var(--border-subtle);
                    background: rgba(255, 255, 255, 0.96);
                    position: sticky;
                    top: 0;
                    z-index: 5;
                }

                .top-left {
                    display: flex;
                    align-items: center;
                    gap: 10px;
                }

                .sidebar-toggle {
                    width: 30px;
                    height: 30px;
                    border-radius: 999px;
                    border: 1px solid var(--border-subtle);
                    background: #ffffff;
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    cursor: pointer;
                    transition: background 0.15s ease, border-color 0.15s ease, transform 0.12s ease;
                }

                .sidebar-toggle span {
                    display: block;
                    width: 14px;
                    height: 1.5px;
                    border-radius: 999px;
                    background: var(--text-secondary);
                    position: relative;
                }

                .sidebar-toggle span:last-child {
                    margin-top: 4px;
                    width: 10px;
                }

                .sidebar-toggle:hover {
                    background: rgba(0, 0, 0, 0.03);
                    border-color: var(--border-strong);
                    transform: translateY(-1px);
                }

                .page-title-block {
                    display: flex;
                    flex-direction: column;
                    gap: 2px;
                }

                .page-title {
                    font-size: 1.1rem;
                    font-weight: 600;
                    letter-spacing: -0.02em;
                }

                .page-subtitle {
                    font-size: 0.8rem;
                    color: var(--text-secondary);
                }

                .top-right {
                    display: flex;
                    align-items: center;
                    gap: 10px;
                }

                .top-stat {
                    padding: 6px 10px;
                    border-radius: 999px;
                    background: rgba(0, 0, 0, 0.02);
                    border: 1px solid var(--border-subtle);
                    font-size: 0.78rem;
                    display: inline-flex;
                    gap: 6px;
                }

                .top-stat .label {
                    color: var(--text-secondary);
                }

                .top-stat .value {
                    font-weight: 500;
                }

                .content {
                    padding: 16px 20px 18px;
                    display: flex;
                    flex-direction: column;
                    gap: 18px;
                    overflow: auto;
                }

                /* SECTIONS --------------------------------------------------------------- */
                .section {
                    display: flex;
                    flex-direction: column;
                    gap: 10px;
                }

                .section-header {
                    display: flex;
                    align-items: flex-end;
                    justify-content: space-between;
                    gap: 8px;
                }

                .section-header-text {
                    display: flex;
                    flex-direction: column;
                    gap: 2px;
                }

                .section-title {
                    font-size: 0.98rem;
                    font-weight: 600;
                    letter-spacing: -0.01em;
                }

                .section-subtitle {
                    font-size: 0.8rem;
                    color: var(--text-secondary);
                }

                .text-button {
                    border: none;
                    background: transparent;
                    color: var(--accent);
                    font-size: 0.8rem;
                    cursor: pointer;
                    padding: 4px 6px;
                    border-radius: 999px;
                    transition: background 0.15s ease;
                }

                .text-button:hover {
                    background: rgba(0, 0, 0, 0.03);
                }

                .card-row {
                    display: grid;
                    grid-auto-flow: column;
                    grid-auto-columns: minmax(240px, 1fr);
                    gap: 12px;
                    overflow-x: auto;
                    padding-bottom: 2px;
                }

                .card-row::-webkit-scrollbar {
                    height: 4px;
                }

                .card-row::-webkit-scrollbar-thumb {
                    background: rgba(0, 0, 0, 0.15);
                    border-radius: 999px;
                }

                /* Buttons ---------------------------------------------------------------- */
                .btn {
                    border-radius: 999px;
                    border: 1px solid transparent;
                    padding: 6px 12px;
                    font-size: 0.8rem;
                    cursor: pointer;
                    outline: none;
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    gap: 6px;
                    transition: background 0.16s ease, color 0.16s ease,
                                box-shadow 0.16s ease, border-color 0.16s ease,
                                transform 0.12s ease;
                }

                .btn-primary {
                    background: var(--accent);
                    color: #ffffff;
                    border-color: rgba(0, 0, 0, 0.03);
                    box-shadow: 0 10px 20px rgba(0, 122, 255, 0.25);
                }

                .btn-primary:hover {
                    background: #0059d6;
                    transform: translateY(-1px);
                    box-shadow: 0 12px 26px rgba(0, 122, 255, 0.3);
                }

                .btn-primary.btn-pressed {
                    transform: translateY(0);
                    box-shadow: 0 4px 10px rgba(0, 122, 255, 0.2);
                }

                .btn-ghost {
                    background: rgba(0, 0, 0, 0.02);
                    color: var(--text-primary);
                    border-color: var(--border-subtle);
                }

                .btn-ghost:hover {
                    background: rgba(0, 0, 0, 0.04);
                    border-color: var(--border-strong);
                }

                .btn-soft {
                    background: var(--accent-soft);
                    border-color: rgba(0, 122, 255, 0.15);
                    color: var(--accent);
                }

                .btn-soft:hover {
                    background: var(--accent-soft-strong);
                    border-color: rgba(0, 122, 255, 0.25);
                }

                /* Weekly episode cards --------------------------------------------------- */
                .episode-card {
                    display: grid;
                    grid-template-columns: 90px minmax(0, 1fr);
                    gap: 10px;
                    padding: 10px;
                    border-radius: var(--radius-lg);
                    background: #ffffff;
                    border: 1px solid var(--border-subtle);
                    box-shadow: var(--shadow-card);
                    transition: transform 0.14s ease, box-shadow 0.14s ease, border-color 0.14s ease;
                }

                .episode-card:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 14px 28px rgba(15, 23, 42, 0.1);
                    border-color: var(--border-strong);
                }

                .episode-thumb {
                    border-radius: 12px;
                    background:
                        linear-gradient(135deg, #60a5fa, #a855f7);
                }

                .episode-body {
                    display: flex;
                    flex-direction: column;
                    gap: 6px;
                }

                .episode-title-row {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    gap: 6px;
                }

                .episode-title {
                    font-size: 0.9rem;
                    font-weight: 500;
                    letter-spacing: -0.01em;
                }

                .status-pill {
                    font-size: 0.72rem;
                    padding: 3px 8px;
                    border-radius: 999px;
                    background: var(--accent-soft);
                    color: var(--accent);
                }

                .episode-meta {
                    display: flex;
                    flex-direction: column;
                    gap: 2px;
                    font-size: 0.78rem;
                }

                .episode-text {
                    color: var(--text-secondary);
                }

                .airing-text {
                    color: var(--text-secondary);
                }

                .episode-controls {
                    display: flex;
                    flex-wrap: wrap;
                    gap: 6px;
                    margin-top: 4px;
                }

                /* Continue watching cards ------------------------------------------------ */
                .media-card {
                    display: grid;
                    grid-template-columns: 80px minmax(0, 1fr);
                    gap: 10px;
                    padding: 10px;
                    border-radius: var(--radius-lg);
                    background: #ffffff;
                    border: 1px solid var(--border-subtle);
                    box-shadow: var(--shadow-card);
                    transition: transform 0.14s ease, box-shadow 0.14s ease, border-color 0.14s ease;
                }

                .media-card:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 14px 28px rgba(15, 23, 42, 0.1);
                    border-color: var(--border-strong);
                }

                .media-thumb {
                    border-radius: 12px;
                    background:
                        linear-gradient(135deg, #34d399, #22c55e);
                }

                .media-body {
                    display: flex;
                    flex-direction: column;
                    gap: 6px;
                }

                .media-title-row {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    gap: 6px;
                }

                .media-title {
                    font-size: 0.88rem;
                    font-weight: 500;
                    letter-spacing: -0.01em;
                }

                .media-tag {
                    font-size: 0.72rem;
                    color: var(--text-secondary);
                    padding: 3px 8px;
                    border-radius: 999px;
                    background: rgba(0, 0, 0, 0.02);
                }

                .media-meta-row {
                    display: flex;
                    flex-wrap: wrap;
                    gap: 6px;
                    font-size: 0.76rem;
                }

                .meta-pill {
                    padding: 3px 8px;
                    border-radius: 999px;
                    border: 1px solid var(--border-subtle);
                    background: rgba(0, 0, 0, 0.01);
                    color: var(--text-secondary);
                }

                .progress-bar {
                    width: 100%;
                    height: 4px;
                    border-radius: 999px;
                    background: rgba(0, 0, 0, 0.05);
                    overflow: hidden;
                    margin-top: 4px;
                }

                .progress-bar-fill {
                    height: 100%;
                    border-radius: inherit;
                    background: linear-gradient(90deg, #22c55e, #a3e635);
                    width: 40%;
                    transition: width 0.2s ease-out;
                }

                /* Suggested cards -------------------------------------------------------- */
                .suggested-grid {
                    display: grid;
                    grid-template-columns: repeat(4, minmax(0, 1fr));
                    gap: 10px;
                }

                .suggested-card {
                    border-radius: var(--radius-lg);
                    background: #ffffff;
                    border: 1px solid var(--border-subtle);
                    box-shadow: var(--shadow-card);
                    padding: 10px;
                    display: flex;
                    flex-direction: column;
                    gap: 6px;
                    transition: transform 0.14s ease, box-shadow 0.14s ease, border-color 0.14s ease;
                }

                .suggested-card:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 14px 28px rgba(15, 23, 42, 0.1);
                    border-color: var(--border-strong);
                }

                .suggested-top-row {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    gap: 6px;
                }

                .suggested-title {
                    font-size: 0.86rem;
                    font-weight: 500;
                    letter-spacing: -0.01em;
                }

                .suggested-tag {
                    font-size: 0.72rem;
                    color: var(--text-secondary);
                    padding: 3px 8px;
                    border-radius: 999px;
                    background: rgba(0, 0, 0, 0.02);
                }

                .suggested-reason {
                    font-size: 0.78rem;
                    color: var(--text-secondary);
                }

                /* RESPONSIVE ------------------------------------------------------------- */
                @media (max-width: 960px) {
                    .app-shell {
                        grid-template-columns: minmax(0, 1fr);
                    }

                    .sidebar {
                        position: fixed;
                        inset: 0 auto 0 0;
                        width: 260px;
                        transform: translateX(-100%);
                        box-shadow: 10px 0 30px rgba(15, 23, 42, 0.25);
                        transition: transform 0.2s ease;
                    }

                    .app-shell.sidebar-open .sidebar {
                        transform: translateX(0);
                    }

                    .sidebar-close {
                        display: inline-flex;
                    }

                    .content {
                        padding: 14px 14px 16px;
                    }
                }

                @media (min-width: 961px) {
                    .sidebar-backdrop {
                        display: none;
                    }
                    .sidebar-close {
                        display: none;
                    }
                }

                @media (max-width: 720px) {
                    .suggested-grid {
                        grid-template-columns: repeat(2, minmax(0, 1fr));
                    }

                    .card-row {
                        grid-auto-columns: 80%;
                    }

                    .top-right {
                        display: none;
                    }
                }

                @media (max-width: 520px) {
                    .suggested-grid {
                        grid-template-columns: minmax(0, 1fr);
                    }

                    .episode-card,
                    .media-card {
                        grid-template-columns: minmax(0, 1fr);
                    }
                }
            </style>
        </head>
        <body>
            <div id="root"></div>
            <script>
                \(homeJS)
            </script>
        </body>
        </html>
        """

    return HTTPResponse.html(
        statusCode: 200,
        reason: "OK",
        body: htmlContent
    )
}
