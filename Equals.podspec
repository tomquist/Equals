Pod::Spec.new do |s|

  s.name         = "Equals"
  s.version      = "2.0.0"
  s.summary      = "Swift µframework to reduce boilerplate code when conforming to Equatable and Hashable"

  s.description  = <<-DESC
                   Equals is a µframework that makes implementing Equatable and Hashable protocol very easy
                   by providing a little helper which allows you to simply list all of your properties to compare.
                   DESC

  s.homepage     = "https://github.com/tomquist/Equals"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = "Tom Quist"
  s.social_media_url   = "http://twitter.com/tomqueue"

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/tomquist/Equals.git", :tag => "v#{s.version}" }
  s.source_files  = "Sources/Equals/*.{h,m,swift}"
  s.public_header_files = "Sources/Equals/*.h"

end
