import UIKit.UINib

protocol TableviewCellReusable {
    static var nib: UINib { get }
    static var reusableIdentifier: String { get }
}

extension TableviewCellReusable {
    static var nib: UINib { return UINib(nibName: String(describing: self), bundle: nil) }
    static var reusableIdentifier: String { return String(describing: self) }
}
