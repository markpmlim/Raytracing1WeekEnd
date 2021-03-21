// 2. Output an image
// Instead of creatingd a ppm file, we generate an instance of CGImage.
// Image 1: First Core Graphics image
import Cocoa
import PlaygroundSupport

guard let cgImage = generateCGImage()
else {
    fatalError("Failed to instantiate an image")
}
let nsImage = NSImage(cgImage: cgImage,
                      size: NSZeroSize)
let size = nsImage.size
let frame = NSRect(x: 0, y: 0,
                   width: size.width, height: size.height)
let view = NSImageView(frame: frame)
view.image = nsImage
PlaygroundPage.current.liveView = view
