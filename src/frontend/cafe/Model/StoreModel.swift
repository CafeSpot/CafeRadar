//
//  StoreModel.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/2/1.
//

import Foundation
import CoreLocation
import GoogleMaps

@Observable
class StoreModel{
    var position: CLLocation?
    var idToken: String?
    
    // [class setting]
    let bufferSize = 100
    
    // [data from server] - global
    var storeBuffer: [Store]
    var recommends: [Recommend]
    var typeNames: [String]
    
    
    // [maintain data]
    var storeCollection: [Store] { self.storeBuffer.filter { self.filtStore_selection(store: $0) } }  // the set of the store show on the map page and the command page
    var storeMap: [Store] { self.storeBuffer.filter { self.filtStore_selection(store: $0) } }
    var selectionText: String = ""  // keyword to search
    var selectionsType: [Bool] = []  // key type to search
    var selectedDistance: Double = 10000
    
    //init() {
    init() {
        self.storeBuffer = []
        self.recommends = []
        self.typeNames = []
        
        self.initLoad()
    }
    
    // [modify] modify to the google map api or ours in the future !!!
    // the method request the recommend store info from the server, with info user_position, user_id, user_favor...
    func initLoad(){
        self.storeBuffer = testStores
        self.recommends = testRecommends
        self.typeNames = testTypeNames
        
        self.selectionsType = Array(repeating: true, count: self.typeNames.count)
        print("get the ",self.storeBuffer.count," stores from the test data")
    }
    
    func update_idToken(idToken: String?){
        if self.idToken == nil{
            self.idToken = idToken
            
            self.get_store()
            self.get_recommand()
        } else {
            self.idToken = idToken
        }
    }

    func update_position(position: CLLocation?) {
        self.position = position
        
        if let position = self.position {
            print("[StoreModel - Current Location]: Latitude: \(position.coordinate.latitude), Longitude: \(position.coordinate.longitude), distance:\(selectedDistance)")
        }
        
        self.get_store()
        self.get_recommand()
    }
    
    func reset_searchCondition(){
        self.selectionText = ""  // keyword to search
        self.selectionsType = Array(repeating: true, count: self.typeNames.count)
        self.selectedDistance = 10000
    }
    
    func searchText(text: String){
        storeBuffer = Array(storeBuffer.prefix(2))
    }
    
    func get_store(){
        var lat: Double = 24.8138
        var lon: Double = 120.9675
        
        if let position = self.position {
            lat = position.coordinate.latitude
            lon = position.coordinate.longitude
        }
        
        guard let url = URL(string: "http://127.0.0.1:8000/cafe/search?lon=\(lon)&lat=\(lat)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let idToken = self.idToken{
            request.setValue("Bearer \(String(describing: idToken))", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(Response_store.self, from: data)
                    
                    // Update the UI on the main thread
                    DispatchQueue.main.async {
                        self.storeBuffer = decodedData.data
                        print("Data received and decoded: \(self.storeBuffer.count)")
                    }
                } catch {
                    print("Error decoding get_store data: \(error)")
                }
            }
        }.resume()
    }
    
    func get_recommand(){
        var lat: Double = 24.8138
        var lon: Double = 120.9675
        
        if let position = self.position {
            lat = position.coordinate.latitude
            lon = position.coordinate.longitude
        }
        
        guard let url = URL(string: "http://127.0.0.1:8000/cafe/recommand?lon=\(lon)&lat=\(lat)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let idToken = self.idToken{
            request.setValue("Bearer \(String(describing: idToken))", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(Response_recommands.self, from: data)
                    
                    // Update the UI on the main thread
                    DispatchQueue.main.async {
                        self.recommends = decodedData.data
                        print("recommends received and decoded: \(self.recommends.count)")
                        print("recommends received and decoded: \(self.recommends[0].cafes.count)")
                    }
                } catch {
                    print("Error decoding get_recommand data: \(error)")
                }
            }
        }.resume()
    }

    
    // this method is the filter function which return if the "store" is correspond the selected conditions
    func filtStore_selection(store: Store) -> Bool{
        var ansText: Bool = false
        var ansType: Bool = false
        var ansDistance: Bool = false
        
        ansText = selectionText=="" ? true : store.name.contains(selectionText)
        

        //type filter design?
        for index in typeNames{
            if(store.tags.contains(index)){
                ansType = true
                break
            }
        }


        if let position = self.position{
            let location1 = CLLocation(latitude: position.coordinate.latitude, longitude:position.coordinate.longitude)
            let location2 = CLLocation(latitude: store.lat, longitude: store.lon)
            ansDistance = location1.distance(from: location2) < selectedDistance ? true : false
        }else{
            ansDistance = true
        }
        
        return ansText && ansType && ansDistance
    }
    
}






