#
#  Be sure to run `pod s lint Multipay.pods' to ensure this is a
#  valid s and to remove all comments including this before submitting the s.
#
#  To learn more about Pods attributes see https://guides.cocoapods.org/syntax/pods.html
#  To see working Podss in the CocoaPods repo see https://github.com/CocoaPods/ss/
#

Pod::Spec.new do |s|

  # ―――  s Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "Multipay"
  s.version      = "1.0.15"
  s.summary      = "A framework of Multipay"

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = "The multipay framework is a tool to make payment using multipay in your app"

  s.homepage     = "https://github.com/multinetinventiv/MultiPay-iOS-Sdk"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  s License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See https://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  # s.license      = "MIT"
  s.license = { :type => "MIT", :file => "LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  sify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  sify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  s.author             = { "inventiv" => "" }
  # Or just: s.author    = "ilkersevim"
  # s.authors            = { "ilkersevim" => "" }
   s.social_media_url   = "https://inventiv.com.tr"

  # ――― Platform sifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then sify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  # s.platform     = :ios
   s.platform     = :ios, "11.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  sify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  #s.source       = { :git => "http://EXAMPLE/Multipay.git", :tag => "#{s.version}" }
  s.source       = { :git => "https://github.com/multinetinventiv/MultiPay-iOS-Sdk", :tag => "#{s.version}" }

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  #s.source_files  = "Classes", "Classes/**/*.{h,m}"
  #s.source_files = "Multipay","Multipay/*.{h,m,swift,strings}", "Multipay/Extensions/**/*.{h,m,swift,strings}", "Multipay/Constants/**/*.{h,m,swift,strings}, Multipay/Constants/*.{h,m,swift,strings}"
  s.source_files = "Multipay","Multipay/*.{h,m,swift,strings}", "Multipay/**/*.{h,m,swift,strings}"
  s.exclude_files = "Multipay/Exclude"

  # s.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SnapKit"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podss
  #  you can include multiple dependencies to ensure it works.

  # s.requires_arc = true

  #s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

  # s.xcconfig = { 'FRAMEWORK_SEARCH_PATHS' => '$(SDKROOT)/Carthage/Build/iOS' }
   
  #s.static_framework = true

  #s.vendored_libraries = 'InternalFrameworks/*.{a,swiftmodule,bundle}'

  s.xcconfig = { 'IPHONEOS_DEPLOYMENT_TARGET' => '11.0' }

  s.xcconfig = { 'ENABLE_BITCODE' => 'NO' }

  #s.xcconfig = { 'SWIFT_INCLUDE_PATHS' => '$(PODS_TARGET_SRCROOT)/InternalFrameworks' }

  s.resource_bundle            = { "Multipay" => 'Multipay/Resources/**/*.{lproj,json,png,xcassets,storyboard,strings,xib,ttf,otf}' }

  s.frameworks                     = 'Foundation', 'Security', 'UIKit'

  s.dependency 'SnapKit', '~> 5.0.0'
  s.dependency 'SwiftMessages', '~> 8.0.2'
  s.dependency 'KeychainAccess'
  s.dependency 'SDWebImage'
  s.dependency 'NVActivityIndicatorView'
  s.dependency 'SwiftyJSON', '~> 4.0'
  s.dependency 'XCGLogger', '~> 7.0.0'
  s.dependency 'PopupDialog', '1.1.0'
  s.dependency 'Alamofire', '~> 5.2'

  s.swift_version = "5.0"

end
