platform :ios, '11.0'

inhibit_all_warnings!

target 'getty' do
    pod 'SwiftLint', '0.31.0'

    target 'gettyTests' do
        inherit! :search_paths
    end
end

post_install do |installer|

    puts 'Determining pod project minimal deployment target'

    pods_project = installer.pods_project
    deployment_target_key = 'IPHONEOS_DEPLOYMENT_TARGET'
    deployment_targets = pods_project.build_configurations.map{ |config| config.build_settings[deployment_target_key] }
    minimal_deployment_target = deployment_targets.min_by{ |version| Gem::Version.new(version) }

    puts 'Minimal deployment target is ' + minimal_deployment_target
    puts 'Setting each pod deployment target to ' + minimal_deployment_target

    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings[deployment_target_key] = minimal_deployment_target
        end
    end
end
