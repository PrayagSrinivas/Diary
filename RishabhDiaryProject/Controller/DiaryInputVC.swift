//
//  DiaryInputVC.swift
//  RishabhDiaryProject
//
//

import UIKit
import FirebaseFirestore

class DiaryInputVC: UIViewController {
    let db = Firestore.firestore()
    lazy var indicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var bodyView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //MARK: WRITE DATA INTO DB(CLOUD FIRESTORE)
    private func writeData(title:String,body:String,createdAt:String){
        self.showActivityIndicator(indicator: &indicatorView)
        db.collection("diary").addDocument(data: ["title":title,"body":body,"createdAt":createdAt]) { error in
            if error == nil{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "DiaryTableVC") as! DiaryTableVC
                self.hideActivityIndicator(indicator: &self.indicatorView)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }else{
                print(error?.localizedDescription as Any)
            }
        }
    }
    //MARK: DISMISSING VIEW CONTROLLER
    @IBAction func backTapped(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    //MARK: SUBMIT ACTION
    @IBAction func submitTapped(_ sender: UIButton) {
        guard let title = titleField.text, !title.isEmpty, let body = bodyView.text, !body.isEmpty else {
            alertManager(alertControllerTitle: "Validate your input", message: "Check your title and body input again", alertActionTitle: "Ok")
            return
        }
        writeData(title: title, body: body, createdAt: Date.now.asString(style: .medium))
    }
}
