# Uncomment the next line to define a global platform for your project
 platform :ios, '14.2'

target 'VisualBooking' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  # Ignore all warning from all pods
  inhibit_all_warnings!
  # Pods for VisualBooking
  pod 'Macaw', :git => 'https://github.com/sluzhynskyi/Macaw.git', :branch => 'NodeImprove'
  pod 'MultiSlider', :git => 'https://github.com/sluzhynskyi/MultiSlider.git', :branch => 'DateSlider'
  pod 'Firebase/Analytics'
  pod 'Firebase/Firestore'
  pod 'Firebase/Auth'
  pod 'FlagPhoneNumber'
  pod 'PinCodeTextField'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
