//
//  Review+CoreDataClass.swift
//  
//
//  Created by admin on 15/07/2022.
//
//

import Foundation
import CoreData
import UIKit
import Firebase

@objc(Review)
public class Review: NSManagedObject {
    static func createReview(id:String, hotelName: String, releaseYear: Int64, genre: String, imageUrl: String, rating: Int64, review: String, userId:String , lastUpdated: Int64)-> Review {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let currReview = Review(context: context)
        currReview.id = id
        currReview.hotelName = hotelName
        currReview.releaseYear = releaseYear
        currReview.genre = genre
        currReview.review = review
        currReview.imageUrl = imageUrl
        currReview.rating = rating
        currReview.userId = userId
        currReview.lastUpdated = lastUpdated
        currReview.wasDeleted = false
        
        return currReview
    }
    
    static func create(json:[String:Any])->Review? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let review = Review(context: context)
        review.id = json["id"] as? String
        review.hotelName = json["hotelName"] as? String
        review.releaseYear = (json["releaseYear"] as? Int64)!
        review.genre = json["genre"] as? String
        review.review = json["review"] as? String
        review.rating = (json["rating"] as? Int64)!
        review.userId = json["userId"] as? String
        review.imageUrl = json["imageUrl"] as? String
        review.lastUpdated = 0
        
        if let timestamp = json["lastUpdated"] as? Timestamp {
            review.lastUpdated = Int64(timestamp.seconds)
        }
        
        if let wasDeleted = json["wasDeleted"] as? Bool {
            review.wasDeleted = wasDeleted
        }
        
        return review
    }
    
    func toJson()->[String:Any] {
        var json = [String:Any]()
        json["id"] = id!
        json["hotelName"] = hotelName!
        json["releaseYear"] = releaseYear
        json["genre"] = genre!
        json["review"] = review!
        json["rating"] = rating
        json["userId"] = userId!
        json["imageUrl"] = imageUrl!
        json["lastUpdated"] = FieldValue.serverTimestamp()
        json["wasDeleted"] = wasDeleted
        
        return json
    }
}

extension Review {
    static func getAll(callback:@escaping ([Review])->Void){
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = Review.fetchRequest() as NSFetchRequest<Review>
        request.sortDescriptors = [NSSortDescriptor(key: "lastUpdated", ascending: false)]
        
        DispatchQueue.global().async {
            // second thread code
            var data = [Review]()
            do {
                data = try context.fetch(request)
            } catch {
            }
            
            DispatchQueue.main.async {
                // code to execute on main thread
                callback(data)
            }
        }
    }
    
    func save(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        do {
            try context.save()
        } catch {
        }
    }
    
    func delete(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(self)
        do {
            try context.save()
        } catch {
            
        }
    }
    
    static func getReview(byId:String)->Review?{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = Review.fetchRequest() as NSFetchRequest<Review>
        request.predicate = NSPredicate(format: "id == %@", byId)
        do {
            let reviews = try context.fetch(request)
            if reviews.count > 0 {
                return reviews[0]
            }
        } catch {
            
        }
        return nil
    }
    
    static func getReviews(byUserId:String, callback:@escaping ([Review])->Void){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = Review.fetchRequest() as NSFetchRequest<Review>
        request.sortDescriptors = [NSSortDescriptor(key: "lastUpdated", ascending: false)]
        request.predicate = NSPredicate(format: "userId == %@", byUserId)
        
        DispatchQueue.global().async {
            // second thread code
            var data = [Review]()
            do {
                data = try context.fetch(request)
            } catch {
            }
            
            DispatchQueue.main.async {
                // code to execute on main thread
                callback(data)
            }
        }
    }
}
