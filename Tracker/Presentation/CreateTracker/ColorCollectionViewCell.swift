import UIKit

final class ColorCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ColorCollectionViewCell"
    
    private enum Constants {
        static let cornerRadius: CGFloat = 8.0
        static let borderWidth: CGFloat = 3.0
    }
    
    private lazy var colorView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = Constants.cornerRadius
        view.layer.borderWidth = Constants.borderWidth
        view.layer.borderColor = UIColor.ypWhite.cgColor
        return view
    }()
    
    private var sizeConstraints: [NSLayoutConstraint] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error in init?(coder:)")
    }
    
    func configCell(with color: UIColor, sizeOfView size: CGFloat) {
        colorView.backgroundColor = color
        sizeConstraints.forEach { $0.constant = size }
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    private func setupViewAndConstraints() {
        let views = [colorView]
        contentView.addSubviews(views)
        
        sizeConstraints = [
            colorView.widthAnchor.constraint(equalToConstant: 0.0),
            colorView.heightAnchor.constraint(equalToConstant: 0.0)
        ]
               
        NSLayoutConstraint.activate([
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
        NSLayoutConstraint.activate(sizeConstraints)
    }
}
