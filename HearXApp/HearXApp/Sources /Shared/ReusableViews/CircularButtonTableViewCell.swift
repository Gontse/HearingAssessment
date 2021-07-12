import UIKit

final class CircularButtonTableViewCell: UITableViewCell, TableviewCellReusable {
  
    // MARK: Private Properties
    @IBOutlet weak private(set) var circularButton: UIButton! // expose read-only
   
    // MARK: Internal Properties
    var buttonActionBlock: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeButtonCircular()
    }
    
    // MARK: - Exposed/Internal functions
    
    func setButtonTitle(_ title: String) { circularButton.setTitle(title, for: .normal) }
    func setButtonBackgroundColor(_ color: UIColor) { circularButton.backgroundColor = color }
    func setButtonTitleFont(_ font: UIFont) { circularButton.titleLabel?.font = font }
    
    // MARK: - Private/Helper functions
    
    private func makeButtonCircular() { circularButton.layer.cornerRadius = circularButton.bounds.height/2 }
    @IBAction private func buttonAction(_ sender: Any) { buttonActionBlock?() }
}
