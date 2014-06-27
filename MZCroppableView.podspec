Pod::Spec.new do |s|
  s.name         = "MZCroppableView"
  s.version      = "0.0.1"
  s.summary      = "MZCroppableView is a subclass of UIView that helps in irregular image cropping."

  s.description  = <<-DESC
	A subclass of UIView that helps in custom image crops with shapes defined by
	user touch drawing. User-drawn crop paths are smoothed automatically by line 
	interpolation, and crops are taken from the smoothed path.
                   DESC

  s.homepage     = "https://github.com/CellyApp/MZCroppableView"
  s.license      = "MIT" 
  s.author       = { "Celly" => "support@cel.ly" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/CellyApp/MZCroppableView.git", :tag => "0.0.2" }
  s.source_files  = "MZCroppableView/Classes/*.{h,m}"
  s.exclude_files = "MZCroppableView/Classes/cropping_smaple.JPG"
  s.frameworks = "Foundation", "CoreGraphics"
  s.requires_arc = true
end
