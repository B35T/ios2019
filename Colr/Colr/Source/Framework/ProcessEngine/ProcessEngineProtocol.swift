//
//  ProcessEngineProtocol.swift
//  Colr
//
//  Created by chaloemphong on 12/4/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

public protocol ProcessEngineProtocal: class {
    var profile: ProcessEngineProfileModel? { get set }
    var delegate: ProcessEngineDelegate? { get set }
    func process() -> UIImage?
}
