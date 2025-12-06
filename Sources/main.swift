let router = Router()

// Global middleware: Analytics and logging for all requests.
router.use { request in
    print("[\(request.method)] \(request.path)")
    return Optional<HTTPResponse>.none
}

// Custom 404 handler with builder pattern.
let notFoundBuilder = router.setNotFoundHandler()
    .forAssets() { req in return AssetNotfound(request: req) }
    .forAPI(prefix: "/api/") { req in return APINotfound(request: req) }
    .default { req in return DefaultNotfound(request: req) }

router.finalize404Handler(builder: notFoundBuilder)

// Initialize routes
InitRouting(router: router)

let server = HTTPServer(
    port: 6969,
    router: router,
    assetManager: Optional<AssetManager>.some(
        AssetManager(useEmbedded: true, pathPrefix: "/resource/"))
)

server.start()
