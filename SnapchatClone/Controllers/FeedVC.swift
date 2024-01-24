//
//  FeedVC.swift
//  SnapchatClone
//
//  Created by Fırat AKBULUT on 25.10.2023.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import SDWebImage

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let db = Firestore.firestore()
    var snapArray = [Snap]()
    var selectedSnap: Snap?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getUserInfo()
        getSnapsFromFirebase()
    }
    
    func getUserInfo(){
        
        db.collection("userInfo").whereField("email", isEqualTo: Auth.auth().currentUser!.email!)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    self.makeAlert(title: "Error", message: err.localizedDescription)
                } else {
                    for document in querySnapshot!.documents {
                        if let username = document.get("username") as? String, let email = Auth.auth().currentUser?.email as? String {
                            UserSingleton.sharedUserInfo.email = email
                            UserSingleton.sharedUserInfo.username = username
                        }
                    }
                }
        }
    }
    
    func getSnapsFromFirebase(){
        db.collection("Snaps").order(by: "date", descending: true).addSnapshotListener { querySnapshot, error in
            if let e = error{
                self.makeAlert(title: "Error", message: e.localizedDescription)
            }else{
                if let snapshot = querySnapshot {
                    self.snapArray.removeAll(keepingCapacity: false)
                    for document in snapshot.documents{
                        let documentId = document.documentID
                        if let username = document.get("snapOwner") as? String, let imageUrlArray = document.get("imageUrlArray") as? [String], let date = document.get("date") as? Timestamp{
                            
                            if let timeDifference = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour{
                                if timeDifference > 24{
                                    self.db.collection("Snaps").document(documentId).delete { error in
                                    }                                   
                                }
                                let snap = Snap(username: username, imageUrlArray: imageUrlArray, date: date.dateValue(), timeDifference: 24 - timeDifference)
                                self.snapArray.append(snap)
                            }
                   
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.usernameLabel.text = snapArray[indexPath.row].username
        cell.feedImageView.sd_setImage(with: URL(string: snapArray[indexPath.row].imageUrlArray[0]))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSnap = snapArray[indexPath.row]
        performSegue(withIdentifier: "toSnapVC", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSnapVC"{
            let destinationVc = segue.destination as! SnapVC
            destinationVc.selectedSnap = selectedSnap
        }
    }
    
    func makeAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    

}
