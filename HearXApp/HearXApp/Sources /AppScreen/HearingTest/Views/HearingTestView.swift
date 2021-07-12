import UIKit
import Lottie

// MARK: - View Statate

enum HearingTestScreenState { // swift does not have friend objects :(
    case counting
    case answering
}

// MARK: - View

class HearingTestView: NiblessView {
    
    // MARK: Private Properties
    private let viewModel: HearingTestViewModel
    private let answerContentView: UIView = UIView()
    private let soundContentView: UIView = UIView()
    private let animationView = AnimationView()
    private let kCounter = 3
    
    // MARK: Internally Exposed
    var done: (() -> Void)?
    var viewState: HearingTestScreenState = .counting { didSet { updateState(viewState) } }
    var shouldPlaySound: ((URL, [URL]) -> Void)?
    
    // MARK: View Life Cycle
    init(frame: CGRect = .zero, viewModel: HearingTestViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        viewModel.nextRound = { [weak self] in
            self?.animationView.alpha = 0
            self?.nextRound() }
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        constructHierarchy()
        activateConstraints()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { self.startTimer(from: self.kCounter) }
        activateConstraintsAnimationView()
        animationConfiguration()
        playBoatAnimation()
       
        
        answerField.delegate = self
        submitButton.actionHandle(controlEvents: .touchUpInside, ForAction:{ () -> Void in
            self.endEditing(true)
            self.viewModel.validateAnswer(self.answerField.text ?? "")
        })
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
        self.addGestureRecognizer(tap)
    }
    
    // MARK: - Answer View Components
    private let submitButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Submit", for: .normal)
        button.setTitle("", for: .disabled)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 5
        button.backgroundColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
        return button
    }()
    
    private let answerField: UITextField = {
        let field = UITextField()
        field.placeholder = " Enter Answer"
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.layer.borderWidth = 1.2
        field.textColor = .black
        field.layer.cornerRadius = 5
        field.keyboardType = .numberPad
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        return field
    }()
    
    // MARK: - Sounds View Components
    private let counterLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        label.font = .boldSystemFont(ofSize: 58)
        label.text = "3"
        return label
    }()
    
    private let soundTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        label.font = .boldSystemFont(ofSize: 30)
        label.text = "Listen Attentively"
        label.alpha = 0
        return label
    }()
}

// MARK: Helper Functions

extension HearingTestView {
    private func startTimer(from seconds: Int) {
        func animateCounter(_ label: UILabel) {
            label.alpha = 1
            UIView.animate(withDuration: 0.3,
                           delay: 0.0,
                           options: .curveEaseInOut) { label.transform = CGAffineTransform.init(scaleX: 2.0, y: 2.0)
            } completion: { _ in
                UIView.animate(withDuration: 0.3) {
                    label.alpha = 0
                    label.transform = .identity
                }
            }
        }
        
        counterLabel.text = "\(seconds)"
        animateCounter(counterLabel)
        var seconds = seconds
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            seconds -= 1
            if seconds == 0 {
                self.counterLabel.text = "Go!"
                animateCounter(self.counterLabel)
                timer.invalidate()
                self.triggerSound()
            } else {
                self.counterLabel.text = "\(seconds)"
                animateCounter(self.counterLabel)
            }
        }
    }
    
    private func nextRound() {
        viewState = .counting
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.answerField.text = ""
            self.soundTitleLabel.alpha = 0
            self.startTimer(from: 2)
        }
    }
    
    private func triggerSound() {
        UIView.animate(withDuration: 1.0, delay: 0.5,
                       options: .curveEaseIn,
                       animations: { self.soundTitleLabel.alpha = 1 },
                       completion: nil)
        
        UIView.animate(withDuration: 0.5,
                       delay: 1.0,
                       options: .curveEaseIn,
                       animations: { self.animationView.alpha = 1},
                       completion: {_ in self.getSoundsSounds()})
    }
    
    private func animationConfiguration() {
        animationView.frame.size = CGSize(width: Constants.Metrics.constant250, height: Constants.Metrics.constant250)
        animationView.layer.cornerRadius = (animationView.bounds.size.height/2)
        animationView.contentMode = .scaleAspectFit
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.alpha = 0
    }
    
    private func playBoatAnimation() {
        animationView.animation = Animation.named("boat-on-peaceful-water")
        self.animationView.play(fromProgress: 0,
                                toProgress: 1,
                                loopMode: .loop,
                                completion: { finished in
                                    if finished { debugPrint("Animation completed") }
                                    else { debugPrint("Animation cancelled") } })
    }
    
    private func activateConstraints() {
        activateConstraintsAnswerContentView()
        activateConstraintsSoundContentView()
        activateConstraintsAnswerField()
        activateConstraintsSubmitButton()
        activateConstraintsCounterLabel()
        activateConstraintsSoundTitleLabel()
    }
    
    private func constructHierarchy() {
        answerContentView.addSubview(answerField)
        answerContentView.addSubview(submitButton)
        addSubview(answerContentView)
        soundContentView.addSubview(counterLabel)
        soundContentView.addSubview(animationView)
        soundContentView.addSubview(soundTitleLabel)
        addSubview(soundContentView)
    }
    
    private func updateState(_ state: HearingTestScreenState) {
        var opacity: CGFloat = 1
        switch state {
        case .counting: break
        case .answering: opacity = 0 }
        
        updateView(opacity)
    }
    
    private func updateView(_ opacity: CGFloat) {
        UIView.animate(withDuration: 0.5, delay: 1.0, options: .curveEaseInOut, animations: {
            self.soundContentView.alpha = opacity
        }, completion: nil)
    }
}

