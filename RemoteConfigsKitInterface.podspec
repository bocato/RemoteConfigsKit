Pod::Spec.new do |s|

    s.name             = 'RemoteConfigsKitInterface'
    s.version          = '0.1.0'
    s.summary          = 'RemoteConfigs layer interface.'
    s.swift_version    = '5.0'
    s.description      = 'RemoteConfigs layer interface module.'
    s.homepage         = 'https://github.com/bocato/RemoteConfigsKit'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Hotmart' => 'dubocato@gmail.com' }
    s.source           = { :git  => 'https://github.com/bocato/RemoteConfigsKit', :tag => s.version.to_s }
  
    s.platform         = :ios, '10.0'
  
    s.source_files = 'RemoteConfigsKitInterface/**/*'
    s.exclude_files = 'RemoteConfigsKitInterface/Resources/*.plist'

    s.test_spec 'Tests' do |test_spec|

      test_spec.source_files = 'RemoteConfigsKitInterface/**/*'
      test_spec.exclude_files = 'RemoteConfigsKitInterfaceTests/Resources/*.plist'
  
      # Third Party Dependencies
      
    end
  
  end
