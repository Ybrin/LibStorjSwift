//
//  CStruct.swift
//  LibStorj
//
//  Created by Koray Koska on 30/08/2017.
//
//

import Foundation

public protocol CStruct {

    associatedtype StructType

    init(type: UnsafeMutablePointer<StructType>)

    init(type: StructType)

    func get() -> StructType
}
