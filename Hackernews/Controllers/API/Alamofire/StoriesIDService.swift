//
//  StoriesIDService.swift
//  Hackernews
//
//  Created by Huy on 7/21/20.
//  Copyright © 2020 nhn. All rights reserved.
//

import Foundation
import Alamofire

class StoriesIDServices {
    var url = ""
    typealias listIDCallBack = (_ listID:[Int]?, _ status:Bool, _ message:String) -> Void
    var callBack:listIDCallBack?
    
    init() {
        self.url = "\(baseUrl)/\(version)"
    }
    
    func getlistID(typeStories:String) {
        AF.request("\(self.url)/\(typeStories).json", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil, requestModifier: nil).response { (responseData) in
            guard let data = responseData.data else {return}
            do {
                let listID = try JSONDecoder().decode([Int].self, from: data)
                self.callBack?(listID, true, "Fetch success")
            } catch {
                self.callBack?(nil, false, error.localizedDescription)
            }
        }
    }
    
    func completionHandler(callBack: @escaping listIDCallBack) {
        self.callBack = callBack
    }
}
