source 'https://github.com/CocoaPods/Specs'

use_frameworks!
#inhibit_all_warnings!

platform :ios, '8.0'

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end

target "cmallcms" do
    pod 'ClusterPrePermissions', '~> 0.1'
    pod 'JDStatusBarNotification', '~> 1.5.3'
    pod 'WebViewJavascriptBridge', '~> 5.0.5'
    pod 'Masonry'
    pod 'SDWebImage', '~> 3.8.2'
    
    pod 'AFNetworking', '~> 3.1.0'
    pod 'IQKeyboardManager', '~> 4.0.6'
    
    pod 'ObjectMapper', '~> 2.2'
    pod 'XCGLogger', '~> 5.0.1'
    
    pod 'UMengAnalytics-NO-IDFA'
    pod 'DateToolsSwift'
    
    #pod 'AMapLocation-NO-IDFA'
    #pod 'AMap3DMap-NO-IDFA', '~> 4.6.1'
    #pod 'AMapSearch-NO-IDFA', '~> 4.5.0'
    pod 'MBProgressHUD', '~> 1.0.0'
    
    pod 'EZSwiftExtensions' #Stable release for Swift 3.0
    #pod 'KMNavigationBarTransition'
    #pod 'RAMAnimatedTabBarController', "~> 2.0.13"
    pod 'DZNEmptyDataSet'
    pod 'MJRefresh'
    pod 'ESTabBarController-swift'
    
    pod 'TYAttributedLabel', '~> 2.6.2'
    
    pod 'IGListKit', '~> 3.0'
    pod 'JSQWebViewController'
    pod 'SKPhotoBrowser'
    pod 'SVProgressHUD'
    
    pod 'EFQRCode', '~> 1.2.5'
    pod 'DTCoreText', '~> 1.6.20'
    #pod 'arek', '~> 1.3.1'
    #pod 'Harpy'
    #pod 'IDMPhotoBrowser'
    #pod 'Segmentio', '~> 2.1'
end
