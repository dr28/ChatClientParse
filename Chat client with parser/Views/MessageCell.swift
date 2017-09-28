//
//  MessageCell.swift
//  Chat client with parser
//
//  Created by Deepthy on 9/27/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var message: Message! {
        didSet {
            messageLabel.text = message?.text
            if let user = try! message?.user?.fetchIfNeeded() {
                usernameLabel.text = user.username
                usernameLabel.isHidden = false
            } else {
                usernameLabel.isHidden = true
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
