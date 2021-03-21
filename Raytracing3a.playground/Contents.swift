// 3. The vec3, point3 and color Classes
// Use typealiases to declare the vector types
//      vec3, color and point3.
// Built-in functions will be used wherever possible.
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
