//
//  ChatViewController.swift
//  Pupple
//
//  Created by Mandy Yu on 5/3/22.
//

import UIKit
import MessageKit
import Parse
import ParseLiveQuery
import InputBarAccessoryView


class ChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {

    var dbmessages: [PFObject]? // messages loaded from conversation in backend
    var messages: [MessageType] = [] // messages displayed on the view
    
    var client : ParseLiveQuery.Client! = ParseLiveQuery.Client(
        server: "wss://pupple.b4a.io",
        applicationId: "clpV4Le8dJjBH8rLyFrm1cLtYuryYMk8X4a2PgkX",
        clientKey: "97ncMs0mvpNIyjyTxvMHc7G8oK9HTHlKBt4pFvPU"
    )
    
    var conversation: PFObject?
    var subscription: Subscription<PFObject>!
    
    var user : PFUser = PFUser.current()!
    var matchdog : PFObject? // dog of the matched user passed in from RecentMatchViewController
    
//    private(set) lazy var refreshControl: UIRefreshControl = {
//        let control = UIRefreshControl()
//        control.addTarget(self, action: #selector(loadMoreMessages), for: .valueChanged)
//        return control
//    }()
    
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false) // Hide the original back button because it doesn't dismiss/pop properly
        self.tabBarController?.tabBar.isHidden = true
        backButton()
        
        configureMessageCollectionView()
        configureMessageInputBar()
    
        self.getConversation { data in
            self.conversation = data!
            self.dbmessages = (self.conversation!["messages"] as! [PFObject])

            self.messages = []

            for msg in self.dbmessages! {
                let sender = msg["sender"] as! PFUser // user that sent the message
                let other = self.matchdog!["ownerid"] as! PFUser // matched user
                let otherUser = PFQuery(className: "_User") // query to get matched user's photo data
                // Check whether the sender of the message is the current user or the matched user
                if(sender.objectId! == self.user.objectId!)
                {
                    self.messages.append(Message(text: msg["content"] as! String, user: User(senderId: self.user.objectId!, displayName: self.user["firstname"] as! String), messageId: msg.objectId!, date: msg.createdAt!))
                }
                else if(sender.objectId! == other.objectId!)
                {
                    self.messages.append(Message(text: msg["content"] as! String, user: User(senderId: other.objectId!, displayName: "Match"), messageId: msg.objectId!, date: msg.createdAt!))
                }
                
            }
            
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem(animated: true)
            }
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let q = PFQuery(className: "Message")
        q.includeKeys(["content", "sender", "recipient"])

        subscription = client.subscribe(q)
                            // handle creation events, we can also listen for update, leave, enter events
                             .handle(Event.created) { _, msg in
                                 print("Something was created!!! \(msg)")


                                 let other = (self.matchdog!["ownerid"] as! PFUser).objectId
                                 let sender = (msg["sender"] as! PFUser).objectId
                                 let recipient = (msg["recipient"] as! PFUser).objectId
                                 let content = msg["content"] as! String
                                 
                                 if (sender == self.user.objectId && recipient == other) || (sender == other && recipient == self.user.objectId) {
                                     self.messages.append(Message(text: content, user: User(senderId: self.user.objectId!, displayName: self.user["firstname"] as! String), messageId: msg.objectId!, date: msg.createdAt!))
                                 }
                                 

                                 DispatchQueue.main.async {
                                     self.messagesCollectionView.reloadData()
                                     self.messagesCollectionView.scrollToLastItem(animated: true)
                                 }

                             }// end of handle event
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let query = PFQuery(className: "Message")
        query.includeKeys(["content", "sender"])
        
        /// DISCONNECT LIVE QUERY HERE
        client.unsubscribe(query)
    }

    func getConversation(completion : @escaping ( _ data : PFObject? ) -> ()) {
        let users = [self.matchdog!["ownerid"], user]
        
    
        let query = PFQuery(className: "Conversation")
        query.whereKey("users", containsAllObjectsIn: users as [Any])
        query.includeKeys(["messages"])
        query.getFirstObjectInBackground { convo, error in
            if let error = error {
                if(error.localizedDescription == "No results matched the query.") {
                    let newConversation = PFObject(className: "Conversation")
                    newConversation["users"] = users
                    newConversation["messages"] = []
                    newConversation.saveInBackground()

                    completion(newConversation)
                    
                } else { print(error) } //Error other than no conversation matching query

            } else if let convo = convo {
                
                completion(convo)

            } // end of let convo = convo
        }
    }
    

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func loadMoreMessages() {
        // get more messages?
    }

    
    func configureMessageCollectionView() {
        messagesCollectionView.messagesDataSource = self
        
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        
        showMessageTimestampOnSwipeLeft = true
        
//        messagesCollectionView.refreshControl = refreshControl
    }
    
    func configureMessageInputBar() {
        messageInputBar.delegate = self
    }
    
    func currentSender() -> SenderType {
        return User(senderId: self.user.objectId!, displayName: self.user["firstname"] as! String)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        //avatarView.isHidden = true //temporary because i cant figure out uiimages for the life of me
        let other = self.matchdog!["ownerid"] as! PFUser // matched user
        let otherUser = PFQuery(className: "_User") // query to get matched user's photo data
        
        if user.objectId! == message.sender.senderId
        {
            let userImageFile = user["user_photo"] as! PFFileObject
            userImageFile.getDataInBackground { data, error in
                if let data = data
                {
                    avatarView.set(avatar: Avatar(image: UIImage(data: data), initials: ""))
                }
            }
            
        }
        else if message.sender.senderId == other.objectId!
        {
            otherUser.getObjectInBackground(withId: other.objectId!) { matchUser, error in
                if let matchUser = matchUser
                {
                    let matchedUserImageFile = matchUser["user_photo"] as! PFFileObject
                    matchedUserImageFile.getDataInBackground { data, error in
                        if let data = data
                        {
                            avatarView.set(avatar: Avatar(image: UIImage(data: data), initials: ""))
                        }
                    }
                }
            }
            
        }

    }  // end of configure Avatar
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        if message.sender.senderId == user.objectId
        {
            return UIColor(red: 196/255, green: 164/255, blue: 132/255, alpha: 1)
        }
        return UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1)
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        if message.sender.senderId == user.objectId
        {
          return MessageStyle.bubbleTail(.bottomRight, .curved)
        }
        return MessageStyle.bubbleTail(.bottomLeft, .curved)
    }
    
}

