Pod::Spec.new do |spec|
  spec.name             = "Infra"
  spec.version          = "1.0.1"
  spec.summary          = "Useful functionally extensions for iOS development."
  spec.homepage         = "https://github.com/cuzv/Infra"
  spec.license          = "MIT"
  spec.author           = { "Shaw" => "cuzval@gmail.com" }
  spec.platform         = :ios, "12.0"
  spec.source           = { :git => "https://github.com/cuzv/Infra.git", :tag => "#{spec.version}" }
  spec.source_files     = "Sources/**/*.swift"
  spec.requires_arc     = true
  spec.swift_versions   = '5'
end
