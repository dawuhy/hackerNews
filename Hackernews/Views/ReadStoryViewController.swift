//
//  ReadStoryViewController.swift
//  Hackernews
//
//  Created by Huy on 7/23/20.
//  Copyright © 2020 nhn. All rights reserved.
//

import UIKit
import WebKit

class ReadStoryViewController: UIViewController {

    var urlString:String!
    @IBOutlet weak var storyWebView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: urlString)!
        storyWebView.load(URLRequest(url: url))
    }
}
