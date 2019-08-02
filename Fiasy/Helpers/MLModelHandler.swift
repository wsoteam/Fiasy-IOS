//
//  MLModelHandler.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/11/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import Foundation
import CoreML
import UIKit

public class MLModelHandler {
    
    public init() {
        print("Initialized")
    }
    
    public func compileModel(path: URL) -> URL? {
        guard let compiledURL = try? MLModel.compileModel(at: path) else {
            print("Error in compiling model.")
            return nil
        }
        return compiledURL
    }
}
