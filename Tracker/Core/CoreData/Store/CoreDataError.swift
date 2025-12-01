enum CoreDataError: Error {
    case duplicatingValue(String)
    case nonExistentValue(String)
    case invalidStore
}
