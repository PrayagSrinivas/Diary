//
//  LogInVC.swift
//  RishabhDiaryProject
//
//

import UIKit
import FirebaseAuth

class LogInVC: UIViewController {

    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    var indicator:UIActivityIndicatorView = UIActivityIndicatorView()
    var isComingFromDashBoard:Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.passwordTF.text = ""
        self.emailTF.text = ""
        presentDashboard()
    }
    //MARK: FIREBASE AUTHENTICATION AND SIGN IN
    @IBAction func SignInTapped(_ sender: UIButton) {
        //Validating email and password based on the input
        guard let email = emailTF.text, !email.isEmpty,let password = passwordTF.text, !password.isEmpty else {
            alertManager(alertControllerTitle: "Validate your input", message: "Please validate your email and passaword", alertActionTitle: "Ok")
            return
        }
        //Firebase login
        self.showActivityIndicator(indicator: &indicator)
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let strongSelf = self else{
                return
            }
            guard error == nil else{
                strongSelf.loginFailed()
                return
            }
            let vc = self?.storyboard?.instantiateViewController(withIdentifier: "DiaryTableVC") as! DiaryTableVC
            vc.modalPresentationStyle = .fullScreen
            self?.hideActivityIndicator(indicator: &self!.indicator)
            self?.present(vc, animated: true, completion: nil)
            print("Signed In")
        }
      
    }
    //MARK: FUNCTION FOR PRESENTING DASHBOARD
    private func presentDashboard(){
        guard let isComingFromDashBoard = isComingFromDashBoard else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            if isComingFromDashBoard{self.showToast(message: "Signed Out Scuccssfully", seconds: 1.5)}
        }
    }
    //MARK: Create account code snippet
    private func loginFailed(){
        alertManager(alertControllerTitle: "Login failed", message: "Please check your email and password", alertActionTitle: "Ok")
    }
}

