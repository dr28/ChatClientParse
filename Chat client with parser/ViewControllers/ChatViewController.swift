//
//  ChatViewController.swift
//  Chat client with parser
//
//  Created by Deepthy on 9/27/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
import Parse
import ParseLiveQuery

class ChatViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var messageText: UITextField!
    
    private var client : ParseLiveQuery.Client!
    private var subscription : Subscription<Message>!
    fileprivate var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.dataSource = self
        tableview.delegate = self
        
        tableview.estimatedRowHeight = 100
        tableview.rowHeight = UITableViewAutomaticDimension
        loadData()
    }

    private func loadData() {
        var messageQuery: PFQuery<Message> {
            return (Message.query()!
                .whereKeyExists("text")
                .includeKey("user")
                .order(byAscending: "createdAt")) as! PFQuery<Message>
        }
        client = ParseLiveQuery.Client()
        subscription = client.subscribe(messageQuery)
            // handle creation events, we can also listen for update, leave, enter events
            .handle(Event.created) { _, message in
                self.messages.append(message)
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
        }
    }
    
    @IBAction func saveChat(_ sender: Any) {

        let message = Message()
        message.text = messageText.text
        message.user = PFUser.current()
        message.saveInBackground(block: { (success, error) in
            if (success) {
                print("Message successfully saved!")
                self.loadData()
            } else {
                print("Error saving message!")
            }
        })
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        cell.message = messages[indexPath.row]

        return cell
    }
}
