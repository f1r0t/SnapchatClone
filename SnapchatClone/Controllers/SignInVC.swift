//
//  ViewController.swift
//  SnapchatClone
//
//  Created by Fırat AKBULUT on 25.10.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignInVC: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signInPressed(_ sender: UIButton) {
        if let email = emailText.text, let password = passwordText.text {
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let e = error {
                    self.makeAlert(title: "Error", message: e.localizedDescription)
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: self)
                }
            }
        }
   
    }
    
    @IBAction func singUpPressed(_ sender: UIButton) {
        if let email = emailText.text, let password = passwordText.text{
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    self.makeAlert(title: "Error", message: e.localizedDescription)
                } else {
                    let db = Firestore.firestore()
                    let userDictionary = ["email": self.emailText.text, "username": self.usernameText.text] as! [String: Any]
                    db.collection("userInfo").addDocument(data: userDictionary) { error in
                        if let e = error {
                            self.makeAlert(title: "Error", message: e.localizedDescription)
                        }
                    }
                    self.performSegue(withIdentifier: "toFeedVC", sender: self)
                }
            }
        }
    }
    
    func makeAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
}

