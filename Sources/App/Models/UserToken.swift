//
//  File.swift
//  
//
//  Created by Brett Chapin on 12/10/20.
//

import Vapor
import Fluent

final class UserToken: Model, Content {
    static var schema: String = "user_tokens"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "value")
    var value: String
    
    @Parent(key: "user_id")
    var user: User
    
    init() { }
    
    init(id: UUID? = nil, value: String, userID: User.IDValue) {
        self.id = id
        self.value = value
        self.$user.id = userID
    }
}

extension UserToken {
    struct Migration: Fluent.Migration {
        var name: String { "CreateUserToken" }
        
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema(UserToken.schema)
                .id()
                .field("value", .string, .required)
                .field("user_id", .uuid, .required, .references("users", "id"))
                .unique(on: "value")
                .create()
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema(UserToken.schema).delete()
        }
    }
}

extension UserToken: ModelTokenAuthenticatable {
    
    static let valueKey = \UserToken.$value
    static let userKey = \UserToken.$user

    var isValid: Bool {
        true
    }
    
}
