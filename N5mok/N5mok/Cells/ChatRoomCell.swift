//
//  ChatRoomCell.swift
//  N5mok
//
//  Created by Alex Lee on 22/05/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//
import UIKit
import Firebase

class ChatRoomCell: UICollectionViewCell {
    
    let chatTableView = UITableView()
    
    let containerView = UIView()
    let inputTextView = UITextView()
    let backBtn = UIButton()
    let sendBtn = UIButton()
    let moveDownBtn = UIButton()
    
    var chatMessages = [Message]()
    
    var viewBottomSafeInset: CGFloat = 5
    
    struct chatUI {
        var textFieldSize: CGFloat = 60
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .white
        
        setAutoLayout()
        configure()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveKeyboardNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveKeyboardNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        observeMessages()
        textViewDidChange(inputTextView)
        
        
    }
    
    func setAutoLayout() {
        contentView.addSubview(chatTableView)
        chatTableView.translatesAutoresizingMaskIntoConstraints = false
        chatTableView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        chatTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        chatTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
//        chatTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -60).isActive = true
        
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: chatTableView.bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        let containerViewBottomConstDown = containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        containerViewBottomConstDown.priority = UILayoutPriority(rawValue: 500)
        containerViewBottomConstDown.isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        containerView.addSubview(backBtn)
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        backBtn.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5).isActive = true
        backBtn.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        backBtn.widthAnchor.constraint(equalToConstant: 33).isActive = true
        backBtn.heightAnchor.constraint(equalToConstant: 33).isActive = true
        
