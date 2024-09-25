//
//  UserModel.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/2/1.
//

import Foundation
import CoreLocation


@Observable
class UserModel{
    var user: User = User()
    var idToken: String?
    var signedIn:Bool = false
    
    init(){
    }
    
    func update_idToken(idToken: String?){
        self.idToken = idToken
        self.signedIn = true
        self.get_user()
    }
    
    func get_user(){
        if let idToken = self.idToken{
            guard let url = URL(string: "http://127.0.0.1:8000/user/") else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode(Response_user.self, from: data)
                        
                        // Update the UI on the main thread
                        DispatchQueue.main.async {
                            self.user = decodedData.data
                        }
                    } catch {
                        print("Error decoding data: \(error)")
                    }
                }
            }.resume()
        }
    }
    
    func update_userInfo(name: String, email: String, phone: String){
        self.user.name = name
        self.user.email = email
        self.user.phone = phone
        
        guard let idToken = self.idToken else { return }
        
        guard let url = URL(string: "http://127.0.0.1:8000/user/\(self.user.userId ?? "")/update?name=\(name)&email=\(email)&phone=\(phone)") else {
            print("Invalid URL")
            return 
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request error: \(error)")
                return
            }
            
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(Response_user.self, from: data)
                    
                    DispatchQueue.main.async {
                        self.user = decodedData.data
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            }
        }.resume()
    }
    
    func update_favCafe(cafeId: String, action: String) {
        guard let idToken = self.idToken else { return }
        
        guard let url = URL(string: "http://127.0.0.1:8000/user/\(self.user.userId ?? "")/fav?action=\(action)&cafeId=\(cafeId)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request error: \(error)")
                return
            }
            
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(Response_favCafeIds.self, from: data)
                    
                    DispatchQueue.main.async {
                        self.user.favCafeIds = Set(decodedData.data)
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            }
        }.resume()
    }

    func add_favCafe(cafeId: String) {
        self.user.favCafeIds.insert(cafeId)
        if self.signedIn{
            update_favCafe(cafeId: cafeId, action: "add")
        }
    }

    func delete_favCafe(cafeId: String) {
        self.user.favCafeIds.remove(cafeId)
        if self.signedIn{
            update_favCafe(cafeId: cafeId, action: "delete")
        }
    }
}


