//
//  responseModel.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/8/29.
//

import Foundation

struct Response: Decodable{
    var nextToken: Int?
    var data: [Store]
}
