//
//  responseModel.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/8/29.
//

import Foundation

struct Response_store: Decodable{
    var nextToken: Int?
    var data: [Store]
}

struct Response_user: Decodable{
    var data: User
}

struct Response_favCafeIds: Decodable{
    var data: [String]
}
