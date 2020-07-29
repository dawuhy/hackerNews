//
//  StoryIdAPI.swift
//  Hackernews
//
//  Created by Huy on 7/24/20.
//  Copyright © 2020 nhn. All rights reserved.
//

import Foundation
import Moya

enum StoryIdAPI {
    case getId(storyType:String)
}

extension StoryIdAPI:TargetType {
    var baseURL: URL {
        return URL(string: baseUrl)!
    }
    
    var path: String {
        switch self {
        case .getId(let storyType):
            return "/\(version)/\(storyType).json"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getId(_):
            return .get
        }
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .getId(_):
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Typer": "application/json"]
    }
}
