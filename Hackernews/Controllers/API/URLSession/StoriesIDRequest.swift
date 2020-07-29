//
//  Request_ID_TopStories.swift
//  Hackernews
//
//  Created by nhn on 7/16/20.
//  Copyright © 2020 nhn. All rights reserved.
//

import Foundation

class IdRequest {
    let resourceURL:URL
    init(typeStories: String) {
        guard let url = URL(string: "\(baseUrl)/\(version)/\(typeStories).json") else { fatalError() }
        self.resourceURL = url
    }
    
    func getIdStories(completion: @escaping(Result<[Int], StoryError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvaible))
                return
            }
            do {
                let decoder = JSONDecoder()
                let topStoriesId = try decoder.decode([Int].self, from: jsonData)
                completion(.success(topStoriesId))
            }
            catch {
                completion(.failure(.canNotProcessData))
            }
        }
        dataTask.resume()
    }
}
