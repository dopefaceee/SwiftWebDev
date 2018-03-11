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
    }
    
    func indexView(request: Request) throws -> ResponseRepresentable
    {
        let acro = try Acronym.makeQuery().sort(Acronym.idKey, .ascending)
        
        let acronyms =  try acro.all().makeJSON()
        
        let parameters = try Node(node: [
            "acronyms": acronyms,
            ])
        
        return try drop.view.make("index", parameters)
    }
    
}

