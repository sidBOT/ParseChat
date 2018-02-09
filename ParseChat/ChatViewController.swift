//
//  ChatViewController.swift
//  ParseChat
//
//  Created by siddhant on 2/8/18.
//  Copyright © 2018 siddhant. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var messageField: UITextField!
    var refreshControl: UIRefreshControl!
    @IBOutlet weak var tableView: UITableView!
    var myMessages: [PFObject] = []
    let chatMessage = PFObject(className: "Message")
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        tableView.dataSource = self
        tableView.delegate = self
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ChatViewController.didPullToRefresh(_:)), for: .valueChanged)
        
        tableView.insertSubview(refreshControl, at: 0)
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
    }

    func onTimer() {
        let query = PFQuery(className:"Message")
        query.order(byDescending: "createdAt")
        
        query.findObjectsInBackground(){
            (objects: [PFObject]?, error: Error?) -> Void in
            
            if error == nil {
                // Do something with the found objects
                if let objects = objects {
                    self.myMessages = objects
                }
            } else {
                // Log details of the failure
                print(error?.localizedDescription)
            }
            
        }
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl){
        onTimer()
    }
    
    @IBAction func sendAction(_ sender: Any) {
        let chatMessage = PFObject(className: "Message")
        chatMessage["username"] = PFUser.current()!.username
        chatMessage["text"] = messageField.text ?? ""
        
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
                
                self.messageField.text! = ""
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myMessages.count
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = myMessages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        
        cell.messageLabel.text = message["text"] as! String!
        
        cell.userLabel.text = message["username"] as! String!
        
        
        return cell
    }

}
