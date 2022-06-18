//
//  User+CoreDataClass.swift
//  
//
//  Created by admin on 13/07/2022.
//
//

import Foundation
import CoreData
import UIKit
import Firebase

@objc(User)
public class User: NSManagedObject {
    static func create(id: String, fullName: String, imageUrl: String, lastUpdated: Int64) -> User {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let user = User(context: context)
        user.id = id
        user.fullName = fullName
        user.imageUrl = imageUrl
        user.lastUpdated = lastUpdated
        user.wasDeleted = false
        return user
    }
    
    static func create(json:[String:Any])->User? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let user = User(context: context)
        user.id = json["id"] as? String
        user.fullName = json["fullName"] as? String
        user.imageUrl = json["imageUrl"] as? String
        user.lastUpdated = 0
        
        if let timestamp = json["lastUpdated"] as? Timestamp {
            user.lastUpdated = Int64(timestamp.seconds)
        }
        
        if let wasDeleted = json["wasDeleted"] as? Bool {
            user.wasDeleted = wasDeleted
        }
        
        return user
    }
    
    func toJson()->[String:Any] {
        var json = [String:Any]()
        json["id"] = id!
        json["fullName"] = fullName!
        json["imageUrl"] = imageUrl!
        json["lastUpdated"] = FieldValue.serverTimestamp()
        json["wasDeleted"] = wasDeleted
        
        return json
    }
}

extension User {
    static func getAll(callback:@escaping ([User])->Void){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = User.fetchRequest() as NSFetchRequest<User>
        
        DispatchQueue.global().async {
            var data = [User]()
            do{
                data = try context.fetch(request)
            }
            catch {
            }
            
            DispatchQueue.main.async {
                callback(data)
            }
        }
    }
    
    static func get(byId:String) -> User? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = User.fetchRequest() as NSFetchRequest<User>
        request.predicate = NSPredicate(format: "id == %@", byId)
        do {
            let users = try context.fetch(request)
            if users.count > 0 {
                return users[0]
            }
        }
        catch{}
        
        return nil
    }
    
    func save() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        do{
            try context.save()
        }
        catch {}
    }
    
    func delete(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(self)
        do{
            try context.save()
        }
        catch {}
    }
}
