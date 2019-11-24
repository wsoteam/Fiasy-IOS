import UIKit

extension UIViewController {
  /// A helper function to add child view controller.
    func add(childViewController: UIViewController, container: UIView) {
    childViewController.willMove(toParent: self)
    addChild(childViewController)
    container.addSubview(childViewController.view)
    childViewController.didMove(toParent: self)
  }
}
