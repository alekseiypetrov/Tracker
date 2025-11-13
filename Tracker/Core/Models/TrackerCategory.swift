struct TrackerCategory {
    let title: String
    let trackers: [Tracker]
    
    static func convert(from categoryCoreData: TrackerCategoryCoreData) -> TrackerCategory? {
        guard let title = categoryCoreData.title,
              let trackersRelation = categoryCoreData.trackers,
              let trackersCoreData = trackersRelation.allObjects as? [TrackerCoreData]
        else { return nil }
        let trackers = trackersCoreData
            .compactMap({ (trackerCoreData: TrackerCoreData) -> Tracker? in
                Tracker.convert(from: trackerCoreData)
            })
        return TrackerCategory(title: title,
                               trackers: trackers)
    }
}
