import Foundation

class PodcastsModel {

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

    public static func search(for term: String) {
        PodcastsModel.sendRequest(
                url: "https://itunes.apple.com/search",
                parameters: ["media": "podcast", "term": term],
                completion: { result, error in
                    if let error = error {
                        print(error);
                        return;
                    }

                    if let result = result {
                        print(String(data: result, encoding: .utf8) ?? "nil");
                        return;
                    }
                });
    }
}
