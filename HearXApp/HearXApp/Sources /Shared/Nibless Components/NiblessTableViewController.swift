import UIKit

open class NiblessTableViewController: UITableViewController {
    // MARK: - Methods
    public init() { super.init(nibName: nil, bundle: nil) }
    
    @available(*, unavailable, message: "Loading this tableview Controller from a nib is unsupported in favor of initializer dependency injection.")
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) { super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil) }
    
    @available(*, unavailable, message: "Loading this tableview controller from a nib is unsupported in favor of initializer dependency injection." )
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Loading this tableview controller from a nib is unsupported in favor of initializer dependency injection.")
    }
}
