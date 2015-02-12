Pod::Spec.new do |s|
  s.name     = 'DLBCatalog'
  s.version  = '0.1.0'
  s.license  = 'Proprietary'
  s.summary  = 'A collection of proprietary UI components used in D·Labs projects.'
  s.homepage = 'https://github.com/dlabs/DLBCatalog'
  s.authors  = { 'Dal Rupnik' => 'legoless@gmail.com', 'Matic Oblak' => 'maticoblaksm@gmail.com', 'Urban Puhar' => 'urban.puhar@gmail.com' }
  s.source   = { :git => 'https://github.com/dlabs/DLBCatalog.git', :tag => s.version }
  s.requires_arc = true
  s.platform     = :ios, '7.0'

  s.ios.deployment_target = '7.0'

  s.subspec 'Core' do |ss|
    ss.source_files = 'UI Catalog/DLB/Custom UI Components/Tools/**/*.{h,m}'
  end

  s.subspec 'BarGraph' do |ss|
    ss.dependency 'DLBCatalog/Core'
    ss.source_files = 'UI Catalog/DLB/Custom UI Components/Base/Bar graph/**/*.{h,m}'
  end

  s.subspec 'CircularProgress' do |ss|
    ss.dependency 'DLBCatalog/Core'
    ss.source_files = 'UI Catalog/DLB/Custom UI Components/Base/Circular progress view/**/*.{h,m}'
  end

  s.subspec 'MediaRecorder' do |ss|
    ss.dependency 'DLBCatalog/Core'
    ss.source_files = 'UI Catalog/DLB/Custom UI Components/Base/Media recorder/**/*.{h,m}'
  end

  s.subspec 'NumericCounter' do |ss|
    ss.dependency 'DLBCatalog/Core'
    ss.source_files = 'UI Catalog/DLB/Custom UI Components/Base/Numeric counter/**/*.{h,m}'
  end

  s.subspec 'PieChart' do |ss|
    ss.dependency 'DLBCatalog/Core'
    ss.source_files = 'UI Catalog/DLB/Custom UI Components/Base/Pie chart view/**/*.{h,m}'
  end

  s.subspec 'PulseGraph' do |ss|
    ss.dependency 'DLBCatalog/Core'
    ss.source_files = 'UI Catalog/DLB/Custom UI Components/Base/Pulse graph view/**/*.{h,m}'
  end
end