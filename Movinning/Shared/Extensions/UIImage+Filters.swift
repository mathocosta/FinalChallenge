//
//  UIImage+Filters.swift
//  Movinning
//
//  Created by Martônio Júnior on 04/12/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import CoreImage
import UIKit

extension UIImage {
    func noSaturation() -> UIImage {
        let currentImage = self
        guard let startImage = CIImage(image: currentImage) else { return UIImage() }
        var context = CIContext()
        var filter = CIFilter(name: "CIColorMonochrome")
        filter.setValue(startImage, for: kCIInputImageKey)
        filter.setValue(UIColor.gray.ciColor, for: kCIInputColorKey)
        filter.setValue(1.0, for: kCIInputIntensityKey)

        guard let image = filter.outputImage else { return }
        if let cgimg = context.createCGImage(image, from: image.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            return processedImage
        }
        return image
    }
}
