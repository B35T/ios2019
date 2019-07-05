//
//  FileManager.swift
//  FLIM2019
//
//  Created by chaloemphong on 5/7/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import Foundation

open class UserFileManager {
    
    class var shared: UserFileManager {
        struct Static {
            static let instance:UserFileManager = UserFileManager()
        }
        return Static.instance
    }
    

    
    func document() -> URL? {
        do {
            let url = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            return url
        } catch {
            return nil
        }
    }
    
    func get_value(key:String) -> Any? {
        return UserDefaults.standard.value(forKey: key)
    }
    
    func set_style(name:String) {
        UserDefaults.standard.set(name, forKey: "styles")
    }

    func generator_id() -> Int {
        if var id = UserDefaults.standard.value(forKey: "id") as? Int {
            id += 1
            UserDefaults.standard.set(id, forKey: "id")
            return id
        } else {
            UserDefaults.standard.set(1, forKey: "id")
            return 1
        }
    }
    
    func counter(key:String, val:Int) {
        if var i = UserDefaults.standard.value(forKey: "counter") as? Int, i <= 35 {
            i += 1
            UserDefaults.standard.set(i , forKey: "counter")
        } else {
            UserDefaults.standard.set(1, forKey: "counter")
        }
        
    }
    
    func setDefualt() {
        UserDefaults.standard.set(0, forKey: "counter")
        UserDefaults.standard.set("none", forKey: "styles")
    }
    
}
