import Foundation

class HearingTestViewModel {
    // MARK: Private Properties
    private var repository: IHearingTestRepository
    private lazy var currentDifficultyLevel: String = "1" {
        didSet { if let levelPoints = Int(currentDifficultyLevel) { sessionScore += levelPoints } }
    }
    private lazy var counter = 1
    private lazy var sessionHistory = [SessionHistoryDTO]()
    private lazy var sessionScore = 0
    private var currentGeneratedNumbers: String?
    
    // MARK: Internally Exposed Properties
    var nextRound: (() -> Void)?
    var showScore: (() -> Void)?
    
    // MARK: Inits
    init(repository: IHearingTestRepository) {
        self.repository = repository
        currentGeneratedNumbers = generateNumbers()
    }
    
    // MARK: Helper Function(s)
    private func generateNumbers() -> String {
        let generatedNumber = String(Int.random(in: 111..<999))
        guard !generatedNumber.contains("0") else { return generateNumbers() } // recursion
        return generatedNumber
    }
    
    // MARK: Internally Exposed Functions
    func getSoundForDifficultyLevel() -> URL? { repository.fetchSoundForDifficultyLevel(currentDifficultyLevel) }
    
    func fetchSoundForGeneratedNumbers() -> [URL]? {
        var urls = [URL]()
        for currIndex in 0..<currentGeneratedNumbers!.count {
            let number = String((currentGeneratedNumbers?[currIndex])!)
            guard let urlContent = repository.fetchSoundForNumber(number) else { return nil }
            urls.append(urlContent)
        }
        return urls
    }
    
    // TODO: refactor
    func validateAnswer(_ answer: String) {
        appendHistory(answer)
        if counter <= 10 {
            var level = Int(currentDifficultyLevel)!
            if answer == currentGeneratedNumbers {
                level += 1
                if level > 10 { level = 10 } }
            else {
                level -= 1
                if level < 0 { level = 0 }
            }
            currentDifficultyLevel = "\(level)"
            //Generate new triple
            currentGeneratedNumbers = generateNumbers()
            // Ready
            nextRound?()
            // Increment
            counter += 1
        } else {
            let rounds = sessionHistory.map{ Round.init(difficulty: $0.difficulty, tripletPlayed: $0.tripletPlayed, tripletAnswered: $0.tripletAnswered) }
            repository.submit(HearingScore(score: sessionScore, rounds: rounds))
            showScore?()
        }
    }
    
    private func appendHistory(_ answer: String) {
        sessionHistory.append(SessionHistoryDTO(difficulty: Int(currentDifficultyLevel),
                                                tripletPlayed: currentGeneratedNumbers,
                                                tripletAnswered: answer))
    }
}