extension ChatViewController {
    // Back button
    
    func backButton(){
        let back = UIBarButtonItem(image: UIImage(named: "BackButton"), style: .done, target: nil, action: #selector(returnBack))
        navigationItem.setLeftBarButton(back, animated: false)
    }
    
    @objc func returnBack() {
        self.dismiss(animated: false, completion: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabbarVC = storyboard.instantiateViewController(withIdentifier: "HomeTabBarController") as! UITabBarController
            tabbarVC.selectedIndex = 2
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else {return}
            delegate.window?.rootViewController = tabbarVC
            delegate.window?.makeKeyAndVisible()
            self.navigationController?.popToRootViewController(animated: true)
        })
    }
}


extension ChatViewController: InputBarAccessoryViewDelegate {

    @objc
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        inputBar.sendButton.startAnimating()
        inputBar.inputTextView.placeholder = "Sending..."
        
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty else { return }
        
        let msg = PFObject(className: "Message")
        
        msg["content"] = text
        msg["sender"] = self.user
        msg["conversation"] = self.conversation
        msg["recipient"] = self.matchdog!["ownerid"]

//        self.conversation?.add(msg, forKey: "messages")
//        self.conversation?.saveInBackground(block: { success, error in
//            if let error = error { print("There was an error saving convo:", error)}
//        })
        print("Attempted to save:", msg)
        msg.saveInBackground { success, error in
            if let error = error { print("There was an error saving message:", error)}
            else if success {
                print("I reached this point")
                self.conversation?.add(msg, forKey: "messages")
                print("Convo:", self.conversation)
                self.conversation?.saveInBackground{ success, error in
                    if let error = error { print("There was an error saving convo:", error)}
                    if success {
                        print("I saved the conversation")
                    }
                }
            }
        }
        
        
        
        inputBar.sendButton.stopAnimating()
        inputBar.inputTextView.placeholder = "Aa"
        inputBar.inputTextView.text = ""
    }
//
//    func processInputBar(_ inputBar: InputBarAccessoryView) {
//        // Here we can parse for which substrings were autocompleted
//        let attributedText = inputBar.inputTextView.attributedText!
//        let range = NSRange(location: 0, length: attributedText.length)
////        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in
//
////            let substring = attributedText.attributedSubstring(from: range)
////            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
////            print("Autocompleted: `", substring, "` with context: ", context ?? [])
////        }
//
//        let components = inputBar.inputTextView.components
//        inputBar.inputTextView.text = String()
//        inputBar.invalidatePlugins()
//        // Send button activity animation
//        inputBar.sendButton.startAnimating()
//        inputBar.inputTextView.placeholder = "Sending..."
//        // Resign first responder for iPad split view
//        inputBar.inputTextView.resignFirstResponder()
//        DispatchQueue.global(qos: .default).async {
//            // fake send request task
//            sleep(1)
//            DispatchQueue.main.async { [weak self] in
//                inputBar.sendButton.stopAnimating()
//                inputBar.inputTextView.placeholder = "Aa"
//                self?.insertMessages(components)
//                self?.messagesCollectionView.scrollToLastItem(animated: true)
//            }
//        }
//    }
//
//
//    private func insertMessages(_ data: [Any]) {
//        //insert message!
//
//
//    } //end of insert messages
}

