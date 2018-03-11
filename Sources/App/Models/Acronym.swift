//
//  Acronym.swift
//  VaporAppPackageDescription
//
//  Created by Ade Suluh on 03/03/18.
//

import Foundation
import Vapor
import PostgreSQLProvider
import Node
import FluentProvider

final class Acronym : Model {
    
    let storage = Storage()
    
    var short: String
    var long: String
    
    var exists: Bool = false
    
    static let idKey = "id"
    static let shortKey = "short"
    static let longkey = "long"
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Acronym.shortKey, short)
        try row.set(Acronym.longkey, long)
        return row
    }
    
     init(row: Row) throws {
        short = try row.get(Acronym.shortKey)
        long = try row.get(Acronym.longkey)
    }
    
    init(short:String, long: String) {
        self.short = short
        self.long = long
    }
    
    
}

extension Acronym: ResponseRepresentable { }

extension Acronym: JSONConvertible, NodeRepresentable, Preparation {
    
    //MARK: - Preparation
    static func prepare(_ database: Database) throws {
        try database.create(self, closure: { acro in
            acro.id()
            acro.string("short")
            acro.string("long")
        })
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
    
    // let you initiate user with json
    convenience init(json: JSON) throws {
        self.init(
            short: try json.get(Acronym.shortKey),
            long: try json.get(Acronym.longkey)
        )
    }
    
    convenience init(node: Node) throws {
        self.init(
        short: try node.get(Acronym.shortKey),
        long: try node.get(Acronym.longkey)
        )
    }
    
    // create json out of user instance
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Acronym.idKey, id)
        try json.set(Acronym.shortKey, short)
        try json.set(Acronym.longkey, long)
        return json
    }
    
    func makeNode(in context: Context) throws -> Node {
        var node = Node(context)
        try node.set(Acronym.shortKey, short)
        try node.set(Acronym.longkey, long)
        return node
    }
    
    
}






















