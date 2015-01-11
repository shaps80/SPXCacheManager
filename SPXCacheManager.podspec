Pod::Spec.new do |s|
  s.name             = "SPXCacheManager"
  s.version          = "0.1.0"
  s.summary          = "A highly configurable and reusable library for handling caching in your iOS apps. Not only for images!!"
  s.homepage         = "https://github.com/shaps80/SPXCacheManager"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"

  s.license          = 'MIT'
  s.author           = { "Shaps Mohsenin" => "shapsuk@me.com" }
  s.source           = { :git => "https://github.com/shaps80/SPXCacheManager.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/shaps'
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.source_files = 'Pod/Classes/**/*.h'
end
