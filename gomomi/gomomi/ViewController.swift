//
//  ViewController.swift
//  gomomi
//
//  Created by chaloemphong on 24/9/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit
import Pop

struct result {
    let name:String?
    let age:Int?
    let key:String?
}

class Ngin {
    
    var ngin:PopNgin
    
    init() {
        self.ngin = PopNgin()
    }
    
    var age:Int? {
        didSet {
            self.ngin.age = self.age ?? 0
        }
    }
    
    var name:String? {
        didSet {
            self.ngin.name = self.name ?? ""
        }
    }
    
    var key:String? {
        didSet {
            self.ngin.key = self.key ?? ""
        }
    }
    
    var results: result? {
        let r = result(name: self.ngin.name, age: self.ngin.age, key: self.ngin.key)
        return r
    }
    
    var method:PopNgin {
        return self.ngin
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let ngin = Ngin()
        
        ngin.name = "best"
        ngin.age = 25
        ngin.key = "0999273733"
        
        ngin.method.printData()
        
        ngin.method.send("http://192.168.1.5:1234/post")
        
        let result = ngin.method.get("http://192.168.1.5:1234/user")
        result?.printData()
        
    }


}

