
Pod::Spec.new do |s|
  s.name         = "EasyRecord"
  s.version      = "1.0.1"
  s.summary      = "A shorthand tool for Core Data."
  s.homepage     = "https://github.com/frankmoney/EasyRecord"
  s.license      = 'MIT'

  s.author       = { 
    "Rinat Murtazin" => "rinat@frank.money" 
  }

  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'
  s.osx.deployment_target = '10.7'

  s.social_media_url = 'http://frank.money'
  s.source       = { 
    :git => "https://github.com/frankmoney/EasyRecord.git", 
    :tag => s.version.to_s
  }

  s.source_files = '*.{h,m}'
  s.requires_arc = true
  s.framework  = 'CoreData'
end