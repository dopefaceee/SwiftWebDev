import Vapor

extension Droplet {
    func setupRoutes() throws {
        
        get("") { req in
            return try self.view.make("myview")
        }
        
        get("who", "is") { req in
            return "The Dopefaceee"
        }
        
//        get("user", Int.parameter) { req in
//            let userId = try req.parameters.next(Int.self)
//            return "You requested User #\(userId + 1)"
//        }
        
        get("testjson") { req in
            return JSON(json: [
                "message" : "Hello, Json"
                ])
        }
        
//        get("post") { req in
//            guard let name = req.data["name"]?.string else {
//                throw Abort.badRequest
//            }
//            return try JSON(json: [
//                "message": "Hello, \(name)!"
//                ])
//        }
        
        get("hello") { req in
            var json = JSON()
            try json.set("hello", "world")
            return json
        }

        get("plaintext") { req in
            return "Hello, world!"
        }

        // response to requests to /info domain
        // with a description of the request
        get("info") { req in
            return req.description
        }

        get("description") { req in return req.description }
        
        try resource("posts", PostController.self)
    }
}
