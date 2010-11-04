require 'lib\GalaSoft.MvvmLight.WPF4.dll'
require '../src/notify_property_changed'

class ViewModel
  include NotifyPropertyChanged

  attr_accessor :command
  property_changed_attr_accessor :text

  def initialize
    @text = "Click this button to change the text"

    command_action = System::Action.new { 
      self.text=("You clicked the button!")
    }

    @command = GalaSoft::MvvmLight::Command::RelayCommand.new(command_action)
  end
end
