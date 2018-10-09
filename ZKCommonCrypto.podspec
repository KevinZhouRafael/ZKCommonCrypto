Pod::Spec.new do |s|
  s.name         = "ZKCommonCrypto"
  s.version      = "0.1.0"
  s.summary      = "A simple cryptographic tool."
  s.description  = <<-DESC
  This project is only contains CommonCrypto.
You can get md5 from file:
NSString *fileMd5 = [ZKCrypto fileMD5WithPath:@"filePath"];.
                     DESC
  s.homepage     = "https://github.com/KevinZhouRafael/ZKCommonCrypto"
  s.license      = 'MIT'
  s.author       = { 'zhoukai' => 'wumingapie@gmail.com' }
  s.source       = { :git => "https://github.com/KevinZhouRafael/ZKCommonCrypto.git", :tag => s.version.to_s  }
  s.ios.deployment_target = '8.0'
  s.source_files = 'ZKCommonCrypto/**/*.{h,m}'
  s.public_header_files = 'ZKCommonCrypto/**/*.h'
end


  
