//
//  WinRate.swift
//  N5mok
//
//  Created by hyeoktae kwon on 24/05/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

class WinRate: UIView {
    
    var winCount = 0 {
        willSet(newValue) {
            winLabel.text = "승: \(newValue)"
        }
    }
    var loseCount = 0 {
        willSet(newValue) {
            loseLabel.text = "패: \(newValue)"
        }
    }
    
    let rateLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "전적"
        l.textColor = .blue
        l.font = l.font.withSize(40)
        return l
    }()
    
    let winLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .blue
        l.font = l.font.withSize(30)
        return l
    }()
    
    let loseLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .blue
        l.font = l.font.withSize(30)
        return l
    }()
    
    
    init(frame: CGRect, player: String) {
        super.init(frame: frame)
        takeRateCount(player)
        self.addSubview(rateLabel)
        self.addSubview(winLabel)
        self.addSubview(loseLabel)
        autoLayout()
    }
    
    func takeRateCount(_ player: String) {
        dbRef.child("Users").child(player).child("winCount").observeSingleEvent(of: .value) { (snap) in
            self.winCount = (snap.value as! Int)
        }
        dbRef.child("Users").child(player).child("loseCount").observeSingleEvent(of: .value) { (snap) in
            self.loseCount = (snap.value as! Int)
        }
    }
    
    func autoLayout() {
        rateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        rateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2).isActive = true
        
        winLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
        winLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        
        loseLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2).isActive = true
        loseLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
