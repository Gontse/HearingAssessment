import UIKit
import AVFoundation

class HearingTestViewController: NiblessViewController {
    private var hearingTestView: HearingTestView
    private var waterEffect: AVAudioPlayer?
    private var numberCountSound: AVAudioPlayer?
    var navigateToScoreScreen: ((String) -> Void)?
    
    init(hearingTestView: HearingTestView) {
        self.hearingTestView = hearingTestView
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func loadView() {
        self.view = hearingTestView
        hearingTestView.shouldPlaySound = { [weak self] levelUrlContent, numberCountsUrlContent in
            self?.playSounds(level: levelUrlContent, numbers: numberCountsUrlContent)
        }
    }
    
    private func playSounds(level: URL, numbers: [URL]) {
        func playCounts() { // Inner func
            var seconds = 0
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                if seconds == 3 {
                    let hearingView = self.view as? HearingTestView
                    timer.invalidate()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { hearingView?.viewState = .answering }
                } else {
                    let url = numbers[seconds]
                    self.numberCountSound = try? AVAudioPlayer(contentsOf: url)
                    self.numberCountSound?.play()
                    seconds += 1
                }
            }
        }
        
        waterEffect = try? AVAudioPlayer(contentsOf: level)
        waterEffect?.play()
       
        // Delay a bit
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { playCounts() }
        
    }
}
