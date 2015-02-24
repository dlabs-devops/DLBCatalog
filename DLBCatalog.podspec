Pod::Spec.new do |s|
  s.name     = 'DLBCatalog'
  s.version  = '0.1.1'
  s.license  = 'Proprietary'
  s.summary  = 'A collection of proprietary UI components used in D·Labs projects.'
  s.homepage = 'https://github.com/dlabs/DLBCatalog'
  s.authors  = { 'Dal Rupnik' => 'legoless@gmail.com', 'Matic Oblak' => 'maticoblaksm@gmail.com', 'Urban Puhar' => 'urban.puhar@gmail.com' }
  s.source   = { :git => 'https://github.com/dlabs/DLBCatalog.git', :tag => s.version }
  s.requires_arc = true
  s.platform     = :ios, '7.0'

  s.ios.deployment_target = '7.0'

  s.subspec 'Core' do |ss|
    ss.source_files = 'DLBCatalog/DLB/Components/Tools/**/*.{h,m}'
  end

  s.subspec 'BarGraph' do |ss|
    ss.dependency 'DLBCatalog/Core'
    ss.source_files = 'DLBCatalog/DLB/Components/Base/BarGraph/**/*.{h,m}'
  end

  s.subspec 'CircularProgress' do |ss|
    ss.dependency 'DLBCatalog/Core'
    ss.source_files = 'DLBCatalog/DLB/Components/Base/CircularProgress/**/*.{h,m}'
    ss.resources = 'DLBCatalog/DLB/Components/Base/CircularProgress/**/*.{xib}'
  end

  s.subspec 'LineGraph' do |ss|
    ss.dependency 'DLBCatalog/Core'
    ss.source_files = 'DLBCatalog/DLB/Components/Base/LineGraph/**/*.{h,m}'
  end

  s.subspec 'MediaRecorder' do |ss|
    ss.dependency 'DLBCatalog/Core'
    ss.source_files = 'DLBCatalog/DLB/Components/Base/MediaRecorder/**/*.{h,m}'
  end

  s.subspec 'NumericCounter' do |ss|
    ss.dependency 'DLBCatalog/Core'
    ss.source_files = 'DLBCatalog/DLB/Components/Base/NumericCounter/**/*.{h,m}'
  end

  s.subspec 'StarView' do |ss|
    ss.dependency 'DLBCatalog/Core'
    ss.source_files = 'DLBCatalog/DLB/Components/Base/StarView/**/*.{h,m}'
  end

  s.subspec 'PieChart' do |ss|
    ss.dependency 'DLBCatalog/Core'
    ss.source_files = 'DLBCatalog/DLB/Components/Base/PieChart/**/*.{h,m}'
    ss.resources = 'DLBCatalog/DLB/Components/Base/PieChart/**/*.{xib}'
  end

  s.subspec 'ProgressBar' do |ss|
    ss.dependency 'DLBCatalog/Core'
    ss.source_files = 'DLBCatalog/DLB/Components/Base/ProgressBar/**/*.{h,m}'
  end

  s.subspec 'PulseGraph' do |ss|
    ss.dependency 'DLBCatalog/Core'
    ss.source_files = 'DLBCatalog/DLB/Components/Base/PulseGraph/**/*.{h,m}'
  end
end