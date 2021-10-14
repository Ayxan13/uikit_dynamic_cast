import Foundation;

import Combine;

import FeedKit;

struct PodcastsNetworkModel {
    private init() {
        /* all functions are static */
    }

    public static func search(for term: String) async -> [PodcastData]? {
        var searchURLComponents = URLComponents(string: "https://itunes.apple.com/")!;
        searchURLComponents.path = "/search";
        searchURLComponents.queryItems = [
            URLQueryItem(name: "media", value: "podcast"),
            URLQueryItem(name: "term", value: term),
        ];

        guard let searchUrl = searchURLComponents.url else { return [] }

        guard let (data, _) = try? await URLSession.shared.data(from: searchUrl) else {
            return nil;
        }

        return PodcastData.fromItunesResponse(data) ?? [];
    }
}
