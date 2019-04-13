//
//  ProcessEngine.swift
//  Colr
//
//  Created by chaloemphong on 12/4/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit


open class ProcessEngine: ProcessEngineProtocal {
    public var profile: ProcessEngineProfileModel?
    public var delegate: ProcessEngineDelegate?
    
    public class var shared: ProcessEngine {
        struct Static {
            static let instence: ProcessEngine = ProcessEngine()
        }
        return Static.instence
    }
    
    public func process() -> UIImage? {
        guard let profile = profile?.HSL else { fatalError() }
        print(profile)
        return nil
    }
}
