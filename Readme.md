This set of Swift Playgrounds are developed by porting the C/C++ code from Peter Shirley's Book "Ray Tracing in One Weekend"

All demos were successfully ported to Swift playgrounds.

The primary data type Double and its vector type double3 will be used in this set of playgrounds. There is little need to port the functions and operators of the C++ implementation of the vec3 class as described in Peter Shirley's Book.

Functions like normalize, refract, reflect, length_squared, etc are available in Swift and these operates in SIMD mode.

The set begins with Raytracing2a.playground and ends with RayTracingCover.playground. To help the reader, an image number is listed on the main page of each playground

With the exception of the first 2 playgrounds, the CGImage object created by the function generateCGImage() can be viewed by clicking on the "Show Result" or the "QuickLook" button. The method generateCGImage() is the main function in all the playgrounds and is declared with the keyword "public" so it can be called from the main program.


Credits: Marius Horga for showing the way.


Runtime requirements: Xcode 9.1 or later 

System requirements: macOS 10.13 or later



Links:

https://github.com/RayTracing/raytracing.github.io

http://metalkit.org
