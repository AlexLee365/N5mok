//
//  FindGameVC.swift
//  N5mok
//
//  Created by hyeoktae kwon on 22/05/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

final class FindGameVC: UIViewController {
    
    let myInformBackgroundView = UIView()
    let scoreTitleLabel = UILabel()
    let scoreWinCountLabel = UILabel()
    
    let scoreWinRateLabel = UILabel()
    let userLevelLabel = UILabel()
    
    private var firstMenuContainer: [UIButton] = []
    
    var loginUsers = [User]()
    
    let refreshC = UIRefreshControl()
    
    var popUpFlag: String = ""  {
        willSet(newValue){ dbRef.child("Users").child("\(newValue)").child("vs").observe(.value) { (snap) in
            let data = (snap.value) as? String
            if data != "" && data != "ok" {
                challengerVC.vs = data ?? ""
                challengerVC.titleLabel.text = "\(data ?? "")님의 도전을 받을래?!"
                challengerVC.yesBtn.isEnabled = true
                challengerVC.modalPresentationStyle = .overCurrentContext
                
                amIChallenger = false
                firstAmI = false
                
                self.present(challengerVC, animated: true, completion: {
                    ()
                })
            }
            }
        }
    }
    
    var IDlabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(25)
        label.text = "ID"
        label.textColor = .black
        return label
    }()
    
    let profileImg: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    let IDTblView: UITableView = {
        let tbl = UITableView()
        tbl.translatesAutoresizingMaskIntoConstraints = false
        
        return tbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubViews()
        IDTblView.dataSource = self
        setupFirstMenu()
        loadProfile()
        downloadUsersInfo(){
            if $0{
                self.loginUsers = usersInfo.filter{$0.loginState == true}
                self.IDTblView.reloadData()
            }else{
                print("fail to down")
            }
        }
        
        IDTblView.register(UINib(nibName: "FriendIDTableViewCell", bundle: nil), forCellReuseIdentifier: "cellId")
        IDTblView.rowHeight = 80
        IDTblView.backgroundColor = #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 0.4162296661)
        IDTblView.layer.cornerRadius = 5
        IDTblView.layer.masksToBounds = true
        IDTblView.allowsSelection = false
        IDTblView.separatorStyle = .none
        
        IDlabel.font = UIFont.boldSystemFont(ofSize: 25)
        
        myInformBackgroundView.backgroundColor = #colorLiteral(red: 0, green: 0.5702844858, blue: 0.2303800881, alpha: 0.351937072)
        myInformBackgroundView.layer.cornerRadius = 5
        
        scoreTitleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        scoreTitleLabel.text = "전적"
        scoreTitleLabel.textColor = .black
        
        scoreWinCountLabel.text = "W: 0  L: 0"
        scoreWinRateLabel.textColor = .black
        scoreWinRateLabel.font = UIFont.systemFont(ofSize: 15)
        
        scoreWinRateLabel.text = "50%"
        scoreWinRateLabel.textColor = .black
        scoreWinRateLabel.font = UIFont.systemFont(ofSize: 15)
        
        //        userLevelLabel.text = "만만함ㅎㅎ"
        //        userLevelLabel.backgroundColor = #colorLiteral(red: 0.8981249928, green: 0.0150892837, blue: 0, alpha: 1)
        userLevelLabel.textColor = .white
        userLevelLabel.font = UIFont.systemFont(ofSize: 10)
        userLevelLabel.textAlignment = .center
        
        print(loginUsers)
        print("🔸🔸🔸 LoginUsers: ", loginUsers)
        
    }
    
    
    func autoLayout() {
        let guide = view.safeAreaLayoutGuide
        
        view.addSubview(myInformBackgroundView)
        myInformBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        myInformBackgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        myInformBackgroundView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 15).isActive = true
        myInformBackgroundView.widthAnchor.constraint(equalTo: guide.widthAnchor, constant: -40).isActive = true
        myInformBackgroundView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        profileImg.centerYAnchor.constraint(equalTo: myInformBackgroundView.centerYAnchor).isActive = true
        profileImg.leadingAnchor.constraint(equalTo: myInformBackgroundView.leadingAnchor, constant: 20).isActive = true
        profileImg.widthAnchor.constraint(equalTo: guide.widthAnchor, multiplier: 0.25).isActive = true
        profileImg.heightAnchor.constraint(equalTo: profileImg.widthAnchor, multiplier: 1).isActive = true
        profileImg.layer.cornerRadius = 15
        profileImg.layer.masksToBounds = true
        
        IDlabel.leadingAnchor.constraint(equalTo: profileImg.trailingAnchor, constant: 50).isActive = true
        IDlabel.topAnchor.constraint(equalTo: myInformBackgroundView.topAnchor, constant: 40).isActive = true
        IDlabel.widthAnchor.constraint(equalToConstant: 65).isActive = true
        IDlabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(userLevelLabel)
        userLevelLabel.translatesAutoresizingMaskIntoConstraints = false
        userLevelLabel.centerYAnchor.constraint(equalTo: IDlabel.centerYAnchor).isActive = true
        userLevelLabel.leadingAnchor.constraint(equalTo: IDlabel.trailingAnchor, constant: 10).isActive = true
        userLevelLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        userLevelLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        userLevelLabel.layer.cornerRadius = 5
        userLevelLabel.layer.masksToBounds = true
        
        
        view.addSubview(scoreTitleLabel)
        scoreTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreTitleLabel.leadingAnchor.constraint(equalTo: profileImg.trailingAnchor, constant: 50).isActive = true
        scoreTitleLabel.topAnchor.constraint(equalTo: IDlabel.bottomAnchor, constant: 15).isActive = true
        scoreTitleLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        scoreTitleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        view.addSubview(scoreWinCountLabel)
        scoreWinCountLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreWinCountLabel.centerYAnchor.constraint(equalTo: scoreTitleLabel.centerYAnchor, constant: -9).isActive = true
        scoreWinCountLabel.leadingAnchor.constraint(equalTo: scoreTitleLabel.trailingAnchor, constant: 20).isActive = true
        scoreWinCountLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        scoreWinCountLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(scoreWinRateLabel)
        scoreWinRateLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreWinRateLabel.centerYAnchor.constraint(equalTo: scoreTitleLabel.centerYAnchor, constant: 9).isActive = true
        scoreWinRateLabel.centerXAnchor.constraint(equalTo: scoreWinCountLabel.centerXAnchor).isActive = true
        scoreWinRateLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        scoreWinRateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        IDTblView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 170).isActive = true
        IDTblView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20).isActive = true
        IDTblView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20).isActive = true
        IDTblView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -20).isActive = true
        IDTblView.heightAnchor.constraint(equalTo: guide.heightAnchor, multiplier: 0.75).isActive = true
        
        view.sendSubviewToBack(myInformBackgroundView)
        
    }
    
    func addSubViews() {
        let views = [IDTblView, profileImg, IDlabel]
        views.forEach { view.addSubview($0) }
        IDTblView.refreshControl = refreshC
        refreshC.addTarget(self, action: #selector(reloadTblView(_:)), for: .valueChanged)
    }
    
    private func randomColorGenerator() -> UIColor {
        let red = CGFloat.random(in: 0...1.0)
        let green = CGFloat.random(in: 0...1.0)
        let blue = CGFloat.random(in: 0...1.0)
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    private func setupFirstMenu() {
        let menuTitle = ["more", "logout", "option"]
        for i in (0..<UI.menuCount) {
            let menuFrame = CGRect(
                x: view.bounds.width - 80, y: view.bounds.height - view.bounds.height + 50,
                width: UI.menuSize, height: UI.menuSize
            )
            let button = makeMenuButton(with: menuFrame, title: menuTitle[i])
            firstMenuContainer.append(button)
            
            if i == 0 {
                button.transform = .identity
                button.addTarget(self, action: #selector(firstMenuDidTap(_:)), for: .touchUpInside)
            } else if i == 1 {
                button.addTarget(self, action: #selector(didTapLogoutBtn(_:)), for: .touchUpInside)
            }
        }
        view.bringSubviewToFront(firstMenuContainer.first!)
    }
    
    @objc private func firstMenuDidTap(_ button: UIButton) {
        print("---------- [ usingSpringWithDamping ] ----------\n")
        button.isSelected.toggle()
        
        UIView.animate(
            withDuration: Time.short,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.0,
            animations: {
                for (idx, menu) in self.firstMenuContainer.enumerated() {
                    guard idx != 0 else { continue }
                    if button.isSelected {
                        menu.transform = .identity
                        menu.center.y += UI.distance * CGFloat(idx)
                    } else {
                        menu.transform = menu.transform.scaledBy(x: UI.minScale, y: UI.minScale)
                        menu.center.y -= UI.distance * CGFloat(idx)
                    }
                }
        })
    }
    
    @objc func didTapLogoutBtn(_ sender: UIButton) {
        toFalseLoginState(){
            self.loginUsers = usersInfo.filter{$0.loginState == true}
            self.IDTblView.reloadData()
        }
        KOSession.shared().logoutAndClose { (success, error) -> Void in
            if let error = error {
                return print(error.localizedDescription)
            }
            AppDelegate.instance.setupRootViewController()
        }
    }
    
    private func makeMenuButton(with frame: CGRect, title: String) -> UIButton {
        let btn = UIButton(frame: frame)
        btn.backgroundColor = randomColorGenerator()
        btn.layer.cornerRadius = btn.bounds.width / 2
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = btn.titleLabel?.font.withSize(10)
        btn.transform = btn.transform.scaledBy(x: UI.minScale, y: UI.minScale)
        view.addSubview(btn)
        return btn
    }
    
    func loadProfile() {
        KOSessionTask.userMeTask { [weak self] (error, userMe) in
            if let error = error {
                return print(error.localizedDescription)
            }
            guard let me = userMe,
                let nickName = me.nickname,
                let profileImageLink = me.profileImageURL,
                let thumbnailImageLink = me.thumbnailImageURL
                else { return }
            
            playerID = nickName
            self?.popUpFlag = nickName
            self?.IDlabel.text = playerID
            
            
            let imageLinks = [thumbnailImageLink, profileImageLink]
            for url in imageLinks {
                URLSession.shared.dataTask(with: url, completionHandler: { (data, res, error) in
                    if let error = error {
                        return print(error.localizedDescription)
                    }
                    guard let data = data, let image = UIImage(data: data) else { return }
                    
                    DispatchQueue.main.async {
                        if url == profileImageLink {
                            playerProfileImg = image
                            self?.profileImg.image = playerProfileImg
                        }
                        self?.autoLayout()
                        uploadUserInfo(){
                            downloadUsersInfo(){
                                if $0{
                                    self?.loginUsers = usersInfo.filter{$0.loginState == true}
                                    self?.IDTblView.reloadData()
                                    
                                    let loginUser = self?.loginUsers.filter{ $0.name == playerID }.first
                                    var winRate = 0
                                    
                                    if !( (loginUser!.winCount + loginUser!.loseCount) == 0 ) {
                                        winRate = Int( (Double(loginUser!.winCount) / Double(loginUser!.winCount+loginUser!.loseCount)) * 100 )
                                    } else {
                                        winRate = 0
                                    }
                                    self?.decideUserLevel(winRate: winRate)
                                    
                                }else{
                                    print("fail to down")
                                }
                            }
                        }
                    }
                }).resume()
            }
        }
    }
    
    func decideUserLevel(winRate: Int) {
        var backbgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        var title = ""
        
        switch winRate {
        case 0...45 :
            backbgroundColor = #colorLiteral(red: 0.1458860338, green: 0.6174393296, blue: 0.1099483743, alpha: 1)
            title = "만만함ㅎㅎ"
        case 46...60 :
            backbgroundColor = #colorLiteral(red: 0.2611661553, green: 0.2594151497, blue: 0.6888753176, alpha: 1)
            title = "숙명의라이벌"
        case 61...100 :
            backbgroundColor = #colorLiteral(red: 0.8981249928, green: 0.0150892837, blue: 0, alpha: 1)
            title = "도망가는게상책"
        default :
            backbgroundColor = .black
            title = "보통"
        }
        userLevelLabel.backgroundColor = backbgroundColor
        userLevelLabel.text = title
    }
    
    @objc func reloadTblView(_ sender: UIRefreshControl) {
        loginUsers = usersInfo.filter{$0.loginState}
        downloadUsersInfo(){
            if $0{
                self.loginUsers = usersInfo.filter{$0.loginState == true}
                self.IDTblView.reloadData()
            }else{
                print("fail to down")
            }
        }
        IDTblView.reloadData()
        refreshC.endRefreshing()
    }
}

extension FindGameVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loginUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let FriendIDCell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! FriendIDTableViewCell
        
        let loginUser = loginUsers[indexPath.row]
        print(loginUsers)
        var winRate = 0
        print("⭐️⭐️⭐️ cell ", loginUser.winCount, " lose : ", loginUser.loseCount)
        if !( (loginUser.winCount + loginUser.loseCount) == 0 ) {
            winRate = Int( (Double(loginUser.winCount) / Double(loginUser.winCount+loginUser.loseCount)) * 100 )
        } else {
            winRate = 0
        }
        
        FriendIDCell.userImageView.image = loginUser.playerImg
        FriendIDCell.userNameLabel.text = loginUser.name
        FriendIDCell.scoreWinCountLabel.text = "W: \(loginUser.winCount) L: \(loginUser.loseCount)"
        FriendIDCell.scoreWinRateLabel.text = "\(winRate)%"
        FriendIDCell.decideUserLevel(winRate: winRate)
        FriendIDCell.tag = indexPath.row + 1
        FriendIDCell.vsBtn.addTarget(self, action: #selector(didTapCellBtn(_:)), for: .touchUpInside)
        
        print("dddejaonteosnt: ", indexPath.row)
        
        
        print("🔸🔸🔸 FriendIDCell: ", FriendIDCell)
        
        
        return FriendIDCell
    }
    
    
    
    @objc func didTapCellBtn(_ sender: UIButton) {
        popUpVC.modalPresentationStyle = .overCurrentContext
        let vsName = loginUsers[sender.tag + 1].name
        print("###### : ", sender.tag)
        let myName = IDlabel.text
        popUpVC.vs = vsName
        if vsName != myName {
            popUpVC.titleLabel.text = "\(vsName)님과 한판 뜰래요?"
            popUpVC.yesBtn.isEnabled = true
        } else {
            popUpVC.titleLabel.text = "자기와 한판은 불가능!!"
            popUpVC.yesBtn.isEnabled = false
        }
        amIChallenger = true
        firstAmI = true
        
        present(popUpVC, animated: true)
    }
}
