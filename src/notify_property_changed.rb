require 'PresentationFramework'
require 'PresentationCore'
=begin

Implements INotifyPropertyChanged and lets the including class define
properties which fire PropertyChanged events when changed by using an
attr_accessor style syntax.

Usage:

class MyViewModel
  include NotifyPropertyChanged

  property_changed_attr_accessor :property1, :property2, :property3
end

Remarks:
No initialization is needed (i.e. calling super in the initializer), the module
takes care of itself.
Also, there is no need to extend the module to get the property_changed_attr_accessor
since the module makes the class extend when it includes the module.

=end

module NotifyPropertyChanged
  include System::ComponentModel::INotifyPropertyChanged

  module ClassMethods
    def property_changed_attr_accessor(*accessors)
      accessors.each do |m|

        # define getter
        attr_reader m

        # define setter which sends notify property changed event
        define_method("#{m}=") do |val| 
          
          # add support for checking if the value is actually changed or not
          # i.e. if val == instance_variable_get("@#{m}") return

          instance_variable_set("@#{m}",val)
          notify_property_changed(m)
        end
      end
    end
  end

  # This lazy accessor removes the need for initializing the @change_handlers variable to []
  # This removes the need for the including class to call some initialization method or such
  def change_handlers
    if @change_handlers == nil
      @change_handlers = []
    end
    @change_handlers
  end

  def add_PropertyChanged(handler)
    change_handlers << handler
  end

  def remove_PropertyChanged(handler)
    change_handlers.delete(handler)
  end

  def notify_property_changed(name)
    change_handlers.each { |h| h.invoke(self, System::ComponentModel::PropertyChangedEventArgs.new(name)) }
  end

  # Extend the view model class that is including this module with the class methods defined
  # in the inner ClassMethods module. This enables the including class to get both instance methods
  # and class methods with a single include
  def self.included(cls)
    cls.extend ClassMethods
  end
end