extension HearingTestView {
    func activateConstraintsAnswerContentView() {
        answerContentView.translatesAutoresizingMaskIntoConstraints = false
        let leading = answerContentView.leadingAnchor.constraint(equalTo: leadingAnchor)
        let trailing = answerContentView.trailingAnchor.constraint(equalTo: trailingAnchor)
        let top = answerContentView.topAnchor.constraint(equalTo: topAnchor)
        let bottom = answerContentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
        answerContentView.backgroundColor = .white
    }
    
    func activateConstraintsAnswerField() {
        answerField.translatesAutoresizingMaskIntoConstraints = false
        answerField.topAnchor.constraint(equalTo: answerContentView.topAnchor, constant: Constants.Metrics.padding200).isActive = true
        answerField.leadingAnchor.constraint(equalTo: answerContentView.leadingAnchor, constant: Constants.Metrics.sideConstraint15).isActive = true
        answerField.trailingAnchor.constraint(equalTo: answerContentView.trailingAnchor, constant: (Constants.Metrics.sideConstraint15 * -1)).isActive = true
        answerField.heightAnchor.constraint(equalToConstant: Constants.Metrics.padding50).isActive = true
    }
    
    func activateConstraintsSubmitButton() {
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.topAnchor.constraint(equalTo: answerField.bottomAnchor, constant: Constants.Metrics.padding40).isActive = true
        submitButton.leadingAnchor.constraint(equalTo: answerContentView.leadingAnchor, constant: Constants.Metrics.sideConstraint15).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: answerContentView.trailingAnchor, constant: (Constants.Metrics.sideConstraint15 * -1)).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: Constants.Metrics.padding50).isActive = true
    }
    
    func activateConstraintsSoundContentView() {
        soundContentView.translatesAutoresizingMaskIntoConstraints = false
        let leading = soundContentView.leadingAnchor.constraint(equalTo: leadingAnchor)
        let trailing = soundContentView.trailingAnchor.constraint(equalTo: trailingAnchor)
        let top = soundContentView.topAnchor.constraint(equalTo: topAnchor)
        let bottom = soundContentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
        soundContentView.layer.zPosition = CGFloat.greatestFiniteMagnitude
        soundContentView.backgroundColor = .white
    }
    
    func activateConstraintsCounterLabel() {
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        counterLabel.centerXAnchor.constraint(equalTo: soundContentView.centerXAnchor).isActive = true
        counterLabel.centerYAnchor.constraint(equalTo: soundContentView.centerYAnchor).isActive = true
    }
    
    func activateConstraintsAnimationView() {
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.centerXAnchor.constraint(equalTo: soundContentView.centerXAnchor).isActive = true
        animationView.centerYAnchor.constraint(equalTo: soundContentView.centerYAnchor).isActive = true
        animationView.leadingAnchor.constraint(equalTo: soundContentView.leadingAnchor, constant: Constants.Metrics.sideConstraint15).isActive = true
        animationView.leadingAnchor.constraint(equalTo: soundContentView.leadingAnchor, constant: (Constants.Metrics.sideConstraint15 * -1)).isActive = true
    }
    
    func activateConstraintsSoundTitleLabel() {
        soundTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        soundTitleLabel.bottomAnchor.constraint(equalTo: animationView.topAnchor, constant: (Constants.Metrics.padding40 * -1)).isActive = true
        soundTitleLabel.leadingAnchor.constraint(equalTo: soundContentView.leadingAnchor, constant: Constants.Metrics.sideConstraint15).isActive = true
        soundTitleLabel.trailingAnchor.constraint(equalTo: soundContentView.trailingAnchor, constant: (Constants.Metrics.sideConstraint15 * -1)).isActive = true
    }
}

// MARK: - Exposed functions 

extension HearingTestView {
    private func getSoundsSounds() {
        guard let soundContentsUrl = viewModel.getSoundForDifficultyLevel(),
              let countUrls = viewModel.fetchSoundForGeneratedNumbers() else { return }
        shouldPlaySound?(soundContentsUrl,countUrls)
    }
}

extension HearingTestView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        // make sure the result is under 3 characters
        return updatedText.count <= 3
    }
}
