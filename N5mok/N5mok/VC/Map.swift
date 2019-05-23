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
    func winner(_ who: Bool)
    func draw()
}

class Map: UIView {
    
    var me: String = ""
    var vs: String = ""
    var text: String = ""
    
    var changedX = 0
    var changedY = 0
    
    var delegate: ChangePlayerDelegate?
    
    var maps = [UILabel]()
    var btns = [UIButton]()
    var turn = false
    
    init(x: CGFloat, y: CGFloat, scale: CGFloat) {
        super.init(frame: CGRect(x: x, y: y, width: scale, height: scale))
        text = "\(vs)vs\(me)"
        makeMap()
        makebtn()
        maps.forEach{ self.addSubview($0) }
        btns.forEach{ self.addSubview($0) }
        
        
        print("*&*&*&*&*&*text: ", vs, me)
        dbRef.child("game").child("map").setValue([text: binaryMap])
        
        
        observeMap()
    }
    
    //    func resetMap() {
    //        db.collection("omok").document("concave").setv
    //    }
    
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
                
                //
                let x = Int((sender.titleLabel?.text!.components(separatedBy: ",")[0])!)
                let y = Int((sender.titleLabel?.text!.components(separatedBy: ",")[1])!)
                saveStones(x: x!, y: y!, player: turn, text: text)
                
                delegate?.changePlayer(turn)
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
                            btn.backgroundColor = self.turn ? .black : .white
                            btn.alpha = 1
                            btn.isEnabled = false
                        }
                    }
                }
                binaryMap = data
                firebaseData = data
                checkStones()
                self.turn.toggle()
            }
            var count = 0
            for i in 0...10 {
                count += binaryMap[i].filter{$0 == 0}.count
                print(binaryMap[i])
                print("count: \(count)")
            }
            if count < 5  {
                self.btns.forEach{ $0.isEnabled = false }
                self.delegate?.draw()
                return }
            
            if gameOver {
                self.btns.forEach{ $0.isEnabled = false }
                self.delegate?.winner(winner)
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
        turn = false
        winner = false
        gameOver = false
        delegate?.changePlayer(turn)
        dbRef.child("game").child("map").setValue([text: firstMap])
    }
}
