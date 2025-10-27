import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { [weak self] in
            guard let self = self else { return }
            self.addSubview($0)
        }
    }
}
