//
//  LogoView.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/8/13.
//

import SwiftUI
import WebKit

extension UIImage {
    func resize(to targetSize: CGSize) -> UIImage? {
        let size = self.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Determine the scale factor that preserves aspect ratio
        let scaleFactor = min(widthRatio, heightRatio)

        // Compute the new image size that preserves aspect ratio
        let newSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)

        // Create a new context with the target size
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: newSize))

        // Get the new image from the context
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}

struct LogoView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        var images = [UIImage]()

        for index in 0..<30 {
            if let image = UIImage(named: "logo_\(index)")?.resize(to: CGSize(width: logoSize, height: logoSize)) {
                images.append(image)
            }
        }
        imageView.animationImages = images
        imageView.animationDuration = 1.6
        imageView.animationRepeatCount = 1  // Play the animation only once
        imageView.startAnimating()

        // Set content mode to original size
        imageView.contentMode = .center
        imageView.clipsToBounds = true

    
        
        // Set the imageView's content mode
        //imageView.contentMode = .scaleAspectFit


        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {}
}


#Preview {
    LogoView()
}
