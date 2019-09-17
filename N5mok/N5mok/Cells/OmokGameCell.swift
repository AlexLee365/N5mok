//
//  OmokGameCell.swift
//  N5mok
//
//  Created by Alex Lee on 22/05/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

protocol ResetDelegate {
    func resetBtn()
}

class OmokGameCell: UICollectionViewCell {
    
    let myRate = WinRate(frame: .zero, player: playerID)
    
    let vsRate = WinRate(frame: .zero, player: playerVS)
    
    var delegate: ResetDelegate?
    
    var newChatNumber = 0 {
        didSet {
            scrollBtnbadgeLabel.text = String(newChatNumber)
            
            if newChatNumber == 0 {
                scrollBtnbadgeLabel.isHidden = true
            }
        }
    }
    
    let scrollBtn = UIButton()
    let scrollBtnbadgeLabel = UILabel()
    let scrollBtnDetailLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .white
        dbRef.child("Users").child(playerID).child("turn").observe(.value) { (snap) in
            map.turn = (snap.value as! Bool)
        }
        
        configure()
        
        self.delegate = map
        map.delegate = self
        setAutoLayout()
        
        newChatObserver()
    }
    
    
    func setAutoLayout() {
        contentView.addSubview(scrollBtn)
        contentView.addSubview(myRate)
        contentView.addSubview(vsRate)
        contentView.addSubview(map)
        
        myRate.translatesAutoresizingMaskIntoConstraints = false
        myRate.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30).isActive = true
        myRate.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        myRate.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -2).isActive = true
        myRate.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        vsRate.translatesAutoresizingMaskIntoConstraints = false
        vsRate.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30).isActive = true
        vsRate.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        vsRate.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: 2).isActive = true
        vsRate.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        scrollBtn.translatesAutoresizingMaskIntoConstraints = false
        scrollBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        scrollBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        scrollBtn.bottomAnchor.constraint(equalTo: vsRate.topAnchor, constant: -50).isActive = true
        scrollBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        
        contentView.addSubview(scrollBtnbadgeLabel)
        scrollBtnbadgeLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollBtnbadgeLabel.centerXAnchor.constraint(equalTo: scrollBtn.centerXAnchor, constant: 15).isActive = true
        scrollBtnbadgeLabel.centerYAnchor.constraint(equalTo: scrollBtn.centerYAnchor, constant: -13).isActive = true
        scrollBtnbadgeLabel.widthAnchor.constraint(equalToConstant: 15).isActive = true
        scrollBtnbadgeLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true

        contentView.addSubview(scrollBtnDetailLabel)
        scrollBtnDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollBtnDetailLabel.centerYAnchor.constraint(equalTo: scrollBtn.centerYAnchor, constant: 30).isActive = true
        scrollBtnDetailLabel.centerXAnchor.constraint(equalTo: scrollBtn.centerXAnchor).isActive = true
        
    }
    
    func configure() {
//        scrollBtn.setTitle("채팅하기", for: .normal)
        scrollBtn.setImage(UIImage(named: "chatRoomIcon"), for: .normal)
        
//        scrollBtn.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        scrollBtn.setTitleColor(.white, for: .normal)
        scrollBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
//        scrollBtn.layer.cornerRadius = 20
        
        myRate.layer.borderWidth = 1
        myRate.layer.borderColor = UIColor.lightGray.cgColor
        myRate.layer.cornerRadius = 5
        
        vsRate.layer.borderWidth = 1
        vsRate.layer.borderColor = UIColor.lightGray.cgColor
        vsRate.layer.cornerRadius = 5
        
        scrollBtnbadgeLabel.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        scrollBtnbadgeLabel.text = String(newChatNumber)
        scrollBtnbadgeLabel.textColor = .white
        scrollBtnbadgeLabel.textAlignment = .center
        scrollBtnbadgeLabel.layer.cornerRadius = 7.5
        scrollBtnbadgeLabel.layer.masksToBounds = true
        scrollBtnbadgeLabel.font = UIFont.systemFont(ofSize: 8)
//        scrollBtnbadgeLabel.isHidden = true
        
        scrollBtnDetailLabel.text = "채팅하기"
        scrollBtnDetailLabel.font = UIFont.boldSystemFont(ofSize: 8)
        scrollBtnDetailLabel.textColor = .black
        scrollBtnDetailLabel.textAlignment = .center
    }
    
    func newChatObserver() {
        let messageRoomKey = amIChallenger ? "\(playerID)vs\(playerVS)" : "\(playerVS)vs\(playerID)"
        
        dbRef.child("Chat").child("messages").child("\(messageRoomKey)").observe(.childAdded) { (snapshot) in
            print("🔸🔸🔸 newChatObserver snapshot: ", snapshot)
            self.scrollBtnbadgeLabel.isHidden = false
            self.newChatNumber += 1
            print("🔸🔸🔸 newChatNumbver Changed: ", self.newChatNumber)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}


extension OmokGameCell: ChangePlayerDelegate {
    
    func changePlayer(_ state: Bool) {
        print("turn run")
        dbRef.child("Users").child(playerID).child("turn").observeSingleEvent(of: .value) { (snap) in
            if (snap.value as! Bool) {
                dbRef.child("Users").child(playerID).updateChildValues(["turn":false])
            } else {
                dbRef.child("Users").child(playerID).updateChildValues(["turn":true])
            }
        }
        
        dbRef.child("Users").child(playerVS).child("turn").observeSingleEvent(of: .value) { (snap) in
            if (snap.value as! Bool) {
                dbRef.child("Users").child(playerVS).updateChildValues(["turn":false])
            } else {
                dbRef.child("Users").child(playerVS).updateChildValues(["turn":true])
            }
        }
        
    }
}
