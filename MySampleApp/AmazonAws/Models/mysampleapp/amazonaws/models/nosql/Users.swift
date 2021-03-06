//
//  Users.swift
//  MySampleApp
//
//
// Copyright 2017 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.19
//

import Foundation
import UIKit
import AWSDynamoDB

@objcMembers
class Users: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var _userId: String?
    var _active: NSNumber?
    var _cash: NSNumber?
    var _latitude: NSNumber?
    var _longitude: NSNumber?
    var _userName: String?
    
//    convenience override init() {
//        _userId = ""
//        _active = 0
//        _cash = 0
//        _latitude = 0
//        _longitude = 0
//        _userName = ""
//    }
    
    class func dynamoDBTableName() -> String {

        return "tipbucket-mobilehub-1564847731-Users"
    }
    
    class func hashKeyAttribute() -> String {

        return "_userId"
    }
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        return [
               "_userId" : "userId",
               "_active" : "active",
               "_cash" : "cash",
               "_latitude" : "latitude",
               "_longitude" : "longitude",
               "_userName" : "userName",
        ]
    }
}
