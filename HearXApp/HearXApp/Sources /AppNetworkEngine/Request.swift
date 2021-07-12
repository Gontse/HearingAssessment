import Foundation

@frozen enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

protocol Request {
    associatedtype response
    var method: HTTPMethod { get }
    var path: String { get }
    var body: Data? { get }
    
    func handle(response: Data) throws -> response?
}
