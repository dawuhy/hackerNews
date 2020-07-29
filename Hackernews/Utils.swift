//
//  utils.swift
//  Hackernews
//
//  Created by nhn on 7/16/20.
//  Copyright © 2020 nhn. All rights reserved.
//

import UIKit

fileprivate var aView: UIView?

// MARK: -- Configure
// Color
let myBackgroundColor = UIColor(named: "MyBackgroundColor")
let myTextColor = UIColor(named: "MyTextColor")
let mySubtitleColor = UIColor(named: "MySubtitleColor")

// URL API
let baseUrl:String = "https://hacker-news.firebaseio.com"
let version:String = "v0"

var userDefault = UserDefaults.standard

extension UIViewController {
    
    func showSpinner() {
        aView = UIView(frame: self.view.bounds)
        aView?.backgroundColor = myBackgroundColor
        self.view.backgroundColor = myBackgroundColor
        
        let ai = UIActivityIndicatorView(style: .large)
        ai.color = .white
        ai.center = aView!.center
        ai.startAnimating()
        
        aView?.addSubview(ai)
        self.view.addSubview(aView!)
        
        Timer.scheduledTimer(withTimeInterval: 20.0, repeats: false) { (t) in
            self.removeSpinner()
        }
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            aView?.removeFromSuperview()
            aView = nil
        }
    }
}

extension StoriestDataSource {
    func removeSpinner() {
        aView?.removeFromSuperview()
        aView = nil
    }
}

extension UIViewController {
    func setTransparentTabbar() {
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().clipsToBounds = true
    }
}

extension UserDefaults {

    enum Keys: String, CaseIterable {

        case unitsNotation
        case temperatureNotation
        case allowDownloadsOverCellular

    }

    func reset() {
        Keys.allCases.forEach { removeObject(forKey: $0.rawValue) }
    }
}
