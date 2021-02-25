//
//  ViewController.swift
//  TestLogin
//
//  Created by s3 on 2/25/21.
//

import UIKit
import QuartzCore
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet var tfEmail: UITextField!
    @IBOutlet var tfPassword: UITextField!
    @IBOutlet var btLogin: UIButton!
    
    @IBOutlet var lbErrorEmail: UILabel!
    @IBOutlet var lbErrorPassword: UILabel!
    
    var userLogin = UserModelLogin()
    var controlLogin = LoginViewModel()
    
    let disposedBag = DisposeBag()
    
    var isValidPassword: Bool = false {
        didSet {
            guard isValidEmail == true, isValidPassword == true else {
                btLogin.isEnabled = false
                btLogin.alpha = 0.5
                return
            }
            btLogin.isEnabled = true
            btLogin.alpha = 1.0
        }
    }
    
    var isValidEmail: Bool = false {
        didSet {
            guard isValidEmail == true, isValidPassword == true else {
                btLogin.isEnabled = false
                btLogin.alpha = 0.5
                return
            }
            btLogin.isEnabled = true
            btLogin.alpha = 1.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        userLogin.email = ""
        userLogin.password = ""
        setupScreen()
    }
    
    func setupScreen() {
        
        controlLogin.owner = self
        
        //Setup Button
        btLogin.layer.cornerRadius = 8
        btLogin.rx.tap.bind {
            self.controlLogin.callApiWithData(userLogin: self.userLogin)
        }.disposed(by: disposedBag)
        
        //Setup Email Field, Password Field
        tfEmail.rx.controlEvent([.editingDidEnd, .editingChanged]).asObservable().subscribe(onNext: { [weak self] in
            self?.controlLogin.checkInvalidEmail(email: self?.tfEmail.text)
        }).disposed(by: disposedBag)
        
        tfPassword.rx.controlEvent([.editingDidEnd, .editingChanged]).asObservable().subscribe(onNext: { [weak self] in
            self?.controlLogin.checkInvalidPassword(password: self?.tfPassword.text)
        }).disposed(by: disposedBag)
    }
    @IBAction func clickLogin(_ sender: Any) {
        tfEmail.resignFirstResponder()
        tfPassword.resignFirstResponder()
        if btLogin.isEnabled {
            controlLogin.callApiWithData(userLogin: userLogin)
        }
    }
}

extension ViewController: LoginViewModelProtocol {
    
    func showAlertLogin(meessae: String, type: TypeField) {
        switch type {
        case .email:
            isValidEmail = false
            lbErrorEmail.text = meessae
        case .password:
            isValidPassword = false
            lbErrorPassword.text = meessae
        default:
            let alert = UIAlertController(title: "Login", message: meessae, preferredStyle:.alert)
            let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func validAtField(type: TypeField) {
        if type == .email {
            isValidEmail = true
            lbErrorEmail.text = ""
            userLogin.email = tfEmail.text
        } else {
            isValidPassword = true
            lbErrorPassword.text = ""
            userLogin.password = tfPassword.text
        }
    }
}

