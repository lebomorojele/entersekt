//
//  Models.swift
//  entersektsdk
//
//  Created by Lebo Morojele on 2019/09/18.
//  Copyright © 2019 Lebo Morojele. All rights reserved.
//

import Foundation

public protocol ListItemDescription {
    var name:String { get set }
    func items() -> (title:String, items:[ListItemDescription])?
}

public struct MockCityResponse:Codable{
    var cities:[City]
}

public struct City:Codable, ListItemDescription{
    public func items() -> (title: String, items: [ListItemDescription])? {
        return ("Malls", malls ?? [])
    }
    
    var id:Int
    public var name:String
    var malls:[Mall]?
}

public struct Mall:Codable, ListItemDescription{
    public func items() -> (title: String, items: [ListItemDescription])? {
        return ("Shops", shops ?? [])
    }
    
    var id:Int
    public var name:String
    var shops:[Shop]?
}

public struct Shop:Codable, ListItemDescription{
    public func items() -> (title: String, items: [ListItemDescription])? {
        return nil
    }
    
    var id:Int
    public var name:String
}
