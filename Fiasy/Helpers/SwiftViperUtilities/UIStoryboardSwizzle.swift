//
//  UIStoryboardSwizzle.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 8/26/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import Swinject
import SwinjectStoryboard
import ObjectiveC.runtime

@objc protocol SwinjectInitAssembler {
    init()
}

private func objc_getClassList() -> [AnyClass] {
    let expectedClassCount = objc_getClassList(nil, 0)
    let allClasses = UnsafeMutablePointer<AnyClass?>.allocate(capacity:Int(expectedClassCount))
    let autoreleasingAllClasses = AutoreleasingUnsafeMutablePointer<AnyClass>(allClasses)
    let actualClassCount:Int32 = objc_getClassList(autoreleasingAllClasses, expectedClassCount)
    
    var classes = [AnyClass]()
    for i in 0 ..< actualClassCount {
        if let currentClass: AnyClass = allClasses[Int(i)] {
            if checkIfClassIsInitialAssembly(assemblyClass: currentClass) {
                classes.append(currentClass)
            }
        }
    }
    allClasses.deallocate()
    
    return classes
}

private func checkIfClassIsInitialAssembly(assemblyClass:AnyClass) -> Bool {
    return class_conformsToProtocol(assemblyClass, SwinjectInitAssembler.self)
}

let assembler = commonAssembler()

private func commonAssembler() -> Assembler {
    
    var arrayAssembly = [Assembly]()
    
    let classes = objc_getClassList()
    
    for oneClass in classes {
        let object = (oneClass as! SwinjectInitAssembler.Type).init()
        arrayAssembly.append(object as! Assembly)
    }
    
    return try! Assembler(assemblies: arrayAssembly)
}
