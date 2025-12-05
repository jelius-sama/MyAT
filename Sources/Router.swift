func InitRouting(router: Router) {
    router.register(method: "GET", path: "/") { req in return Home(request: req) }
    router.register(method: "GET", path: "/legacy") { req in return Legacy(request: req) }
}
