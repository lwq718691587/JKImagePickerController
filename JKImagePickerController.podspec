

Pod::Spec.new do |s|
s.name             = 'JKImagePickerController'
s.version          = '0.1.6'
s.summary          = '健客多图片选择器'
s.homepage         = 'https://github.com/lwq718691587/JKImagePickerController'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'liuweiqiang' => 'liuweiqiang@jianke.com' }
s.source           = { :git => 'https://github.com/lwq718691587/JKImagePickerController.git', :tag => s.version.to_s }

s.ios.deployment_target = '8.0'

s.resources    = "JKImagePickerController/Resource/*.{png,xib}"

s.source_files = 'JKImagePickerController/**/*.{h,m}'


end

