// 4.2. Sending Rays Into the Scene
// Image 2: A blue-to-white gradient depending on ray Y coordinate
import Cocoa
import PlaygroundSupport

// The camera is presumed to be at (0, 0, 0)
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
