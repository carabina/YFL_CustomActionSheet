
Pod::Spec.new do |s|

  s.name         = "YFLCustomActionSheet"

  s.version      = "1.0.0"

  s.summary      = "an simple actionsheet"

   s.description  = <<-DESC
              第一个podspec
                   DESC

  s.homepage     = "https://github.com/CoderYangFeiLong/YFL_CustomActionSheet"

  s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.author       = { "CoderYangFeiLong" => "390151825@qq.com" }

  s.platform     = :ios,'8.0'

  s.source       = { :git => "https://github.com/CoderYangFeiLong/YFL_CustomActionSheet.git", :tag => "1.0.0" }

  s.source_files  = "YFLCustomActionSheet/*.{h,m}"

  s.frameworks = "UIKit", "Foundation"

  s.requires_arc = true


end
