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


    public static func loadFeed(
            for podcast: ItunesPodcastItem,
            then completionHandler: @escaping (RSSFeed?) -> Void) {

        let parser = FeedParser(URL: podcast.feedUrl);
        parser.parseAsync { result in
            switch result {
            case .success(let feed):
                completionHandler(feed.rssFeed)

            case .failure:
                completionHandler(nil);
            }
        }
    }

    public static func loadImage(
            url: URL,
            then completionHandler: @escaping (UIImage?) -> Void) {

        URLSession.shared.dataTask(with: url) { data, response, error in
            var img: UIImage? = nil;

            if let data = data, error == nil {
                img = UIImage(data: data);
            }

            completionHandler(img);
        }.resume();
    }

}