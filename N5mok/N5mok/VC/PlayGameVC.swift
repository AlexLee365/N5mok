//
//  PlayGameVC.swift
//  N5mok
//
//  Created by Alex Lee on 22/05/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//
import UIKit

class PlayGameVC: UIViewController {
    
    let omokCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var layoutState = true
    
    let timerImageView = UIImageView()
    let timerLabel = UILabel()
    
    let backgroundViewofP1 = UIView()
    let backgroundViewofP2 = UIView()
    
    let imageViewOfP1 = UIImageView()
    let imageViewOfP2 = UIImageView()
    
    let nameLabelOfP1 = UILabel()
    let nameLabelOfP2 = UILabel()
    
    let centerBackgroundView = UIView()
    
    var timer = Timer()
    let limitTime = 61
    lazy var timeValue = limitTime
    
    var viewBottomSafeInset: CGFloat = 0
    
    var imageStringofP1 = ""
    var imageStringofP2 = ""
    
    let text = amIChallenger ? "\(playerID)vs\(playerVS)" : "\(playerVS)vs\(playerID)"
    
    var myTurn = false {
        willSet(new) {
            if new {
                setPlayerTurn(turn: new, who: playerID)
                timeOverLoser = playerID
            } else {
                setPlayerTurn(turn: new, who: playerVS)
                timeOverLoser = playerVS
            }
        }
    }
    
    var timeOverLoser: String = ""
    
    let notiCenter = NotificationCenter.default
    
