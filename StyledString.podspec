Pod::Spec.new do |s|
  s.name             = "StyledString"
  s.version          = "0.7.2"
  s.summary          = "String styling in Swift"

  s.description      = <<-DESC
  Easy creation of NSAttributedStrings with Swift. 
                       DESC

  s.homepage         = "https://github.com/Q42/StyledString"
  s.license          = 'MIT'
  s.author           = { "Sander de Vos" => "sander@q42.nl" }
  s.source           = { :git => "https://github.com/Q42/StyledString.git", :tag => s.version.to_s }

  s.pod_target_xcconfig = { 'APPLICATION_EXTENSION_API_ONLY' => 'YES' }

  s.ios.deployment_target   = '8.0'
  s.tvos.deployment_target  = '9.0'
  s.swift_version           = '4.2'
  s.requires_arc            = true

  s.source_files = 'Sources/**/*'

end
