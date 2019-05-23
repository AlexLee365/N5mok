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
    
    var delegate: ResetDelegate?
    
    let scrollBtn = UIButton()
    
    let winnerLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = l.font.withSize(50)
        l.layer.borderWidth = 1
        l.textAlignment = .center
        l.isHidden = true
        return l
    }()
    
    let whosTurn: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = l.font.withSize(50)
        l.layer.borderWidth = 1
        l.text = "Player 1"
        l.textAlignment = .center
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .yellow
        setAutoLayout()
        configure()
        self.addSubview(map)
        self.delegate = map
        map.delegate = self
    }
    
    
    func setAutoLayout() {
        contentView.addSubview(scrollBtn)
        scrollBtn.translatesAutoresizingMaskIntoConstraints = false
        scrollBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        scrollBtn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        scrollBtn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50).isActive = true
        scrollBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
    }
    
    func configure() {
        scrollBtn.setTitle("채팅하기", for: .normal)
        scrollBtn.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        scrollBtn.setTitleColor(.white, for: .normal)
        scrollBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        scrollBtn.layer.cornerRadius = 7
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        
    }
    
}


extension OmokGameCell: ChangePlayerDelegate {
    func draw() {
        winnerLabel.isHidden = false
        winnerLabel.text = "무승부"
    }
    
    func winner(_ who: Bool) {
        winnerLabel.isHidden = false
        winnerLabel.text = who ? "흑돌 승!!!" : "백돌 승!!!"
    }
    func changePlayer(_ state: Bool) {
        whosTurn.text = state ? "Player 2" : "Player 1"
    }
}