    var currentTurn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        notiCenter.addObserver(self, selector: #selector(takeTurn(_:)), name: Notification.Name("SendTurn1"), object: nil)
        
        notiCenter.addObserver(self, selector: #selector(goToFindGameVC(_:)), name: Notification.Name("GameOverNoti"), object: nil)
        
        view.backgroundColor = .white
        view.addSubview(omokCollectionView)
        omokCollectionView.frame = view.frame
        omokCollectionView.delegate = self
        omokCollectionView.dataSource = self
        omokCollectionView.backgroundColor = .white
        omokCollectionView.isScrollEnabled = false
        
        omokCollectionView.register(ChatRoomCell.self, forCellWithReuseIdentifier: "chatRoomCell")
        omokCollectionView.register(OmokGameCell.self, forCellWithReuseIdentifier: "omokGameCell")
        
        setAutoLayout()
        configure()
        
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerDispatchQueue(timer:)), userInfo: nil, repeats: true)
    }
    
    @objc func takeTurn(_ sender: Notification) {
        guard let userInfo = sender.userInfo as? [String:Bool] else { return }
        myTurn = userInfo["turn"]!
        print(myTurn)
    }
    
    @objc func goToFindGameVC(_ sender: Notification) {
        dismiss(animated: true)
    }
    
    func setAutoLayout() {
        let safeGuide = view.safeAreaLayoutGuide
        
        view.addSubview(timerImageView)
        timerImageView.translatesAutoresizingMaskIntoConstraints = false
        timerImageView.topAnchor.constraint(equalTo: safeGuide.topAnchor, constant: 35).isActive = true
        //        timerMessageLabel.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 30).isActive = true
        //        timerMessageLabel.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -30).isActive = true
        timerImageView.centerXAnchor.constraint(equalTo: safeGuide.centerXAnchor).isActive = true
        timerImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        timerImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        view.addSubview(timerLabel)
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.topAnchor.constraint(equalTo: safeGuide.topAnchor, constant: 70).isActive = true
        timerLabel.centerXAnchor.constraint(equalTo: safeGuide.centerXAnchor).isActive = true
        timerLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        view.addSubview(backgroundViewofP1)
        backgroundViewofP1.translatesAutoresizingMaskIntoConstraints = false
        backgroundViewofP1.widthAnchor.constraint(equalTo: safeGuide.widthAnchor, multiplier: 0.5).isActive = true
        backgroundViewofP1.heightAnchor.constraint(equalToConstant: 120).isActive = true
        backgroundViewofP1.topAnchor.constraint(equalTo: safeGuide.topAnchor).isActive = true
        backgroundViewofP1.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor).isActive = true
        
        view.addSubview(backgroundViewofP2)
        backgroundViewofP2.translatesAutoresizingMaskIntoConstraints = false
        backgroundViewofP2.widthAnchor.constraint(equalTo: safeGuide.widthAnchor, multiplier: 0.5).isActive = true
        backgroundViewofP2.heightAnchor.constraint(equalToConstant: 120).isActive = true
        backgroundViewofP2.topAnchor.constraint(equalTo: safeGuide.topAnchor).isActive = true
        backgroundViewofP2.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor).isActive = true
        
        view.addSubview(imageViewOfP1)
        imageViewOfP1.translatesAutoresizingMaskIntoConstraints = false
        imageViewOfP1.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 20).isActive = true
        imageViewOfP1.centerYAnchor.constraint(equalTo: backgroundViewofP1.centerYAnchor, constant: -10).isActive = true
        imageViewOfP1.widthAnchor.constraint(equalTo: safeGuide.widthAnchor, multiplier: 0.2).isActive = true
        imageViewOfP1.heightAnchor.constraint(equalTo: imageViewOfP1.widthAnchor, multiplier: 1).isActive = true
        
        view.addSubview(imageViewOfP2)
        imageViewOfP2.translatesAutoresizingMaskIntoConstraints = false
        imageViewOfP2.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -20).isActive = true
        imageViewOfP2.centerYAnchor.constraint(equalTo: backgroundViewofP1.centerYAnchor, constant: -10).isActive = true
        imageViewOfP2.widthAnchor.constraint(equalTo: safeGuide.widthAnchor, multiplier: 0.2).isActive = true
        imageViewOfP2.heightAnchor.constraint(equalTo: imageViewOfP2.widthAnchor, multiplier: 1).isActive = true
        
        view.addSubview(centerBackgroundView)
        centerBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        centerBackgroundView.centerXAnchor.constraint(equalTo: safeGuide.centerXAnchor).isActive = true
        centerBackgroundView.topAnchor.constraint(equalTo: safeGuide.topAnchor).isActive = true
        centerBackgroundView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        centerBackgroundView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        view.addSubview(nameLabelOfP1)
        nameLabelOfP1.translatesAutoresizingMaskIntoConstraints = false
        nameLabelOfP1.topAnchor.constraint(equalTo: imageViewOfP1.bottomAnchor, constant: 5).isActive = true
        nameLabelOfP1.centerXAnchor.constraint(equalTo: imageViewOfP1.centerXAnchor).isActive = true
        
        view.addSubview(nameLabelOfP2)
        nameLabelOfP2.translatesAutoresizingMaskIntoConstraints = false
        nameLabelOfP2.topAnchor.constraint(equalTo: imageViewOfP2.bottomAnchor, constant: 5).isActive = true
        nameLabelOfP2.centerXAnchor.constraint(equalTo: imageViewOfP2.centerXAnchor).isActive = true
        
        view.bringSubviewToFront(backgroundViewofP1)
        view.bringSubviewToFront(backgroundViewofP2)
        
        view.bringSubviewToFront(centerBackgroundView)
        view.bringSubviewToFront(timerLabel)
        view.bringSubviewToFront(timerImageView)
    }
    
    func configure() {
        timerImageView.image = UIImage(named: "timerIcon")
        
        timerLabel.textAlignment = .center
        timerLabel.textColor = .black
        timerLabel.font = UIFont.systemFont(ofSize: 18)
        timerLabel.text = ""
        
        imageViewOfP1.layer.cornerRadius = 30
        imageViewOfP1.layer.masksToBounds = true
        
        
        dbRef.child("Users").child("\(playerID)").child("playerImg").observeSingleEvent(of: .value) { (snapshot) in
            guard let data = snapshot.value as? String else {return}
            //            print("⭐️⭐️⭐️ 데이터가져오기성공 :", snapshot.value)
            self.imageViewOfP1.image = data.toImage()
        }
        
        imageViewOfP2.layer.cornerRadius = 30
        imageViewOfP2.layer.masksToBounds = true
        
        dbRef.child("Users").child("\(playerVS)").child("playerImg").observeSingleEvent(of: .value) { (snapshot) in
            guard let data = snapshot.value as? String else {return}
            //            print("⭐️⭐️⭐️ 데이터가져오기성공 :", snapshot.value)
            self.imageViewOfP2.image = data.toImage()
        }
            
            centerBackgroundView.backgroundColor = .white
            centerBackgroundView.layer.cornerRadius = 40
            centerBackgroundView.layer.masksToBounds = true
            
            //        backgroundViewofP1.backgroundColor = #colorLiteral(red: 0.154732585, green: 0.1633420885, blue: 0.1552935243, alpha: 0.608197774)
            nameLabelOfP1.text = playerID
            nameLabelOfP1.font = UIFont.boldSystemFont(ofSize: 15)
            
            nameLabelOfP2.text = playerVS
            nameLabelOfP2.font = UIFont.boldSystemFont(ofSize: 15)
    }
    
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let safeGuide = view.safeAreaLayoutGuide
        
        if layoutState {
            let layout = omokCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            //            layout.itemSize = omokCollectionView.frame.size
            layout.scrollDirection = .horizontal
            
            omokCollectionView.translatesAutoresizingMaskIntoConstraints = false
            omokCollectionView.topAnchor.constraint(equalTo: safeGuide.topAnchor, constant: 120).isActive = true
            omokCollectionView.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor).isActive = true
            omokCollectionView.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor).isActive = true
            omokCollectionView.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor).isActive = true
            
            viewBottomSafeInset = view.safeAreaInsets.bottom
            
        }
    }
    
    func setPlayerTurn(turn: Bool, who: String) {
//        currentTurn = turn
        
        let standbyColor = #colorLiteral(red: 0.154732585, green: 0.1633420885, blue: 0.1552935243, alpha: 0.608197774)
        let turnColor = UIColor.clear
        
        if who == playerID {
            backgroundViewofP1.backgroundColor = turnColor
            backgroundViewofP2.backgroundColor = standbyColor
        } else {
            backgroundViewofP1.backgroundColor = standbyColor
            backgroundViewofP2.backgroundColor = turnColor
        }
        
       timeValue = limitTime
    }
    
    @objc func timerDispatchQueue(timer: Timer) {
        timeValue -= 1
        let minute = String(timeValue / 60).count == 1 ? "0\(timeValue/60)" : String(timeValue/60)
        let second = String(timeValue % 60).count == 1 ? "0\(timeValue%60)" : String(timeValue%60)

        self.timerLabel.text = "\(minute):\(second)"

        if timeValue == 0 {
            self.timer.invalidate()
            map.resetBtn()
            timeOver()
            print("timeValue = 0")
        }
    }
    
    func timeOver() {
        print("timeOver run")
        map.btns.forEach{ $0.isEnabled = false }
        if timeOverLoser == playerVS {
            resultBtn.setImage(UIImage(named: "win"), for: .normal)
            resultBtn.setImage(UIImage(named: "winSelected"), for: .selected)
            dbRef.child("Users").child(playerID).child("winCount").observeSingleEvent(of: .value) { (snap) in
                if (snap.value as? Int) != nil {
                    let winCount = (snap.value as! Int) + 1
                    dbRef.child("Users").child(playerID).updateChildValues(["winCount":winCount])
                }
            }
        } else if timeOverLoser == playerID {
            resultBtn.setImage(UIImage(named: "lose"), for: .normal)
            resultBtn.setImage(UIImage(named: "loseSelected"), for: .selected)
            dbRef.child("Users").child(playerID).child("loseCount").observeSingleEvent(of: .value) { (snap) in
                if (snap.value as? Int) == nil {
                    let loseCount = (snap.value as! Int) + 1
                    dbRef.child("Users").child(playerID).updateChildValues(["loseCount":loseCount])
                }
            }
        }
        resultBtn.isEnabled = true
        resultBtn.isHidden = false
    }
    
    
    @objc func slideToChatCell(_ sender: UIButton) {
        let indexPath = IndexPath(row: 1, section: 0)
        omokCollectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally], animated: true)
    }
    
    @objc func slideToOmokCell(_ sender: UIButton) {
        let indexPath = IndexPath(row: 0, section: 0)
        omokCollectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally], animated: true)
    }
}

