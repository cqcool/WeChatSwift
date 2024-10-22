platform:ios, '13.0'
source 'https://github.com/aliyun/aliyun-specs.git'

use_frameworks!

target 'WeChatSwift' do
  
#  pod 'WXNavigationBar'
#pod 'WXNavigationBar', :git => 'https://github.com/yuyedaidao/WXNavigationBar.git'
  pod 'WXActionSheet'
  pod 'WXGrowingTextView'
  pod 'MMKV'
  pod 'WCDB.swift'
  pod 'Texture'
  pod 'SSZipArchive'
  pod 'PINRemoteImage'
    
  pod 'FLEX', :configurations => ['Debug']
    
  pod 'SVGKit', :path => 'DevelopmentPods/SVGKit'
  pod 'SFVideoPlayer', :path => 'DevelopmentPods/SFVideoPlayer'
  pod 'SnapKit', '~> 5.6.0'
  pod 'ZLPhotoBrowser'
  pod 'YTKNetwork'
  
  pod 'KeenKeyboard', :git => 'https://github.com/cqcool/KeenKeyboard.git'
  
  pod 'MJExtension'
  pod 'MBProgressHUD'
  pod 'Masonry'
  
  pod 'SwiftyJSON', '~> 4.0'
#  pod 'AliyunOSSiOS'
#  pod 'AliyunOSSSwiftSDK'
#  pod 'KLCPopup'
#  pod 'SDWebImage', '5.10.2'
#  pod 'MBProgressHUD', '1.1.0'
end

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end
  end
end
