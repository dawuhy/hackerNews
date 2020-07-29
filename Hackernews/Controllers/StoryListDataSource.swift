import UIKit

class StoriestDataSource: NSObject, UITableViewDataSource {
    // We keep this public and mutable, to enable our data
    // source to be updated as new data comes in.
    
    var tableView:UITableView?
    var listStory = [Story]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
    }

    init(with tableView: inout UITableView) {
        self.tableView = tableView
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listStory.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StoryTableViewCell
        let story = listStory[indexPath.row]
        
        cell.configure(story: story)
        
        return cell
    }
    
    public func updateData(listStory: [Story]) {
        self.listStory = listStory
        tableView?.reloadData()
    }
}