        containerView.addSubview(inputTextView)
        inputTextView.translatesAutoresizingMaskIntoConstraints = false
        inputTextView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextView.leadingAnchor.constraint(equalTo: backBtn.trailingAnchor, constant: 5).isActive = true
        inputTextView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        containerView.addSubview(sendBtn)
        sendBtn.translatesAutoresizingMaskIntoConstraints = false
        sendBtn.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5).isActive = true
        sendBtn.leadingAnchor.constraint(equalTo: inputTextView.trailingAnchor, constant: 5).isActive = true
        sendBtn.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendBtn.heightAnchor.constraint(equalToConstant: 35).isActive = true
        sendBtn.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        contentView.addSubview(moveDownBtn)
        moveDownBtn.translatesAutoresizingMaskIntoConstraints = false
        moveDownBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        moveDownBtn.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -3).isActive = true
        moveDownBtn.widthAnchor.constraint(equalToConstant: 32).isActive = true
        moveDownBtn.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }
    
    func configure() {
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "chatCell")
        //        chatTableView.rowHeight = 150
        //        chatTableView.estimatedRowHeight = 80
        //        chatTableView.rowHeight = UITableView.automaticDimension
        chatTableView.separatorStyle = .none
        chatTableView.allowsSelection = false
        chatTableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGestureTableView(_:))))
        
        containerView.backgroundColor = .white
        
        backBtn.setImage(UIImage(named: "backBtnIcon"), for: .normal)
        
        sendBtn.setImage(UIImage(named: "sendBtnIcon"), for: .normal)
        sendBtn.addTarget(self, action: #selector(sendBtnDidTap(_:)), for: .touchUpInside)
        
        inputTextView.layer.cornerRadius = 7
        inputTextView.layer.borderColor = UIColor.lightGray.cgColor
        inputTextView.layer.borderWidth = 0.2
        
        moveDownBtn.setImage(UIImage(named: "moveDownBtn"), for: .normal)
        moveDownBtn.layer.opacity = 0.5
        moveDownBtn.addTarget(self, action: #selector(moveDownBtnDidTap(_:)), for: .touchUpInside)
        contentView.bringSubviewToFront(moveDownBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func tapGestureTableView(_ sender: UITapGestureRecognizer) {
        inputTextView.resignFirstResponder()
    }
    
    @objc func didReceiveKeyboardNotification(_ sender: Notification) {
        guard let userInfo = sender.userInfo
            , let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            , let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
            else { return }
        
        let keyboardHeightWithoutSafeInset = keyboardFrame.height - viewBottomSafeInset

        let containerViewBottomConstUp = containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -keyboardHeightWithoutSafeInset)
        let containerViewBottomConstDown = containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
    
        switch sender.name {
        case UIResponder.keyboardWillShowNotification :
            print("KeyboardWillShow")
            
            UIView.animate(withDuration: duration) {
                containerViewBottomConstDown.priority = .defaultLow
                containerViewBottomConstUp.priority = .defaultHigh
                containerViewBottomConstUp.isActive = true
            }
            self.layoutIfNeeded()
            
            if chatTableView.contentSize.height >= chatTableView.frame.height {
                self.chatTableView.contentOffset.y += keyboardHeightWithoutSafeInset
            }
            
        case UIResponder.keyboardWillHideNotification :
            print("KeyboardWillHide")
            
            UIView.animate(withDuration: duration) {
                containerViewBottomConstUp.priority = .defaultLow
                containerViewBottomConstDown.priority = .defaultHigh
                containerViewBottomConstDown.isActive = true
            }
            
            if chatTableView.contentSize.height >= chatTableView.frame.height {
                self.chatTableView.contentOffset.y -= keyboardHeightWithoutSafeInset
            }
            
            self.layoutIfNeeded()
            
        default : break
        }
    }
    
    func observeMessages() {
        
        let messageRoomKey = amIChallenger ? "\(playerID)vs\(playerVS)" : "\(playerVS)vs\(playerID)"      // 도전자의이름이 앞에오는 동일한 키를 가지기위함
        
        dbRef.child("Chat").child("messages").child("\(messageRoomKey)").observe(.childAdded) { (snapshot) in
            if let dataArray = snapshot.value as? [String: Any] {
                print("🔵🔵🔵 obserMessages DataArray: ", dataArray)
                guard let senderName = dataArray["senderName"] as? String
                    , let messageText = dataArray["text"] as? String
                    else { return }
                
                let message = Message(messageKey: snapshot.key, senderName: senderName, messageText: messageText)
                self.chatMessages.append(message)
                self.chatTableView.reloadData()
                
                self.chatTableView.scrollToRow(at: IndexPath(row: self.chatMessages.count-1, section: 0), at: UITableView.ScrollPosition.bottom, animated: false)
            }
        }
    }
    
    func sendMessage(text: String, completion: @escaping (_ isSuccess: Bool) -> () ) {
        let senderName = playerID
        let dataArray: [String: Any] = ["senderName": senderName, "text": text]
        print("🔸🔸🔸 sendMessage DataArray: ", dataArray)
        
        let messageRoomKey = amIChallenger ? "\(playerID)vs\(playerVS)" : "\(playerVS)vs\(playerID)"
        
        dbRef.child("Chat").child("messages").child("\(messageRoomKey)").childByAutoId().setValue(dataArray) { (error, ref) in
            error == nil ? completion(true) : completion(false)
        }
        
    }
    
    @objc func sendBtnDidTap(_ sender: UIButton) {
        guard let text = inputTextView.text, !text.isEmpty else { return }
        
            sendMessage(text: text, completion: { (isSuccess) in
                if isSuccess {
                    self.inputTextView.text = ""
                    self.textViewDidChange(self.inputTextView)
                } else {
                    print("‼️‼️‼️ sendMessage 메소드 에러")
                }
            })
    }
    
    @objc func moveDownBtnDidTap(_ sender: UIButton) {
        guard chatMessages.count > 0 else { return }
        
        self.chatTableView.scrollToRow(at: IndexPath(row: self.chatMessages.count-1, section: 0), at: UITableView.ScrollPosition.top, animated: true)
    }
    
}
extension ChatRoomCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatTableViewCell
        let message = chatMessages[indexPath.row]
        
        cell.setMessageData(message: message)
        
        message.senderName == playerID ?
            cell.setBubbleType(type: .outgoing) : cell.setBubbleType(type: .incoming)
        
        return cell
    }
    
}

extension ChatRoomCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let lastPageContentOffset = scrollView.contentSize.height - chatTableView.frame.height
        
        scrollView.contentOffset.y < lastPageContentOffset - 50 ?
            (moveDownBtn.isHidden = false) : (moveDownBtn.isHidden = true)
    }
}
