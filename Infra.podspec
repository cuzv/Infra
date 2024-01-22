Pod::Spec.new do |spec|
  spec.name                           = "Infra"
  spec.version                        = "1.0.2"
  spec.summary                        = "Useful functionally extensions for iOS development."
  spec.homepage                       = "https://github.com/cuzv/Infra"
  spec.license                        = "MIT"
  spec.author                         = { "Shaw" => "cuzval@gmail.com" }
  spec.ios.deployment_target          = "12.0"
  spec.osx.deployment_target          = "10.13"
  # spec.watchos.deployment_target      = "4.0"
  # spec.tvos.deployment_target         = "12.0"
  # spec.visionos.deployment_target     = "1.0"
  spec.source                         = { :git => "https://github.com/cuzv/Infra.git", :tag => "#{spec.version}" }
  spec.source_files                   = "Sources/**/*.swift"
  spec.requires_arc                   = true
  spec.swift_versions                 = '5'
end
