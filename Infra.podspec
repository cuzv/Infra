Pod::Spec.new do |s|
  s.name                           = "Infra"
  s.version                        = "1.0.2"
  s.summary                        = "Useful functionally extensions for iOS development."
  s.homepage                       = "https://github.com/cuzv/Infra"
  s.license                        = "MIT"
  s.author                         = { "Shaw" => "cuzval@gmail.com" }
  
  s.ios.deployment_target          = "12.0"
  s.osx.deployment_target          = "10.13"
  # s.watchos.deployment_target      = "4.0"
  # s.tvos.deployment_target         = "12.0"
  # s.visionos.deployment_target     = "1.0"
  
  s.source                         = { :git => "https://github.com/cuzv/Infra.git", :tag => "#{s.version}" }
  s.source_files                   = "Sources/**/*.swift"
  s.requires_arc                   = true
  s.swift_versions                 = '5'
  
  s.resource_bundles = {
    'Infra' => ['Resources/PrivacyInfo.xcprivacy']
  }
end
