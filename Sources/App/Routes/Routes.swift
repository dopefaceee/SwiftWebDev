import Vapor
import PostgreSQLProvider

extension Droplet {
    func setupRoutes() throws {
        
        //MARK: - Test Routes
        
        get("") { req in
            return try self.view.make("myview", Node(node: ["name" : "Ade "]))
        }
        
        get("user", String.parameter) { req in
            let nameId = try req.parameters.next(String.self)
            return try self.view.make("myview", Node(node: ["name" : nameId]))
        }
        
        get("user2") { req in
            let users = try ["Ade", "Suluh", "Nandi"].makeNode(in: Context.self as? Context)
            return try self.view.make("myview2", Node(node: ["users" : users]))
        }
        
        get("user3") { req in
            let users = try[
                ["name" : "Ade", "email" : "ade.suluh@gmail.com"].makeNode(in: Context.self as? Context),
                ["name" : "Dope", "email" : "dope@gmail.com"].makeNode(in: Context.self as? Context),
                ["name" : "Bro", "email" : "bro@gmail.com"].makeNode(in: Context.self as? Context)
            ].makeNode(in: Context.self as? Context)
            
            
            return try self.view.make("myview3", Node(node: ["users" : users]))
        }
        
        get("user4") { req in
            guard let sayHello = req.data["sayHello"]?.bool else {
                throw Abort.badRequest
            }
            return try self.view.make("myview4", Node(node: ["sayHello" : sayHello.makeNode(in: Context.self as? Context)]))
        }
        
        get("version") {req in
            let version = try self.postgresql().raw("SELECT version()");
            return JSON(node: version)
        }
        
        //using noderepresentable & jsonrepresentable
        get("model") { req in
            let acronym = Acronym(short: "AFK", long: "Away From Keyboard")
            return try acronym.makeJSON()
        }
        
        get("test") { req in
            var acronym = Acronym(short: "AFK", long: "Away From Keyboard")
            try acronym.save()
            return try Acronym.all().makeJSON()
        }
        
        //MARK: - CRUD
        
        post("create") { req in
            guard let json = req.json else {
                throw Abort(.badRequest, reason: "no json provided")
            }
            let acronym: Acronym
            do {
                acronym = try Acronym(json: json)
            }
            catch {
                throw Abort(.badRequest, reason: "incorrect json")
            }
            
            try acronym.save()
            return try acronym.makeJSON()
        }
        
        get("read") { req in
            
            let acro = try Acronym.makeQuery().sort(Acronym.idKey, .ascending)
        
            return try acro.all().makeJSON()
        }
        
        get("read", Int.parameter) { req in
            let acroId = try req.parameters.next(Int.self)
            guard let acro = try Acronym.find(acroId) else {
                throw Abort(.badRequest, reason: "user with id \(acroId) does not exist")
            }
            return try acro.makeJSON()
        }
        
        put("update", Int.parameter) { req in
            let acroId = try req.parameters.next(Int.self)
            
            guard let acro = try Acronym.find(acroId) else {
                throw Abort(.badRequest, reason: "user with given id: \(acroId) could not be found")
            }
            
            guard let short = req.data["short"]?.string else {
                 throw Abort(.badRequest, reason: "no short provided")
            }
            
            guard let long = req.data["long"]?.string else {
                throw Abort(.badRequest, reason: "no long provided")
            }
            acro.short = short
            acro.long = long

            
            try acro.save()
            return try acro.makeJSON()
        }
        
        //update approach from ray wenderlich
        get("update2") { req in
            guard var first = try Acronym.makeQuery().first(), let long = req.data["long"]?.string else {
                throw Abort.badRequest
            }
            first.long = long
            try first.save()
            return try first.makeJSON()
        }
        
        delete("delete", Int.parameter) { req in
            let acroId = try req.parameters.next(Int.self)
            
            guard let acro = try Acronym.find(acroId) else {
                throw Abort(.badRequest, reason: "acronym with id \(acroId) does not exist")
            }
            
            try acro.delete()
            return try JSON(node: ["type" : "success", "message" : "acronym with id \(acroId) were successfully deleted"])
        }
        
        
        
//        get("user", Int.parameter) { req in
//            let userId = try req.parameters.next(Int.self)
//            return "You requested User #\(userId + 1)"
//        }
        
        
//        get("post") { req in
//            guard let name = req.data["name"]?.string else {
//                throw Abort.badRequest
//            }
//            return try JSON(json: [
//                "message": "Hello, \(name)!"
//                ])
//        }
        
        get("who", "is") { req in
            return "The Dopefaceee"
        }
        
        get("testjson") { req in
            return JSON(json: [
                "message" : "Hello, Json"
                ])
        }
        
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
