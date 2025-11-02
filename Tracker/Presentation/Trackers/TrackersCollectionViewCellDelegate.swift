import UIKit

protocol TrackersCollectionViewCellDelegate: AnyObject {
    func setDaysAtTracker(with id: UInt) -> String
    func setButtonImageAtTracker(with id: UInt) -> UIImage?
    func didTappedButtonInTracker(_ tracker: TrackersCollectionViewCell)
}
