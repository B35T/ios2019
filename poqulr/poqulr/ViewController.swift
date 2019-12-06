//
//  ViewController.swift
//  poqulr
//
//  Created by chaloemphong on 27/9/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit
import Ngin



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NginPing("http://192.168.1.5:1234/ping")
        let apikey = NginAPI_KEY()
        apikey.key = "0999273733"
        apikey.check()
        
        let register = NginUserRegister()
        register.agree = true
        register.email = "test@mail.com"
        register.password = "1234"
        register.displayName = "best ner"
        register.username = "b35t"
        register.age = 25
        register.sex = "male"
        register.country = "thailand"
        register.cover_URL = "http://"
        register.cover_mini_URL = "http://"
        
        let token = register.register("http://192.168.1.5:1234", path: "api/register")
        print(token)
        
        register.authJWT("http://192.168.1.5:1234", path: "api/auth", token: token)
    }


}

