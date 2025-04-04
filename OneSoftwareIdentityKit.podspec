Pod::Spec.new do |s|

  s.name         = "OneSoftwareIdentityKit"
  s.version      = "1.15.0"
  s.source       = { :git => "https://github.com/1SoftwareCompany/#{s.name}.git", :tag => "#{s.version}" }
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = "Milen Halachev"
  s.summary      = "OAuth2 and OpenID connect iOS Protocol Oriented Swift client library."
  s.homepage     = "https://github.com/1SoftwareCompany/#{s.name}"

  s.swift_version = "6.0"
  s.ios.deployment_target = "13.0"
  s.osx.deployment_target = "11.0"
  #s.watchos.deployment_target = "6.0"
  s.tvos.deployment_target = "13.0"

  s.source_files  = "#{s.name}/**/*.swift", "#{s.name}/**/*.{h,m}"
  s.public_header_files = "#{s.name}/**/*.h"

  s.ios.exclude_files = "#{s.name}/**/macOS/*.swift", "#{s.name}/**/tvOS/*.swift", "#{s.name}/**/watchOS/*.swift"
  s.osx.exclude_files = "#{s.name}/**/iOS/*.swift", "#{s.name}/**/tvOS/*.swift", "#{s.name}/**/watchOS/*.swift"
  s.tvos.exclude_files = "#{s.name}/**/iOS/*.swift", "#{s.name}/**/macOS/*.swift", "#{s.name}/**/watchOS/*.swift"
  #s.watchos.exclude_files = "#{s.name}/**/iOS/*.swift", "#{s.name}/**/macOS/*.swift", "#{s.name}/**/tvOS/*.swift"

end
