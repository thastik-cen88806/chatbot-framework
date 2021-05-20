
import Fluent
import FluentSQLiteDriver
import Vapor


public func configure(_ app: Application) throws {

    app.views.use(.leaf)

    app.databases.use(.sqlite(), as: .sqlite)
    app.migrations.add(CreateQuestion())

    try app.autoMigrate().wait()
    try routes(app)
}
