//
//  EpisodeData.swift
//  uikit_dynamic_cast
//
//  Created by Ayxan Haqverdili on 01.10.21.
//

import Foundation
import CoreData
import FeedKit
import os

struct EpisodeData: Codable {
    let title: String
    let audioUrl: URL
    let podcastURL: URL
    let description: String?
    let publishDate: Date?
    let duration: TimeInterval?
    let artworkUrl: URL?

    var progress: TimeInterval = 0;

    var id: URL { audioUrl }
    var parentId: URL { podcastURL }
}

// Encoding
extension EpisodeData {
    func encode() -> Data? {
        try? JSONEncoder().encode(self)
    }

    static func decode(_ data: Data) -> EpisodeData? {
        try? JSONDecoder().decode(EpisodeData.self, from: data);
    }
}

// Persistence
extension EpisodeData {
    static func find(from context: NSManagedObjectContext, withUrl url: URL) -> EpisodeData? {
        guard let dao = EpisodeDAO.find(from: context, withUrl: url) else { return nil }
        guard let data = dao.data else {
            let logger = Logger(subsystem: "EpisodeData", category: "BugWarn")
            logger.notice("Data was nil in storage")
            return nil
        }
        return EpisodeData.decode(data)
    }

    func isSaved(to context: NSManagedObjectContext) -> Bool {
        EpisodeData.find(from: context, withUrl: self.id) != nil
    }

    func save(to context: NSManagedObjectContext) {
        guard !isSaved(to: context) else { return }

        _ = EpisodeDAO(insertInto: context, data: self)
    }

    func unsave(from context: NSManagedObjectContext) {
        guard let dao = EpisodeDAO.find(from: context, withUrl: self.id) else { return }

        context.delete(dao)
    }
}

// RSS
extension EpisodeData {
    init?(podcastURL: URL, feedItem dataPtr: RSSFeedItem) {
        guard let title = dataPtr.title else { return nil }
        self.title = title;

        guard let audioUrl = URL(string: dataPtr.enclosure?.attributes?.url) else { return nil }
        self.audioUrl = audioUrl;

        self.description = dataPtr.description;
        self.publishDate = dataPtr.pubDate;
        self.duration = dataPtr.iTunes?.iTunesDuration;
        self.artworkUrl = URL(string: dataPtr.iTunes?.iTunesImage?.attributes?.href);
        self.podcastURL = podcastURL;
    }
}

// Operators
extension EpisodeData: Equatable {
    public static func ==(lhs: EpisodeData, rhs: EpisodeData) -> Bool {
        lhs.id == rhs.id
    }
}

extension EpisodeDAO {
    var data: Data? { data_ }
    public var id: URL { id_! }
    var parentId: URL { parentId_! }

    static func find(from context: NSManagedObjectContext, withUrl url: URL) -> EpisodeDAO? {
        let fetchRequest = EpisodeDAO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id_ = %@", url as NSURL)

        return (try? context.fetch(fetchRequest))?.first
    }

    convenience init(insertInto context: NSManagedObjectContext, data: EpisodeData) {
        self.init(context: context)
        self.data_ = data.encode()
        self.parentId_ = data.podcastURL
        self.id_ = data.id
    }
}