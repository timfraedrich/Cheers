Pod::Spec.new do |spec|

  spec.name         = "CheersLib"
  spec.version      = "0.1.4"
  spec.summary      = "A toast library for iOS"
  spec.description  = <<-DESC
Cheers is a highly customisable toast library for iOS written in Swift. It offers an alternate presentation style to the UIAlertViewController, by being displayed over the entire window and permitting interaction with other views while being presented.
                   DESC
  spec.homepage     = "https://github.com/timfraedrich/Cheers/"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.swift_version = '5.0'
  spec.author       = { "Tim Fraedrich" => "tim@tadris.de" }
  spec.platform     = :ios, "12.0"
  spec.ios.deployment_target = '12.0'
  spec.source       = { :git => "https://github.com/timfraedrich/Cheers.git", :tag => "#{spec.version}" }
  spec.source_files  = "Sources/Cheers/*"
  spec.frameworks = 'Foundation', 'UIKit'
  spec.dependency "SnapKit", "~> 5.0.1"
  spec.resource_bundles = { 'Cheers_Cheers' => ['Sources/Cheers/*.{xib,storyboard,xcassets}'] }

end
