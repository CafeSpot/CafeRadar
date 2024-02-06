//
//  StoreModel.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/2/1.
//

import Foundation

@Observable
class StoreModel{
    var storeBuffer: [Store]
    var storeCollection: [Store]
    var types: [String] = ["空位", "插座", "不限時", "讀書", "供應正餐", "音樂", "戶外"]
    
    init() {
        self.storeBuffer = []
        self.storeCollection = []
        self.initLoad()
    }
    
    func initLoad(){
        self.storeBuffer = testStores
        self.storeCollection = testStores
    }
    
    //request googlemapAPI-nearbySearch and set the result to the storeBuffer
    func searchText(text: String){
        storeBuffer = Array(storeBuffer.prefix(2))
    }
}






