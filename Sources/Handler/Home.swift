func Home(request: HTTPRequest) -> HTTPResponse {
    // Build the anime list UI with cards, badges, progress, etc.
    let componentJS =
        // Theme Toggle Button
        ShButton.render(
            varName: "themeToggle", text: "Toggle Dark Mode", variant: "outline", size: "sm")
            + """
            themeToggle.addEventListener("click", function() {
                document.body.classList.toggle("dark");
            });
            document.body.appendChild(themeToggle);
            themeToggle.style.position = "fixed";
            themeToggle.style.top = "1rem";
            themeToggle.style.right = "1rem";
            themeToggle.style.zIndex = "100";
            """

        // Sidebar
        + ShSidebar.render(varName: "sidebar")
        + ShSidebar.header(into: "sidebar", varName: "sidebarHeader")
            + """
            const logo = document.createElement("h2");
            logo.textContent = "AniTrack";
            logo.style.fontSize = "1.5rem";
            logo.style.fontWeight = "700";
            sidebarHeader.appendChild(logo);
            """
        + ShSidebar.content(into: "sidebar", varName: "sidebarContent")
        + ShSidebar.item(into: "sidebarContent", varName: "navHome", text: "🏠 Home", href: "#")
        + ShSidebar.item(
            into: "sidebarContent", varName: "navWatching", text: "👀 Watching", href: "#watching")
        + ShSidebar.item(
            into: "sidebarContent", varName: "navCompleted", text: "✅ Completed", href: "#completed"
        )
        + ShSidebar.item(
            into: "sidebarContent", varName: "navPlanToWatch", text: "📋 Plan to Watch",
            href: "#plan")
        + ShSidebar.item(
            into: "sidebarContent", varName: "navSearch", text: "🔍 Search", href: "#search")
        + ShSidebar.footer(into: "sidebar", varName: "sidebarFooter")
        + ShAvatar.render(varName: "userAvatar", size: "md")
        + ShAvatar.fallback(into: "userAvatar", varName: "userFallback", text: "JD")
            + """
            sidebarFooter.appendChild(userAvatar);
            const userName = document.createElement("span");
            userName.textContent = "John Doe";
            userName.style.fontSize = "0.875rem";
            userName.style.fontWeight = "500";
            sidebarFooter.appendChild(userName);
            sidebarFooter.style.display = "flex";
            sidebarFooter.style.alignItems = "center";
            sidebarFooter.style.gap = "0.75rem";
            """

            // Main Content Container
            + """
            const mainContent = document.createElement("div");
            mainContent.style.marginLeft = "16rem";
            mainContent.style.padding = "2rem";
            mainContent.style.minHeight = "100vh";
            """

            // Header Section
            + """
            const header = document.createElement("div");
            header.style.marginBottom = "2rem";

            const pageTitle = document.createElement("h1");
            pageTitle.textContent = "Currently Watching";
            pageTitle.style.fontSize = "2rem";
            pageTitle.style.fontWeight = "700";
            pageTitle.style.marginBottom = "0.5rem";
            header.appendChild(pageTitle);

            const pageDesc = document.createElement("p");
            pageDesc.textContent = "Track your anime progress and discover new series";
            pageDesc.style.fontSize = "1rem";
            pageDesc.style.opacity = "0.7";
            header.appendChild(pageDesc);

            mainContent.appendChild(header);
            """

        // Tabs for filtering
        + ShTabs.render(varName: "filterTabs")
        + ShTabs.list(into: "filterTabs", varName: "tabsList")
        + ShTabs.trigger(into: "tabsList", varName: "tabAll", text: "All", value: "all")
        + ShTabs.trigger(into: "tabsList", varName: "tabAiring", text: "Airing", value: "airing")
        + ShTabs.trigger(
            into: "tabsList", varName: "tabFinished", text: "Finished", value: "finished")
            + """
            mainContent.appendChild(filterTabs);
            tabAll.classList.add("active");
            """

            // Add tab click handlers
            + """
            const tabTriggers = [tabAll, tabAiring, tabFinished];
            tabTriggers.forEach(function(trigger) {
                trigger.addEventListener("click", function() {
                    tabTriggers.forEach(function(t) { t.classList.remove("active"); });
                    trigger.classList.add("active");
                });
            });
            """

            // Grid Container for Anime Cards
            + """
            const animeGrid = document.createElement("div");
            animeGrid.style.display = "grid";
            animeGrid.style.gridTemplateColumns = "repeat(auto-fill, minmax(320px, 1fr))";
            animeGrid.style.gap = "1.5rem";
            animeGrid.style.marginTop = "2rem";
            """

        // Anime Card 1: Attack on Titan
        + ShCard.render(varName: "card1")
        + ShCard.header(into: "card1", varName: "card1Header")
            + """
            const card1Img = document.createElement("img");
            card1Img.src = "https://placehold.co/300x400/3b82f6/ffffff?text=Attack+on+Titan";
            card1Img.style.width = "100%";
            card1Img.style.height = "200px";
            card1Img.style.objectFit = "cover";
            card1Img.style.borderRadius = "0.5rem";
            card1Img.style.marginBottom = "1rem";
            card1Header.appendChild(card1Img);
            """
        + ShCard.title(into: "card1Header", varName: "card1Title", text: "Attack on Titan")
        + ShBadge.render(varName: "badge1", text: "Airing", variant: "default")
            + """
            card1Header.appendChild(badge1);
            badge1.style.marginTop = "0.5rem";
            """
        + ShCard.content(into: "card1", varName: "card1Content")
            + """
            const ep1Text = document.createElement("p");
            ep1Text.textContent = "Episode 15 / 24";
            ep1Text.style.fontSize = "0.875rem";
            ep1Text.style.marginBottom = "1rem";
            card1Content.appendChild(ep1Text);
            """
        + ShProgress.render(varName: "progress1", value: 62)
            + """
            card1Content.appendChild(progress1);
            """
        + ShCard.footer(into: "card1", varName: "card1Footer")
        + ShButton.render(varName: "btn1", text: "Continue", variant: "default", size: "sm")
        + ShButton.render(varName: "btn1Edit", text: "Edit", variant: "outline", size: "sm")
            + """
            card1Footer.appendChild(btn1);
            card1Footer.appendChild(btn1Edit);
            animeGrid.appendChild(card1);
            """

        // Anime Card 2: Demon Slayer
        + ShCard.render(varName: "card2")
        + ShCard.header(into: "card2", varName: "card2Header")
            + """
            const card2Img = document.createElement("img");
            card2Img.src = "https://placehold.co/300x400/ef4444/ffffff?text=Demon+Slayer";
            card2Img.style.width = "100%";
            card2Img.style.height = "200px";
            card2Img.style.objectFit = "cover";
            card2Img.style.borderRadius = "0.5rem";
            card2Img.style.marginBottom = "1rem";
            card2Header.appendChild(card2Img);
            """
        + ShCard.title(into: "card2Header", varName: "card2Title", text: "Demon Slayer")
        + ShBadge.render(varName: "badge2", text: "Finished", variant: "secondary")
            + """
            card2Header.appendChild(badge2);
            badge2.style.marginTop = "0.5rem";
            """
        + ShCard.content(into: "card2", varName: "card2Content")
            + """
            const ep2Text = document.createElement("p");
            ep2Text.textContent = "Episode 8 / 26";
            ep2Text.style.fontSize = "0.875rem";
            ep2Text.style.marginBottom = "1rem";
            card2Content.appendChild(ep2Text);
            """
        + ShProgress.render(varName: "progress2", value: 31)
            + """
            card2Content.appendChild(progress2);
            """
        + ShCard.footer(into: "card2", varName: "card2Footer")
        + ShButton.render(varName: "btn2", text: "Continue", variant: "default", size: "sm")
        + ShButton.render(varName: "btn2Edit", text: "Edit", variant: "outline", size: "sm")
            + """
            card2Footer.appendChild(btn2);
            card2Footer.appendChild(btn2Edit);
            animeGrid.appendChild(card2);
            """

        // Anime Card 3: My Hero Academia (Skeleton Loading)
        + ShCard.render(varName: "card3")
        + ShCard.header(into: "card3", varName: "card3Header")
        + ShSkeleton.render(varName: "skelImg3", width: "100%", height: "200px")
            + """
            card3Header.appendChild(skelImg3);
            skelImg3.style.marginBottom = "1rem";
            """
        + ShSkeleton.render(varName: "skelTitle3", width: "60%", height: "1.5rem")
            + """
            card3Header.appendChild(skelTitle3);
            """
        + ShCard.content(into: "card3", varName: "card3Content")
        + ShSkeleton.render(varName: "skelEp3", width: "40%", height: "0.875rem")
            + """
            card3Content.appendChild(skelEp3);
            skelEp3.style.marginBottom = "1rem";
            """
        + ShSkeleton.render(varName: "skelProg3", width: "100%", height: "0.5rem")
            + """
            card3Content.appendChild(skelProg3);
            """
        + ShCard.footer(into: "card3", varName: "card3Footer")
        + ShSkeleton.render(varName: "skelBtn3", width: "80px", height: "2rem")
            + """
            card3Footer.appendChild(skelBtn3);
            animeGrid.appendChild(card3);
            """

        // Anime Card 4: One Piece
        + ShCard.render(varName: "card4")
        + ShCard.header(into: "card4", varName: "card4Header")
            + """
            const card4Img = document.createElement("img");
            card4Img.src = "https://placehold.co/300x400/10b981/ffffff?text=One+Piece";
            card4Img.style.width = "100%";
            card4Img.style.height = "200px";
            card4Img.style.objectFit = "cover";
            card4Img.style.borderRadius = "0.5rem";
            card4Img.style.marginBottom = "1rem";
            card4Header.appendChild(card4Img);
            """
        + ShCard.title(into: "card4Header", varName: "card4Title", text: "One Piece")
        + ShBadge.render(varName: "badge4", text: "Airing", variant: "default")
            + """
            card4Header.appendChild(badge4);
            badge4.style.marginTop = "0.5rem";
            """
        + ShCard.content(into: "card4", varName: "card4Content")
            + """
            const ep4Text = document.createElement("p");
            ep4Text.textContent = "Episode 1087 / ???";
            ep4Text.style.fontSize = "0.875rem";
            ep4Text.style.marginBottom = "1rem";
            card4Content.appendChild(ep4Text);
            """
        + ShProgress.render(varName: "progress4", value: 85)
            + """
            card4Content.appendChild(progress4);
            """
        + ShCard.footer(into: "card4", varName: "card4Footer")
        + ShButton.render(varName: "btn4", text: "Continue", variant: "default", size: "sm")
        + ShButton.render(varName: "btn4Edit", text: "Edit", variant: "outline", size: "sm")
            + """
            card4Footer.appendChild(btn4);
            card4Footer.appendChild(btn4Edit);
            animeGrid.appendChild(card4);
            """

            + """
            mainContent.appendChild(animeGrid);
            """

        // Add Edit Modal Example
        + ShModal.render(varName: "editModal")
        + ShModal.content(into: "editModal", varName: "modalContent")
        + ShModal.close(into: "modalContent", varName: "modalClose")
        + ShModal.header(into: "modalContent", varName: "modalHeader")
        + ShModal.title(into: "modalHeader", varName: "modalTitle", text: "Edit Anime Progress")
        + ShModal.description(
            into: "modalHeader", varName: "modalDesc",
            text: "Update your watching progress and status")
        + ShModal.body(into: "modalContent", varName: "modalBody")
            + """
            const inputLabel = document.createElement("label");
            inputLabel.textContent = "Current Episode";
            inputLabel.style.display = "block";
            inputLabel.style.fontSize = "0.875rem";
            inputLabel.style.fontWeight = "500";
            inputLabel.style.marginBottom = "0.5rem";
            modalBody.appendChild(inputLabel);
            """
        + ShInput.render(varName: "episodeInput", placeholder: "15", type: "number")
            + """
            modalBody.appendChild(episodeInput);
            episodeInput.style.marginBottom = "1rem";

            const statusLabel = document.createElement("label");
            statusLabel.textContent = "Status";
            statusLabel.style.display = "block";
            statusLabel.style.fontSize = "0.875rem";
            statusLabel.style.fontWeight = "500";
            statusLabel.style.marginBottom = "0.5rem";
            modalBody.appendChild(statusLabel);
            """
        + ShSelect.render(varName: "statusSelect")
        + ShSelect.trigger(
            into: "statusSelect", varName: "selectTrigger", placeholder: "Select status")
        + ShSelect.content(into: "statusSelect", varName: "selectContent")
        + ShSelect.item(
            into: "selectContent", varName: "selectWatching", text: "Watching", value: "watching")
        + ShSelect.item(
            into: "selectContent", varName: "selectCompleted", text: "Completed", value: "completed"
        )
        + ShSelect.item(
            into: "selectContent", varName: "selectDropped", text: "Dropped", value: "dropped")
        + ShSelect.item(
            into: "selectContent", varName: "selectPlan", text: "Plan to Watch", value: "plan")
            + """
            modalBody.appendChild(statusSelect);
            """
        + ShModal.footer(into: "modalContent", varName: "modalFooter")
        + ShButton.render(varName: "modalCancel", text: "Cancel", variant: "outline", size: "md")
        + ShButton.render(
            varName: "modalSave", text: "Save Changes", variant: "default", size: "md")
            + """
            modalFooter.appendChild(modalCancel);
            modalFooter.appendChild(modalSave);
            """

            // Modal Event Handlers
            + """
            btn1Edit.addEventListener("click", function() {
                editModal.classList.add("open");
            });

            btn2Edit.addEventListener("click", function() {
                editModal.classList.add("open");
            });

            btn4Edit.addEventListener("click", function() {
                editModal.classList.add("open");
            });

            modalClose.addEventListener("click", function() {
                editModal.classList.remove("open");
            });

            modalCancel.addEventListener("click", function() {
                editModal.classList.remove("open");
            });

            modalSave.addEventListener("click", function() {
                editModal.classList.remove("open");
            });

            editModal.addEventListener("click", function(e) {
                if (e.target === editModal) {
                    editModal.classList.remove("open");
                }
            });

            // Select dropdown toggle
            selectTrigger.addEventListener("click", function() {
                selectContent.classList.toggle("open");
            });

            // Select item click
            const selectItems = [selectWatching, selectCompleted, selectDropped, selectPlan];
            selectItems.forEach(function(item) {
                item.addEventListener("click", function() {
                    selectItems.forEach(function(i) { i.classList.remove("selected"); });
                    item.classList.add("selected");
                    selectTrigger.textContent = item.textContent;
                    selectContent.classList.remove("open");
                });
            });

            // Close select when clicking outside
            document.addEventListener("click", function(e) {
                if (!statusSelect.contains(e.target)) {
                    selectContent.classList.remove("open");
                }
            });
            """

    let fullJS = JSProcessor.process {
        JSStatement(code: "function initApp() {")
        JSStatement(code: componentJS)
        JSStatement(
            code: """
                    document.body.appendChild(sidebar);
                    document.body.appendChild(mainContent);
                    document.body.appendChild(editModal);
                """)
        JSStatement(code: "}")
        JSStatement(code: "document.addEventListener('DOMContentLoaded', initApp);")
    }

    let htmlContent = """
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>MyAT</title>
            <style>
                \(ShTheme.getStyles())
            </style>
        </head>
        <body>
            <script>
                \(fullJS)
            </script>
        </body>
        </html>
        """

    return HTTPResponse.html(statusCode: 200, reason: "OK", body: htmlContent)
}
