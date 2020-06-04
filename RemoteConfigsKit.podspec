Pod::Spec.new do |s|

  s.name             = 'RemoteConfigsKit'
  s.version          = '0.1.0'
  s.summary          = 'RemoteConfigs extensions.'
  s.swift_version    = '5.0'
  s.description      = 'RemoteConfigs module and extensions.'
  s.homepage         = 'https://github.com/bocato/RemoteConfigsKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'bocato' => 'dubocato@gmail.com' }
  s.source           = { :git  => 'https://github.com/bocato/RemoteConfigsKit', :tag => s.version.to_s }

  s.platform         = :ios, '10.0'
  s.static_framework = true

  s.source_files = 'RemoteConfigsKit/Sources/**/*'
  s.exclude_files = 'RemoteConfigsKit/Resources/*.plist'

  # Internal Dependencies
  s.dependency 'RemoteConfigsKitInterface'
  
  # Third Party Dependencies
  s.dependency 'Firebase'
  s.dependency 'Firebase/RemoteConfig'

  s.test_spec 'Tests' do |test_spec|

    test_spec.source_files = 'RemoteConfigsKitTests/**/*'
    test_spec.exclude_files = 'RemoteConfigsKitTests/Resources/*.plist'

    # Third Party Dependencies
    
  end

end
