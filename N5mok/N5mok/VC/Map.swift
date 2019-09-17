//
//  Map.swift
//  N5mok
//
//  Created by hyeoktae kwon on 23/05/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import Firebase

protocol ChangePlayerDelegate {
    func changePlayer(_ state: Bool)
}

class Map: UIView {
    
    let notiCenter = NotificationCenter.default
    
    var me: String = playerID
    var vs: String = playerVS
    var text: String = ""
    
    var changedX = 0
    var changedY = 0
    
    var delegate: ChangePlayerDelegate?
    
    var maps = [UILabel]()
    var btns = [UIButton]()
    var turn = false
    
    
    init(x: CGFloat, y: CGFloat, scale: CGFloat) {
        super.init(frame: CGRect(x: x, y: y, width: scale, height: scale))
        notiCenter.addObserver(self, selector: #selector(takeTurn(_:)), name: Notification.Name("SendTurn2"), object: nil)
        
        text = amIChallenger ? "\(playerID)vs\(playerVS)" : "\(playerVS)vs\(playerID)"
        
        makeMap()
        makebtn()
        maps.forEach{ self.addSubview($0) }
        btns.forEach{ self.addSubview($0) }
        resultBtn.addTarget(self, action: #selector(gameEnd(_:)), for: .touchUpInside)
        self.addSubview(resultBtn)
        
        dbRef.child("game").child("map").updateChildValues([text: firstMap])
        
        observeMap()
    }
    
    @objc func takeTurn(_ sender: Notification) {
        guard let userInfo = sender.userInfo as? [String:Bool] else { return }
        turn = userInfo["turn"]!
        print("@@@@@ Map turn: ", turn)
    }
    
    @objc func gameEnd(_ sender: UIButton) {
        print("gameOver")
        resetBtn()
        let name = Notification.Name("GameOverNoti")
        let noti = Notification(name: name)
        notiCenter.post(noti)
    }
    
    func makeMap() {
        let width = self.frame.width/12
        for i in 0...11{
            for j in 0...11 {
                let label: UILabel = {
                    let l = UILabel(frame: CGRect(x: width * CGFloat(i), y: width * CGFloat(j), width: width, height: width))
                    l.layer.borderWidth = 0.5
                    return l
                }()
                maps.append(label)
            }
        }
    }
    
    func makebtn() {
        let width = self.frame.width/12
        var tag = 1
        for i in 0...10{
            for j in 0...10{
                let btn: UIButton = {
                    let btn = UIButton(frame: CGRect(x: width * CGFloat(j) + width/1.5, y: width * CGFloat(i) + width/1.5, width: width/1.5, height: width/1.5))
                    btn.layer.borderWidth = 0.5
                    btn.layer.cornerRadius = width/3
                    btn.backgroundColor = .white
                    btn.tag = tag
                    btn.alpha = 0.1
                    btn.addTarget(self, action: #selector(didTapBtns(_:)), for: .touchUpInside)
                    btn.setTitle("\(i),\(j)", for: .normal)
                    btn.titleLabel?.font = btn.titleLabel?.font.withSize(0.01)
                    return btn
                }()
                btns.append(btn)
                tag += 1
            }
        }
    }
    
    @objc func didTapBtns(_ sender: UIButton) {
        
        for i in 1...121 {
            switch sender.tag {
            case i:
                let x = Int((sender.titleLabel?.text!.components(separatedBy: ",")[0])!)
                let y = Int((sender.titleLabel?.text!.components(separatedBy: ",")[1])!)
                
                saveStones(x: x!, y: y!, player: turn, text: text)
                
                sender.setTitle("", for: .normal)
            default:
                break
            }
        }
    }
    
    func observeMap() {
        dbRef.child("game").child("map").child(text).observe(.value) { (snapshot) in
            if let data = snapshot.value as? [[Int]] {
                for x in 0...10 {
                    for y in 0...10 {
                        if data[x][y] != binaryMap[x][y] {
                            
                            let btn: UIButton =  self.btns.filter{$0.titleLabel?.text == "\(x),\(y)"}[0]
                            
                            if data[x][y] == 1 {
                                btn.backgroundColor = .black
                            } else if data[x][y] == 2 {
                                btn.backgroundColor = .white
                            }
                            btn.alpha = 1
                            btn.isEnabled = false
                        }
                    }
                }
                binaryMap = data
                firebaseData = data
                amIChallenger.toggle()
                checkStones()
            }
            var count = 0
            for i in 0...10 {
                count += binaryMap[i].filter{$0 == 0}.count
            }
            if count < 5  {
                self.btns.forEach{ $0.isEnabled = false }
                resultBtn.setImage(UIImage(named: "draw"), for: .normal)
                resultBtn.setImage(UIImage(named: "drawSelected"), for: .selected)
                resultBtn.isEnabled = true
                resultBtn.isHidden = false
                self.bringSubviewToFront(resultBtn)
                return }
            
            // MARK: - need edit
            if gameOver {
                if winner {
                    resultBtn.setImage(UIImage(named: "win"), for: .normal)
                    resultBtn.setImage(UIImage(named: "winSelected"), for: .selected)
                    dbRef.child("Users").child(playerID).child("winCount").observeSingleEvent(of: .value) { (snap) in
                        if (snap.value as? Int) != nil {
                            let winCount = (snap.value as! Int) + 1
                            dbRef.child("Users").child(playerID).updateChildValues(["winCount":winCount])
                        }
                    }
                } else if !winner {
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
                self.bringSubviewToFront(resultBtn)
            }
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension Map: ResetDelegate{
    func resetBtn() {
        btns.forEach{ $0.alpha = 0.1; $0.isEnabled = true; $0.backgroundColor = .white }
        winner = false
        gameOver = false
        binaryMap = firstMap
        firebaseData = firstMap
        resultBtn.isEnabled = false
        resultBtn.isHidden = true
        dbRef.child("game").child("map").updateChildValues([text: firstMap])
        dbRef.child("Users").child(playerID).updateChildValues(["vs":""])
        dbRef.child("Users").child(playerVS).updateChildValues(["vs":""])
    }
}


extension Map {
    static var sendTurn: Notification.Name {
        return Notification.Name("SendTurn2")
    }
    static var gameOverNoti: Notification.Name {
        return Notification.Name("GameOverNoti")
    }
}
