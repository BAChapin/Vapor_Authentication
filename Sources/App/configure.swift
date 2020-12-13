import Vapor
import Fluent
import FluentPostgresDriver

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    app.http.server.configuration.port = 9090
    
    app.databases.use(.postgres(hostname: "localhost", username: "postgres", password: "", database: "authenticationtest"), as: .psql)
    
    app.migrations.add(User.Migration())
    app.migrations.add(UserToken.Migration())

    // register routes
    try routes(app)
}
