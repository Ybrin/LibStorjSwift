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

    func get() -> StructType
}
