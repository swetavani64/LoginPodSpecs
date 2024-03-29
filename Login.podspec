Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '12.0'
s.name = "Login"
s.summary = "Login screen"
s.requires_arc = true

# 2
s.version = "0.1.1"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
s.author = { "Sweta Vani" => "sweta.vani@brainvire.com" }

# 5 - Replace this URL with your own GitHub page's URL (from the address bar)
s.homepage = "https://github.com/swetavani64/LoginPodSpecs"

# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/swetavani64/LoginPodSpecs.git", 
             :tag => "#{s.version}" }

# 7
s.framework = "UIKit"
s.dependency 'Alamofire'
s.dependency 'SVProgressHUD'

# 8
s.source_files = "Login/**/*.{swift}"

# 9
s.resources = "Login/**/*.{pdf,storyboard,xcassets}"

# 10
s.swift_version = "5"

end
