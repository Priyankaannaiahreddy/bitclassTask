//
//  AddFriendViewController.swift
//  Bitclass Task
//
//  Created by Rahul Sharma on 18/10/21.
//

import UIKit
import CoreData

protocol AddFriendViewControllerDelegate:NSObject {
    func didEnterDetails(details:Friend)
    func didUpdateDetails(index:Int,name:String,bio:String)
}

class AddFriendViewController: UIViewController {
    
    @IBOutlet var bioTextView: UITextView!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var popupView: UIView!
    
    //global variables
    weak var delegate:AddFriendViewControllerDelegate? = nil
    var isForUpdate = false
    var index = 0
    var friendsVM = FriendsViewModel()
    var friend = [Friend]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initialSetup()
        addDoneBtnToTextView()
    }
    
    func initialSetup() {
        
        nameTextField.delegate = self
        doneButton.layer.cornerRadius = 5
        let blurredView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurredView.frame = self.view.bounds
        self.backgroundView.addSubview(blurredView)
        popupView.layer.cornerRadius = 10
        bioTextView.layer.borderWidth = 1
        bioTextView.layer.cornerRadius = 5
        bioTextView.layer.borderColor = UIColor.gray.cgColor
        if isForUpdate {
            nameTextField.text = friend[index].name
            bioTextView.text = friend[index].bio
        }
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonAction(_ sender: UIButton) {
        if nameTextField.text != "" && bioTextView.text != "" {
            //if pop up is opened for updating the friend data
            if isForUpdate {
                delegate?.didUpdateDetails(index: index,name: nameTextField.text!,bio: bioTextView.text)
            }else{
                let newFriend = Friend(context: friendsVM.context)
                newFriend.name = nameTextField.text!
                newFriend.bio = bioTextView.text
                friendsVM.saveFriend()
                delegate?.didEnterDetails(details:newFriend)
            }
            self.dismiss(animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "", message:"Name and Bio fields cannot be left empty", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

extension AddFriendViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
    
    func addDoneBtnToTextView() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneBtnAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        bioTextView.inputAccessoryView = doneToolbar
    }
    
    @objc fileprivate func doneBtnAction() {
        bioTextView.resignFirstResponder()
    }
}
