//
//  TILController.swift
//  VaporAppPackageDescription
//
//  Created by Ade Suluh on 05/03/18.
//

import Vapor
import HTTP

final class TILController {
    
    let drop: Droplet
    
    init(drop: Droplet) {
        self.drop = drop
    }
    
    func addRoutes(drop: Droplet)
    {
        drop.get("til", handler: indexView)
        drop.post("til", handler: addAcronym)
        drop.post("til", Acronym.parameter, "delete", handler: deleteAcronym)
    }
    
    func indexView(request: Request) throws -> ResponseRepresentable
    {
        let acro = try Acronym.makeQuery().sort(Acronym.idKey, .descending)
        
        let acronyms =  try acro.all().makeJSON()
        
        let parameters = try Node(node: [
            "acronyms": acronyms,
            ])
        
        return try drop.view.make("index", parameters)
    }
    
    func addAcronym(request: Request) throws -> ResponseRepresentable
    {
        guard let short = request.data["short"]?.string, let long = request.data["long"]?.string else {
            throw Abort.badRequest
        }
        
        var acronym = Acronym(short: short, long: long)
        try acronym.save()
        
        return Response(redirect: "/til")
    }
    
    func deleteAcronym(request: Request) throws -> ResponseRepresentable
    {
        let acronym = try request.parameters.next(Acronym.self)
        try acronym.delete()
        return try self.indexView(request: request)
    }
    
}























