Pod::Spec.new do |s|
s.name     = 'LYCustomEmoticonKeyboard'
s.version  = '2.0.0'
s.license  = 'MIT'
s.summary  = 'A custom emotion keybaord.'
s.homepage = 'https://github.com/woshishui1243/LYCustomEmoticonKeyboard'
s.authors  = { 'DaYu' => 'dayu_0518@163.com' }
s.source   = { :git => 'https://github.com/woshishui1243/LYCustomEmoticonKeyboard.git', :tag => s.version}
s.requires_arc = true

s.platform = :ios, "8.0"

s.source_files = 'Source/*'
s.resource_bundles = 'Source/*.bundle', 'Source/*.xib'

end