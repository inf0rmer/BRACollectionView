Pod::Spec.new do |s|
  s.name         = 'BRACollectionView'
  s.version      = '0.0.1'
  s.summary      = 'Reimplementation of a UITableView, because why not?'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { 'Bruno Abrantes' => 'inf0rmer.realm@gmail.com'}
  s.source       = { :git => 'https://github.com/inf0rmer/BRACollectionView.git', :tag => s.version.to_s }
  s.social_media_url = "https://twitter.com/inf0rmer"

  s.ios.deployment_target = '7.0'

  s.requires_arc = true

  s.dependency 'ObjectiveSugar', :head

  s.source_files = 'Classes', 'Classes/**/*.{h,m}'
end
