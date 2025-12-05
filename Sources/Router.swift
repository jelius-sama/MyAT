func InitRouting(router: Router) {
    router.register(method: "GET", path: "/") { req in return HTMLExample(request: req) }
}
