//
//  ViewController.swift
//  Bitclass Task
//
//  Created by Rahul Sharma on 18/10/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet var mainTableView: UITableView!
    @IBOutlet var addFriendButton: UIButton!
    
    //global variables
    var friendsVM = FriendsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        friendsVM.loadFriends {
            mainTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //fetch data from core data model
    }
    
    @IBAction func addFriendButtonAction(_ sender: UIButton) {
        openAddFriendPopup(isForUpdate: false, index: 0)
    }
    
    
    /// method to open the add details pop up
    /// - Parameters:
    ///   - isForUpdate: to check if pop up is opened for updating or adding data
    ///   - index: index where data needs to be updated if any
    func openAddFriendPopup(isForUpdate:Bool,index:Int) {
        guard let friendPopup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddFriendViewController") as? AddFriendViewController else{return}
        friendPopup.modalPresentationStyle = .overCurrentContext
        friendPopup.delegate = self
        friendPopup.isForUpdate = isForUpdate
        friendPopup.friend = friendsVM.friend
        friendPopup.index = index
        self.present(friendPopup, animated: true, completion: nil)
    }
}

//MARK:- UITableView Delegates and DataSource

extension ViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsVM.friend.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTableViewCell", for: indexPath) as? FriendTableViewCell else{return UITableViewCell()}
        cell.nameLabel.text = friendsVM.friend[indexPath.row].name
        cell.bioLabel.text = friendsVM.friend[indexPath.row].bio
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let updateAction = UIContextualAction(style: .normal,
                                              title: "Update") { [weak self] (action, view, completionHandler) in
            self?.handleUpdateCellData(index: indexPath.row)
            completionHandler(true)
        }
        updateAction.backgroundColor = .systemBlue
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
            self.deleteCellData(index: indexPath)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [updateAction,deleteAction])
    }
    
    
    /// method to open popup for updating friend details
    /// - Parameter index: index where data needs to be updated
    private func handleUpdateCellData(index:Int) {
        openAddFriendPopup(isForUpdate: true,index:index)
    }
    
    
    /// method to delete friend and update core data model
    /// - Parameter index: index of friend that needs to be deleted
    private func deleteCellData(index:IndexPath) {
        friendsVM.context.delete(friendsVM.friend[index.row] as NSManagedObject)
        friendsVM.friend.remove(at: index.row)
        friendsVM.saveFriend()
        self.mainTableView.deleteRows(at: [index], with: .fade)
    }
}

extension ViewController:AddFriendViewControllerDelegate {
    
    
    /// delegate method to update the friend details
    /// - Parameters:
    ///   - index: index of friend that needs to be updated
    ///   - name: change in name
    ///   - bio: change in bio
    func didUpdateDetails(index:Int,name:String,bio:String) {
        friendsVM.friend[index].setValue(name, forKey: "name")
        friendsVM.friend[index].setValue(bio, forKey: "bio")
        friendsVM.saveFriend()
        mainTableView.reloadData()
    }
    
    
    /// adding new friend
    /// - Parameter details: friend details as type friend
    func didEnterDetails(details:Friend) {
        
        friendsVM.friend.append(details)
        friendsVM.saveFriend()
        mainTableView.reloadData()
    }
    
}

