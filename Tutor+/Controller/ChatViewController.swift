//
//  ViewController.swift
//  Chat
//
//  Created by Bo Lan  on 11/28/18.
//  Copyright © 2018 Bo_Lan_try. All rights reserved.
//

import UIKit
import JSQMessagesViewController
class ChatViewController: JSQMessagesViewController, listenerUpdateProtocol {
    

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

        initializeInfo()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(app))
        tapGesture.numberOfTapsRequired = 1
        
        navigationController?.navigationBar.addGestureRecognizer(tapGesture)
        
        inputToolbar.contentView.leftBarButtonItem = nil
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        // keyboard
        self.hideKeyboardWhenTappedAround()
    }
    
    @objc func app(){
        
    }
    func contentUpdate() {
        if let messageList = FirebaseUser.shared.getMessageList(targetId: chatterId){
            messages = messageList
            collectionView.reloadData()
        }
    }
    
    private func initializeInfo(){
        if let info = FirebaseUser.shared.contactList[chatterId]{
            senderId = FirebaseUser.shared.id
            senderDisplayName = FirebaseUser.shared.name
            chatterInfo = info
            // add a listener for this channel
            FirebaseUser.shared.addChannelListenerAndCache(targetId: chatterId, targetName: info.name ?? "anonymous", updateDelegate: self)
            // try to delete unread message notification
            FirebaseUser.shared.tryToDeleteUnreadMessage(targetId: chatterId)
            contentUpdate()
            
            title = "Chat with \(info.name ?? "")"
        }else{
            AlertHelper.showAlert(fromController: self, message: "Detect an error with your chatter's identity. Please try again", buttonTitle: "Error")
            self.performSegue(withIdentifier: "ChattingToTab", sender: self)
        }
        
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
        FirebaseUser.shared.sendMessage(targetId: chatterId, message: text)
        finishSendingMessage()
    }
  
}
