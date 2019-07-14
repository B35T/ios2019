//
//  FileManager.swift
//  FLIM2019
//
//  Created by chaloemphong on 5/7/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import Foundation
import UIKit
import CoreData

open class UserFileManager {
    
    class var shared: UserFileManager {
        struct Static {
            static let instance:UserFileManager = UserFileManager()
        }
        return Static.instance
    }
    

    var context: NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }
    
    func document() -> URL? {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return url
    }
    
    func removeInPath(namePath path:String) {
        let url = self.document()?.appendingPathComponent("/\(self.path())")
        do {
            try FileManager.default.removeItem(atPath: url!.path)
        } catch {
            fatalError("err delete path")
        }
    }

    
    func saveInPath(image:UIImage, cover:UIImage, imageOrientation: Int = 0, completion: (_ action: Bool) -> ()) {
        self.counter_id()
        let id = UserDefaults.standard.value(forKey: "counter") as! Int
        
        let insert = NSEntityDescription.insertNewObject(forEntityName: "Slot", into: self.context)
        let dataCover = cover.jpegData(compressionQuality: 0.5)!
        if let data = image.jpegData(compressionQuality: 0.5) {
            
            insert.setValue(data, forKey: "imageData")
            insert.setValue(id, forKey: "id")
            insert.setValue(dataCover, forKey: "coverData")
            
            do {
                try context.save()
            } catch {
                fatalError("err save image")
            }
            
            completion(true)
        } else {
            print("no image")
        }
    }
    
    func count() -> Int {
        let fetch = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Slot")
        fetch.returnsObjectsAsFaults = false
        
        var i:Int = 0
        
        let results = try! context.fetch(fetch)
        
        if results.count > 0 {
            for _ in results as! [NSManagedObject] {
                i += 1
            }
        } else {
            print("no image ")
        }
        return i
    }
    
    func findLast() -> UIImage? {
        let id = UserDefaults.standard.value(forKey: "counter") as! Int
        let fetch = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Slot")
        fetch.predicate = NSPredicate(format: "id = %@", String(id))
        fetch.returnsObjectsAsFaults = false
     
        
        let results = try! context.fetch(fetch)
        
        if results.count > 0 {
            for result in results as! [NSManagedObject] {
                let data = result.value(forKey: "coverData")
                return UIImage(data: data as! Data)
            }
        }
        return nil
    }
    
    func getimage(completion: (UIImage?) -> ()) {
        let fetch = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Slot")
        fetch.returnsObjectsAsFaults = false
        
        let results = try! context.fetch(fetch)
        
        if results.count > 0 {
            for result in results as! [NSManagedObject] {
                let data = result.value(forKey: "coverData")
                completion(UIImage(data: data as! Data))
            }
        } else {
            print("no image ")
        }
        
    }
    
    func findCover() -> [UIImage?] {
        let fetch = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Slot")
        fetch.returnsObjectsAsFaults = false
        
        var image:[UIImage?] = []
        
        let results = try! context.fetch(fetch)
        
        if results.count > 0 {
            for result in results as! [NSManagedObject] {
                let data = result.value(forKey: "coverData")
                image.append(UIImage(data: data as! Data))
            }
        } else {
            print("no image ")
        }
        return image
    }
    
    func findAll() -> [UIImage?] {
        let fetch = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Slot")
        fetch.returnsObjectsAsFaults = false
        
        var image:[UIImage?] = []
        
        let results = try! context.fetch(fetch)
        
        if results.count > 0 {
            for result in results as! [NSManagedObject] {
                let data = result.value(forKey: "imageData")
                image.append(UIImage(data: data as! Data))
            }
        } else {
            print("no image ")
        }
        return image
    }
    
    func removeCover() {
        let fetch = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Slot")
        fetch.returnsObjectsAsFaults = false
   
        let results = try! context.fetch(fetch)
        
        if results.count > 0 {
            for result in results as! [NSManagedObject] {
                self.context.delete(result)
                do {
                    try self.context.save()
                    
                } catch {
                    fatalError("err delegate Cover")
                }
            }
        } else {
            print("no image ")
        }
   
    }
    
    func get_value(key:String) -> Any? {
        return UserDefaults.standard.value(forKey: key)
    }
    
    func set_style(name:String) {
        UserDefaults.standard.set(name, forKey: "styles")
    }
    
    func path() -> Int {
        return UserDefaults.standard.value(forKey: "path") as! Int
    }

    func generator_path() -> Int? {
        if let dev = UserDefaults.standard.value(forKey: "develop") as? Bool, !dev {
            if UserDefaults.standard.value(forKey: "path") == nil {
                UserDefaults.standard.set(1, forKey: "path")
                return 1
            } else {
                return UserDefaults.standard.value(forKey: "path") as? Int
            }
        } else {
            return nil
        }
        
            
    }
    
    func counter_id() {
        if var i = UserDefaults.standard.value(forKey: "counter") as? Int, i <= 35 {
            i += 1
            UserDefaults.standard.set(i , forKey: "counter")
        } else {
            UserDefaults.standard.set(1, forKey: "counter")
        }
    }
    
    func setDefualt() {
        UserDefaults.standard.set(0, forKey: "counter")        
        self.removeCover()
    }
    
}
