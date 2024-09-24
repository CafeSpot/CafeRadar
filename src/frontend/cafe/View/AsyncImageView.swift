//
//  AsuncImageView.swift
//  cafe
//
//  Created by henry on 2024/9/18.
//

import SwiftUI

extension URLSession{
    static let imageSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.urlCache = URLCache(memoryCapacity: 50 * 1024 * 1024,diskCapacity: 100 * 1024 * 1024)
        return .init(configuration: config)
    }()
}

enum AsyncImageError: Error, LocalizedError {
    case invalidURL
    case failedToLoadImage

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided is invalid."
        case .failedToLoadImage:
            return "Failed to load the image."
        }
    }
}

struct AsyncImageView: View {
    @State private var phase : AsyncImagePhase
    var urlRequest : URLRequest?
    var session : URLSession = .imageSession
    var idToken: String?
    
    init(url: String, idToken: String? = nil, session: URLSession = .imageSession) {
        self.session = session
        self.urlRequest = nil
        self.idToken = idToken
        
        if let url  = URL(string: url){
            self.urlRequest = URLRequest(url: url)
            if let idToken = idToken{
                self.urlRequest?.httpMethod = "GET"
                if let idToken = self.idToken{
                    self.urlRequest?.setValue("Bearer \(String(describing: idToken))", forHTTPHeaderField: "Authorization")
                }
            }
        }else{
            self.urlRequest = nil
        }
        
        if let urlRequest = self.urlRequest{
            if let data = session.configuration.urlCache?.cachedResponse(for: urlRequest)?.data,
               let uiImage = UIImage(data: data) {
                _phase = .init(wrappedValue: .success(.init(uiImage: uiImage)))
            } else {
                _phase = .init(wrappedValue: .empty)
            }
        } else{
            _phase = .init(wrappedValue: .failure(AsyncImageError.invalidURL))
        }
    }
    
    var body: some View {
        Group{
            switch phase {
            case .empty:
                ProgressView().scaleEffect(3)
                    .task { await load() }
            case .success(let image):
                image.resizable().scaledToFit()
            case .failure:
                Text("圖片無法顯示")
            @unknown default:
                fatalError("This has not been implemented.")
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func load() async{
        do{
            if let urlRequest = urlRequest{
                let (data, response) = try await self.session.data(for: urlRequest)
                guard let response = response as? HTTPURLResponse,
                      200...299 ~= response.statusCode,
                      let uiImage = UIImage(data: data)
                else {
                    throw URLError(.unknown)
                }
                
                phase = .success(Image(uiImage: uiImage))
            } else{
                throw URLError(.unknown)
            }
        } catch{
            phase = .failure(AsyncImageError.failedToLoadImage)
        }
    }
}


#Preview {
    AsyncImageView(url: "https://images.unsplash.com/photo-1678880032033-d954b408963c")
}