extension PlayGameVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            let omokRoomCell = collectionView.dequeueReusableCell(withReuseIdentifier: "omokGameCell", for: indexPath) as! OmokGameCell
            omokRoomCell.scrollBtn.addTarget(self, action: #selector(slideToChatCell(_:)), for: .touchUpInside)
            self.view.endEditing(true)
            return omokRoomCell
        } else {
            let chatRoomCell = collectionView.dequeueReusableCell(withReuseIdentifier: "chatRoomCell", for: indexPath) as! ChatRoomCell
            chatRoomCell.viewBottomSafeInset = self.viewBottomSafeInset // 전체 뷰의 바텀 세이프인셋을 cell에 알려주기 위함
            
            chatRoomCell.backBtn.addTarget(self, action: #selector(slideToOmokCell(_:)), for: .touchUpInside)
            
            
            return chatRoomCell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? ChatRoomCell {
            print("⭐️⭐️⭐️ willDisplay - ChatRoomCell")
        } else if let cell = cell as? OmokGameCell {
            print("⭐️⭐️⭐️ willDisplay - OmokGameCell")
            cell.newChatNumber = 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? ChatRoomCell {
            cell.inputTextView.resignFirstResponder()
            print("⭐️⭐️⭐️ didEndDisplaying - ChatRoomCell")
        } else if let cell = cell as? OmokGameCell {
            print("⭐️⭐️⭐️ didEndDisplaying - OmokGameCell")
        }
        
    }
}


extension PlayGameVC {
    static var sendTurn: Notification.Name {
        return Notification.Name("SendTurn1")
    }
}


