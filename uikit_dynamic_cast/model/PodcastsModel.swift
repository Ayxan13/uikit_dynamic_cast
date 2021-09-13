import Foundation;
import Combine;
import FeedKit;

class PodcastsModel {
    private init() {
        /* all functions are static */
    }

    private static let urlComponents = URLComponents(string: "https://itunes.apple.com/")!;

    public static func search(for term: String,
                              then completionHandler: @escaping ([ItunesPodcastItem]?) -> Void) {

        var searchURLComponents = urlComponents;
        searchURLComponents.path = "/search";
        searchURLComponents.queryItems = [
            URLQueryItem(name: "media", value: "podcast"),
            URLQueryItem(name: "term", value: term),
        ];

        guard let searchUrl = searchURLComponents.url else {
            return;
        }

        URLSession.shared.dataTask(with: searchUrl) { data, response, error in
            var results: [ItunesPodcastItem]? = nil;

            if let data = data, error == nil {
                results = ItunesPodcastItem.fromItunesResponse(data);
            }

            completionHandler(results);
        }.resume();
    }


    public static func loadAllEpisodes(
            for podcast: ItunesPodcastItem,
            then completionHandler: @escaping ([RSSFeedItem]?) -> Void) {

        let parser = FeedParser(URL: podcast.feedUrl);
        parser.parseAsync { result in
            switch result {
            case .success(let feed):
                completionHandler(feed.rssFeed?.items)

            case .failure:
                completionHandler(nil);
            }
        }
    }
}