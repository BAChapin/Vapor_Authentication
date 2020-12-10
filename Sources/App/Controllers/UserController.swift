//
//  File.swift
//  
//
//  Created by Brett Chapin on 12/9/20.
//

import Vapor

struct UserController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("user")
        let passwordProtected = routes.grouped(User.authenticator())
        
        users.post(use: user)
        passwordProtected.post("login", use: login)
    }
    
    func user(_ req: Request) throws -> EventLoopFuture<User> {
        print(#function, "start")
        try User.Create.validate(content: req)
        print("Validation Complete.")
        let create = try req.content.decode(User.Create.self)
        print("User created")
        guard create.password == create.confirmPassword else {
            throw Abort(.badRequest, reason: "Passwords did not match")
        }
        print("Passwords Match")
        
        let user = try User(name: create.name, email: create.email, passwordHash: Bcrypt.hash(create.password))
        
        return user.save(on: req.db).map { user }
    }
    
    func login(_ req: Request) throws -> User {
        try req.auth.require(User.self)
    }
    
}
