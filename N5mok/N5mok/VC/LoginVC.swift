//
//  LoginVC.swift
//  N5mok
//
//  Created by hyeoktae kwon on 22/05/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

final class LoginVC: UIViewController {
    let imageView = UIImageView()
    let logoBackgroundLabel = UILabel()
    
    
    let loginBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "KakaoLogin"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(loginForKakao(_:)), for: .touchUpInside)
        btn.alpha = 0
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        
        
        imageView.frame = view.frame
        imageView.image = UIImage(named: "launchImage2")
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0
        view.sendSubviewToBack(imageView)
        
        view.addSubview(logoBackgroundLabel)
        logoBackgroundLabel.translatesAutoresizingMaskIntoConstraints = false
        logoBackgroundLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        logoBackgroundLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
//        logoBackgroundView.frame.size = CGSize(width: 150, height: 150)
        logoBackgroundLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        logoBackgroundLabel.heightAnchor.constraint(equalTo: logoBackgroundLabel.widthAnchor, multiplier: 1).isActive = true
        logoBackgroundLabel.backgroundColor = #colorLiteral(red: 0.3107331097, green: 0.3059993684, blue: 0.3027139604, alpha: 0.3400845462)
        logoBackgroundLabel.layer.cornerRadius = view.frame.width*0.7/2
        logoBackgroundLabel.layer.masksToBounds = true
        
        logoBackgroundLabel.text = "오목골목대장"
        logoBackgroundLabel.textColor = .white
        logoBackgroundLabel.alpha = 0
        logoBackgroundLabel.textAlignment = .center
        logoBackgroundLabel.font = UIFont.boldSystemFont(ofSize: 40)
        
        autoLayout()
        
        UIView.animate(withDuration: 3) {
            self.imageView.alpha = 1
            self.loginBtn.alpha = 1
            self.logoBackgroundLabel.alpha = 1
        }
    }
    
    @objc func loginForKakao(_ sender: UIButton) {
        guard let session = KOSession.shared() else {return}
        
        session.isOpen() ? session.close() : ()
        
        session.open(completionHandler: { (error) in
            if !session.isOpen() {
                if let error = error as NSError? {
                    switch error.code {
                    case Int(KOErrorCancelled.rawValue) :
                        print("cancelled")
                    default:
                        print(error.localizedDescription)
                    }
                }
            } else {
                print("Login Success")
                AppDelegate.instance.setupRootViewController()
            }
            
        }
//            , authTypes: [NSNumber(value: KOAuthType.account.rawValue)]
        )
        // 여기서 로그인방법 바꿀수 있다.
        
    }
    
    func autoLayout() {
        let guide = view.safeAreaLayoutGuide
        
        view.addSubview(loginBtn)
        
        loginBtn.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -50).isActive = true
        loginBtn.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
    }
}
