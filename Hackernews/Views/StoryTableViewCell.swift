    //
//  TableViewCell.swift
//  Hackernews
//
//  Created by nhn on 7/14/20.
//  Copyright © 2020 nhn. All rights reserved.
//

import UIKit

class StoryTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelLink: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(story: Story, didReadId:[Any]) {
        labelTitle.text = story.title
        labelLink.text = story.url
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        labelTime.text = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(story.time)))
        
        // Configure color
        
        backgroundColor = myBackgroundColor
        labelTitle.textColor = myTextColor
        labelTime.textColor = mySubtitleColor
        labelLink.textColor = mySubtitleColor
        
        for id in didReadId {
           if story.id == (id as! Int) {
               backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
           }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        
    }
}
