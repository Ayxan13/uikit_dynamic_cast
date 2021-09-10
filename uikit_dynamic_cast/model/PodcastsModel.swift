import Foundation
import Combine

class PodcastsModel {

    private static let urlComponents = URLComponents(string: "https://itunes.apple.com/")!;


    typealias RequestResultHandler = (Data?, Error?) -> Void;

    private static func sendRequest(
            url: String,
            parameters: [String: String],
            completion: @escaping RequestResultHandler) {
        var components = URLComponents(string: url)!
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let request = URLRequest(url: components.url!)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                    let data = data, // is there data
                    let response = response as? HTTPURLResponse, // is there HTTP response
                    200..<300 ~= response.statusCode, // is statusCode 2XX
                    error == nil                                  // was there no error
                    else {
                completion(nil, error)
                return
            }

            completion(data, nil)
        }
        task.resume()
    }

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
}
