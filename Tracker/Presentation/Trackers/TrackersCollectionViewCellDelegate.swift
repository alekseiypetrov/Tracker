import UIKit

protocol TrackersCollectionViewCellDelegate: AnyObject {
    func didTappedButtonInTracker(_ tracker: TrackersCollectionViewCell)
}
