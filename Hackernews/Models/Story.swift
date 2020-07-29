//
//  News.swift
//  Hackernews
//
//  Created by nhn on 7/14/20.
//  Copyright © 2020 nhn. All rights reserved.
//

import Foundation

struct Story:Decodable {
    var id:Int
    var title:String
    var url:String
    var time:Int
}
