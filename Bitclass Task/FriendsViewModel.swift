//
//  FriendsViewModel.swift
//  Bitclass Task
//
//  Created by Rahul Sharma on 19/10/21.
//

import Foundation
import CoreData
import UIKit

class FriendsViewModel {
    
    var friend = [Friend]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    /// fetching data from core data
    func loadFriends(completionHandler:()->Void) {
        
        let request : NSFetchRequest<Friend> = Friend.fetchRequest()
        
        do{
            friend = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }
        
    }
    
    /// save data to core data
    func saveFriend() {
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
        
    }

}
