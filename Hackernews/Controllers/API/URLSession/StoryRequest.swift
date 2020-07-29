//
//  NewsRequest.swift
//  Hackernews
//
//  Created by nhn on 7/14/20.
//  Copyright © 2020 nhn. All rights reserved.
//

import Foundation

enum StoryError:Error {
    case noDataAvaible
    case canNotProcessData
}



class StoryRequest {
    var resourceURL:URL
    init(id: Int) {
        guard let url = URL(string: "\(baseUrl)/\(version)/item/\(id).json") else { fatalError() }
        self.resourceURL = url
    }
    
    func getStory(completion: @escaping(Result<Story, StoryError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvaible))
                return
            }
            do {
                let storyResponse = try JSONDecoder().decode(Story.self, from: jsonData)
                completion(.success(storyResponse))
            }
            catch {
                completion(.failure(.canNotProcessData))
            }
        }
        dataTask.resume()
    }
}
