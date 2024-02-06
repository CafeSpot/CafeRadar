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
    var types: [String] = ["class_a", "class_b", "class_c", "class_d", "class_e",]
    
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






