//
//  StoryAPI.swift
//  Hackernews
//
//  Created by Huy on 7/24/20.
//  Copyright © 2020 nhn. All rights reserved.
//

import Foundation
import Moya

enum StoryAPI {
    case getStory(id: Int)
}

extension StoryAPI:TargetType {
    var baseURL: URL {
        return URL(string: baseUrl)!
    }
    
    var path: String {
        switch self {
        case .getStory(let id):
            return "/\(version)/item/\(id).json"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getStory(_):
            return .get
        }
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .getStory(_):
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Typer": "application/json"]
    }
}
