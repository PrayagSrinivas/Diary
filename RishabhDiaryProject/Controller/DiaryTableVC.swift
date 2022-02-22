//
//  DiaryTableVC.swift
//  RishabhDiaryProject
//
//

import UIKit
import FirebaseFirestore

class DiaryTableVC: UIViewController {
    @IBOutlet weak var diaryTable:UITableView!
    lazy var diaryModel = [DiaryModel]()
    //Creating database instance for write and read data.
    let db = Firestore.firestore()
    var indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        title = "Diary"
        super.viewDidLoad()
        
        diaryTable.estimatedRowHeight = 100
        diaryTable.rowHeight = UITableView.automaticDimension
        diaryTable.register(DIaryCell.nib(), forCellReuseIdentifier: DIaryCell.identifier)
        getData()
    }
    
    //MARK: GET DATA FROM DB(CLOUD FIRESTORE)
    private func getData(){
        self.showActivityIndicator(indicator: &indicator)
        db.collection("diary").getDocuments { snapShots, error in
            if error == nil{
                //No error
                if let snapShot = snapShots{
                    self.diaryModel = snapShot.documents.map { doc in
                        return DiaryModel(id: doc.documentID, title: doc["title"] as? String ?? "", body: doc["body"] as? String ?? "", createdAt: doc["createdAt"] as? String ?? "")
                    }
                }
                self.diaryModel = self.diaryModel.sorted(by: {$0.createdAt.compare($1.createdAt,options: .numeric) == .orderedDescending})
                DispatchQueue.main.async {
                    self.diaryTable.reloadData()
                }
                self.hideActivityIndicator(indicator: &self.indicator)
            }else{
                //Handle error
                print(error?.localizedDescription as Any)
            }
        }
    }
    //MARK: DELETE DATA FROM DB(CLOUD FIRESTORE)
    private func deleteData(toDelete:DiaryModel){
        db.collection("diary").document(toDelete.id).delete()
        DispatchQueue.main.async {
            self.getData()
        }
    }
    
    //MARK: ADDING DIARY INPUT
    @IBAction func addYourDiaryInputTapped(_ sender:UIButton){
        let vc = storyboard?.instantiateViewController(withIdentifier: "DiaryInputVC") as! DiaryInputVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    //MARK: SIGNOUT USER
    @IBAction func signOut(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
        vc.modalPresentationStyle = .overFullScreen
        vc.isComingFromDashBoard = true
        self.present(vc, animated: true, completion: nil)
    }
}
//MARK: TABLE VIEW DELEGATE AND DATASOURCE
extension DiaryTableVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(diaryModel.count)
        if diaryModel.count == 0{
            diaryTable.setEmptyMessage("Nothing added in dairy, add your first note")
        }else{
            self.diaryTable.restore()
        }
        return diaryModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DIaryCell.identifier, for: indexPath) as! DIaryCell
        let data = diaryModel[indexPath.row]
        cell.title.text = data.title
        cell.body.text = data.body
        cell.date.text = data.createdAt
        return cell
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            deleteData(toDelete: diaryModel[indexPath.row])
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
