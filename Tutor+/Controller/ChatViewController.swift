//
//  ViewController.swift
//  Chat
//
//  Created by 孙可天  on 11/28/18.
//  Copyright © 2018 Bo_Lan_try. All rights reserved.
//

import UIKit
import JSQMessagesViewController
class ChatViewController: JSQMessagesViewController {

    var messages = [JSQMessage]()
    
    var chatterId = ""
    var chatterInfo = FirebaseUser.ProfileStruct()
    
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }()
    
    lazy var incomingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        //senderId = "1234"
        //senderDisplayName = "Biaodiao Lan"
        let defaults = UserDefaults.standard
        initializeInfo()
        if let message = JSQMessage(senderId: "123", displayName: "123", text: "ok"){
            self.messages.append(message)
            self.finishReceivingMessage()
        }
        
//        if  let id = defaults.string(forKey: "jsq_id"),
//            let name = defaults.string(forKey: "jsq_name")
//        {
//            senderId = id
//            senderDisplayName = name
//        }
//        else
//        {
//            senderId = String(arc4random_uniform(999999))
//            senderDisplayName = ""
//
//            defaults.set(senderId, forKey: "jsq_id")
//            defaults.synchronize()
//
//            showDisplayNameDialog()
//        }
//
//        title = "Chat: \(senderDisplayName!)"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDisplayNameDialog))
        tapGesture.numberOfTapsRequired = 1
        
        navigationController?.navigationBar.addGestureRecognizer(tapGesture)
        inputToolbar.contentView.leftBarButtonItem = nil
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        // Do any additional setup after loading the view, typically from a nib.
        
//        let query = Constants.refs.databaseChats.queryLimited(toLast: 10)
//
//        _ = query.observe(.childAdded, with: { [weak self] snapshot in
//
//            if  let data        = snapshot.value as? [String: String],
//                let id          = data["sender_id"],
//                let name        = data["name"],
//                let text        = data["text"],
//                !text.isEmpty
//            {
//                if let message = JSQMessage(senderId: id, displayName: name, text: text)
//                {
//                    self?.messages.append(message)
//
//                    self?.finishReceivingMessage()
//                }
//            }
//        })
    }
    
    private func initializeInfo(){
        if let info = FirebaseUser.shared.contactList[chatterId]{
            senderId = FirebaseUser.shared.id
            senderDisplayName = FirebaseUser.shared.name
            self.chatterInfo = info
            title = "Chat with \(info.name ?? "")"
        }else{
            AlertHelper.showAlert(fromController: self, message: "Detect an error with your chatter's identity. Please try again", buttonTitle: "Error")
            self.performSegue(withIdentifier: "ChattingToTab", sender: self)
        }
        
    }
    
    @objc func showDisplayNameDialog()
    {
        let defaults = UserDefaults.standard
        
        let alert = UIAlertController(title: "Your Display Name", message: "Before you can chat, please choose a display name. Others will see this name when you send chat messages. You can change your display name again by tapping the navigation bar.", preferredStyle: .alert)
        
        alert.addTextField { textField in
            
            if let name = defaults.string(forKey: "jsq_name")
            {
                textField.text = name
            }
            else
            {
                let names = ["Ford", "Arthur", "Zaphod", "Trillian", "Slartibartfast", "Humma Kavula", "Deep Thought"]
                textField.text = names[Int(arc4random_uniform(UInt32(names.count)))]
            }
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self, weak alert] _ in
            
            if let textField = alert?.textFields?[0], !textField.text!.isEmpty {
                
                self?.senderDisplayName = textField.text
                
                self?.title = "Chat: \(self!.senderDisplayName!)"
                
                defaults.set(textField.text, forKey: "jsq_name")
                defaults.synchronize()
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData!
    {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return messages.count
    }
    /////////////////////////////below
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        return messages[indexPath.item].senderId == senderId ? outgoingBubble : incomingBubble
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        return messages[indexPath.item].senderId == senderId ? nil : NSAttributedString(string: messages[indexPath.item].senderDisplayName)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat
    {
        return messages[indexPath.item].senderId == senderId ? 0 : 15
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!)
    {
//        let ref = Constants.refs.databaseChats.childByAutoId()
//
 //       let message = ["sender_id": senderId, "name": senderDisplayName, "text": text]
//
//        ref.setValue(message)
        if let message = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text){
            self.messages.append(message)
            self.finishReceivingMessage()
        }
        FirebaseUser.shared.sendMessage(targetId: chatterId, message: text)
    }
}

