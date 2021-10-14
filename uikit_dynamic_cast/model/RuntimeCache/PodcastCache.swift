//
//  PodcastCache.swift
//  uikit_dynamic_cast
//
//  Created by Ayxan Haqverdili on 14.10.21.
//

import Foundation
import UIKit

struct PodcastCache
{
    let podcastData: PodcastData
    let artwork: UIImage?
    let items: [EpisodeData]?
}

class CachedPoscastsTable
{
    public static let shared = CachedPoscastsTable()
    
    private init()
    {
    }
    
    private var podcasts = [PodcastData.ID : PodcastCache]()
    
    func getCache(for podcastData: PodcastData) async -> PodcastCache {
        if let cache = podcasts[podcastData.id] {
            return cache
        }
        
        async let img = podcastData.loadArtwork()
        async let items = podcastData.loadFeed()
        
        let cache = PodcastCache(
            podcastData: podcastData,
            artwork: await img,
            items: await items
        );
        
        podcasts[podcastData.id] = cache
        
        return cache
    }
}
