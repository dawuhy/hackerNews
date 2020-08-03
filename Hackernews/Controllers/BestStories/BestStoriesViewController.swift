//
//  ViewController.swift
//  Hackernews
//
//  Created by nhn on 7/14/20.
//  Copyright © 2020 nhn. All rights reserved.
//

import UIKit
import Moya

class BestStoriesViewController: UIViewController, UITableViewDelegate {
 
    var from = 0, to = 19
    var storiesDataSource: StoriestDataSource?
    @IBOutlet weak var tableView: UITableView!
    let storyIdProvider = MoyaProvider<StoryIdAPI>()
    let storyProvider = MoyaProvider<StoryAPI>()
    var didReadId = [Int]()
    
    var listId = [Int]() {
        didSet {
            //  MARK: Fetch top story
            self.fetchStories(from: &self.from, to: &self.to)
        }
    }
    
    var listStory = [Story]() {
        didSet {
            storiesDataSource?.updateData(listStory: self.listStory, didReadId: didReadId)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.showSpinner()
        tableView.backgroundColor = myBackgroundColor
        tableView.delegate = self
        storiesDataSource = StoriestDataSource(with: tableView, stories: [])
        tableView.dataSource = storiesDataSource
                
        // Moya
        storyIdProvider.request(.getId(storyType: "beststories")) { (result) in
            switch result {
            case .success(let response):
                self.listId = try! JSONDecoder().decode([Int].self, from: response.data)
//                self.fetchStories(from: &self.from, to: &self.to)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if tableView.contentOffset.y >= (tableView.contentSize.height - tableView.frame.size.height) {
            fetchStories(from: &from, to: &to)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let story = listStory[indexPath.row]
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ReadStoryViewController") as! ReadStoryViewController
        vc.urlString = story.url
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func fetchStories( from:inout Int, to:inout Int) {
        
        if from > listId.count - 1 {
            return
        }
        if to > listId.count-1 {
            to = listId.count-1
        }
        
//        let storyService = StoryService()
        for i in from...to {
            // Moya
            storyProvider.request(.getStory(id: self.listId[i])) { (result) in
                switch result {
                case .success(let res):
                    do {
                        let story = try JSONDecoder().decode(Story.self, from: res.data)
                        self.listStory.append(story)
                    } catch {
                        print("Can not process data")
                    }
                case .failure(let error):
                    print(error)
                }
            }
            
        }
        from += 20
        to += 20
        self.removeSpinner()
    }
}
