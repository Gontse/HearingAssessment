import Foundation

struct PostHearingScoreRequest: Request {
    typealias response = ()
    
    let scoreEncodedObject: Data
    init?(_ scoreModelObject: HearingScore) { // Failable
        let encoder = JSONEncoder()
        let serializedData = try? encoder.encode(scoreModelObject)
        guard let safeScoreData = serializedData else { return nil }
        scoreEncodedObject = safeScoreData
    }
    
    var method: HTTPMethod { return .POST }
    var path: String { return "" }
    var contentType: String { return "application/json" }
    var additionalHeaders: [String : String] { return [:] }
    var body: Data? { return scoreEncodedObject }
    var parameters: [String:String]? {return nil}

    func handle(response: Data) throws -> ()? { nil }
}

