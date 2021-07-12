import Foundation
import Combine

// MARK: - Interface

protocol IHearingTestRepository {
    func fetchSoundForNumber(_ number: String) -> URL?
    func fetchSoundForDifficultyLevel(_ level: String) -> URL?
    func submit(_ hearingScore: HearingScore)
}

// MARK: - Implementation

class HearingTestRepository: IHearingTestRepository {
 
    // MARK: Private Properties
    private var subscriptions: Set<AnyCancellable> = []
    private let networkClient: Client
    
    // MARK: Init(s)
    init(_ client: Client) { networkClient = client }
    
    // MARK: Internally Exposed
    func fetchSoundForNumber(_ number: String) -> URL? {
        guard let url = Bundle.main.url(forResource: number, withExtension: "m4a")
        else { return nil }
        return url
    }
    
    func fetchSoundForDifficultyLevel(_ level: String) -> URL? {
        guard let url = Bundle.main.url(forResource: "noise_\(level)", withExtension: "m4a")
        else { return nil }
        return url
    }
    
    func submit(_ hearingScore: HearingScore) {
        guard let request = PostHearingScoreRequest(hearingScore) else { return }
        networkClient.publisherForRequest(request).sink { results in
            switch results {
            case .finished: break
            case .failure(_): break
            }
        } receiveValue: { _ in}
        .store(in: &subscriptions)
    }
}
