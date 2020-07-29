//
//  StoryService.swift
//  Hackernews
//
//  Created by Huy on 7/21/20.
//  Copyright © 2020 nhn. All rights reserved.
//

import Foundation
import Alamofire

class StoryService {
    private var url = ""
    typealias storiesCallBack = (_ story:Story?, _ status:Bool, _ message:String) -> Void
    var callBack:storiesCallBack?
    
    init() {
        self.url = "\(baseUrl)/\(version)/item"
    }
    
    func getStoryFromId(id: Int) {
        AF.request("\(self.url)/\(id).json", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil, requestModifier: nil)
            .response { (responseData) in
                guard let data = responseData.data else {return}
                do {
                    let story = try JSONDecoder().decode(Story.self, from: data)
                    self.callBack?(story, true, "Fetch success")
                } catch {
                    self.callBack?(nil, false, error.localizedDescription)
                    print("Can not process data")
                }
        }
    }
    
    func completionHandler(callBack: @escaping storiesCallBack) {
        self.callBack = callBack
    }
}
