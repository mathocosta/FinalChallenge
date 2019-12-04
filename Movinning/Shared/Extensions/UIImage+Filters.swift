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
        dynamic let currentImage = self
        guard let startImage = CIImage(image: currentImage) else { return UIImage() }
        let context = CIContext()
        let filter = CIFilter(name: "CIColorMonochrome")
        filter?.setValue(startImage, forKey: "inputImage")
        filter?.setValue(CIColor(cgColor: UIColor.gray.cgColor), forKey: "inputColor")
        filter?.setValue(1.0, forKey: "inputIntensity")

        guard let image = filter?.outputImage else { return UIImage() }
        if let cgimg = context.createCGImage(image, from: image.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            return processedImage
        }
        return UIImage()
    }
}
