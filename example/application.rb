require 'PresentationFramework'
require 'PresentationCore'
require 'view_model'

window = System::Windows::Markup::XamlReader.parse(File.open('window.xaml', 'r').read)
view_model = ViewModel.new
window.data_context = view_model
System::Windows::Application.new.run(window)

