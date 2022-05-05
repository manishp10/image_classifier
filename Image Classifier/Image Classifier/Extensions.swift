//
//  Extensions.swift
//  firstlite
//
//  Created by Manish Patel on 25/04/2022.

/**
  Below extensions are for Resnet50 model
*/

import UIKit

extension UIImage {
    /// Resize image
    /// - Parameter size: Size to resize to
    /// - Returns: Resized image
    func resize(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    /// Create and return CoreVideo Pixel Buffer
    /// - Returns: Pixel Buffer
    func getCVPixelBuffer() -> CVPixelBuffer? {
        guard let image = cgImage else {
             return nil
        }
        let imageWidth = Int(image.width)
        let imageHeight = Int(image.height)

        let attributes : [NSObject:AnyObject] = [
            kCVPixelBufferCGImageCompatibilityKey : true as AnyObject,
            kCVPixelBufferCGBitmapContextCompatibilityKey : true as AnyObject
        ]

        var pxbuffer: CVPixelBuffer? = nil
        CVPixelBufferCreate(
            kCFAllocatorDefault,
            imageWidth,
            imageHeight,
            kCVPixelFormatType_32ARGB,
            attributes as CFDictionary?,
            &pxbuffer
        )

        if let _pxbuffer = pxbuffer {
            let flags = CVPixelBufferLockFlags(rawValue: 0)
            CVPixelBufferLockBaseAddress(_pxbuffer, flags)
            let pxdata = CVPixelBufferGetBaseAddress(_pxbuffer)

            let rgbColorSpace = CGColorSpaceCreateDeviceRGB();
            let context = CGContext(
                data: pxdata,
                width: imageWidth,
                height: imageHeight,
                bitsPerComponent: 8,
                bytesPerRow: CVPixelBufferGetBytesPerRow(_pxbuffer),
                space: rgbColorSpace,
                bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue
            )

            if let _context = context {
                _context.draw(
                    image,
                    in: CGRect.init(
                        x: 0,
                        y: 0,
                        width: imageWidth,
                        height: imageHeight
                    )
                )
            }
            else {
                CVPixelBufferUnlockBaseAddress(_pxbuffer, flags);
                return nil
            }

            CVPixelBufferUnlockBaseAddress(_pxbuffer, flags);
            return _pxbuffer;
        }

        return nil
    }
}


/**
  Below extensions are for Handwriting Recognition Model.
*/

//#if canImport(UIKit)
//
//import UIKit
//import VideoToolbox
//
//extension UIImage {
//  /**
//    Converts the image to an ARGB `CVPixelBuffer`.
//  */
//  public func pixelBuffer() -> CVPixelBuffer? {
//    return pixelBuffer(width: Int(size.width), height: Int(size.height))
//  }
//
//  /**
//    Resizes the image to `width` x `height` and converts it to an ARGB
//    `CVPixelBuffer`.
//  */
//  public func pixelBuffer(width: Int, height: Int) -> CVPixelBuffer? {
//    return pixelBuffer(width: width, height: height,
//                       pixelFormatType: kCVPixelFormatType_32ARGB,
//                       colorSpace: CGColorSpaceCreateDeviceRGB(),
//                       alphaInfo: .noneSkipFirst)
//  }
//
//  /**
//    Converts the image to a grayscale `CVPixelBuffer`.
//  */
//  public func pixelBufferGray() -> CVPixelBuffer? {
//    return pixelBufferGray(width: Int(size.width), height: Int(size.height))
//  }
//
//  /**
//    Resizes the image to `width` x `height` and converts it to a grayscale
//    `CVPixelBuffer`.
//  */
//  public func pixelBufferGray(width: Int, height: Int) -> CVPixelBuffer? {
//    return pixelBuffer(width: width, height: height,
//                       pixelFormatType: kCVPixelFormatType_OneComponent8,
//                       colorSpace: CGColorSpaceCreateDeviceGray(),
//                       alphaInfo: .none)
//  }
//
//  /**
//    Resizes the image to `width` x `height` and converts it to a `CVPixelBuffer`
//    with the specified pixel format, color space, and alpha channel.
//  */
//  public func pixelBuffer(width: Int, height: Int,
//                          pixelFormatType: OSType,
//                          colorSpace: CGColorSpace,
//                          alphaInfo: CGImageAlphaInfo) -> CVPixelBuffer? {
//    var maybePixelBuffer: CVPixelBuffer?
//    let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
//                 kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue]
//    let status = CVPixelBufferCreate(kCFAllocatorDefault,
//                                     width,
//                                     height,
//                                     pixelFormatType,
//                                     attrs as CFDictionary,
//                                     &maybePixelBuffer)
//
//    guard status == kCVReturnSuccess, let pixelBuffer = maybePixelBuffer else {
//      return nil
//    }
//
//    let flags = CVPixelBufferLockFlags(rawValue: 0)
//    guard kCVReturnSuccess == CVPixelBufferLockBaseAddress(pixelBuffer, flags) else {
//      return nil
//    }
//    defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, flags) }
//
//    guard let context = CGContext(data: CVPixelBufferGetBaseAddress(pixelBuffer),
//                                  width: width,
//                                  height: height,
//                                  bitsPerComponent: 8,
//                                  bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
//                                  space: colorSpace,
//                                  bitmapInfo: alphaInfo.rawValue)
//    else {
//      return nil
//    }
//
//    UIGraphicsPushContext(context)
//    context.translateBy(x: 0, y: CGFloat(height))
//    context.scaleBy(x: 1, y: -1)
//    self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
//    UIGraphicsPopContext()
//
//    return pixelBuffer
//  }
//}
//#endif
