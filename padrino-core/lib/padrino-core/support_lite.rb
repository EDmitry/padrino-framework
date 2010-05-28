##
# This file loads certain extensions required by Padrino from ActiveSupport.
#
# Why use ActiveSupport and not our own library or extlib?
#
# 1) Writing custom method extensions needed (i.e string inflections) is not a good use of time.
# 2) Loading custom method extensions or separate gem would conflict when AR or MM has been loaded.
# 3) Datamapper is planning to move to ActiveSupport and away from extlib.
#
# Extensions required for Padrino:
#
#   * Class#cattr_accessor
#   * Module#alias_method_chain
#   * String#inflectors (classify, underscore, camelize, pluralize, etc)
#   * Array#extract_options!
#   * Object#blank?
#   * Object#present?
#   * Hash#slice, Hash#slice!
#   * Hash#to_params
#   * Hash#symbolize_keys, Hash.symbolize_keys!
#   * Hash#reverse_merge, Hash#reverse_merge!
#   * Symbol#to_proc
#
require 'rbconfig'
require 'active_support/version'
require 'active_support/core_ext/kernel'
require 'active_support/core_ext/module'
require 'active_support/deprecation'
require 'active_support/core_ext/class/attribute_accessors'
require 'active_support/core_ext/hash'
require 'active_support/inflector'
require 'active_support/core_ext/object'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/array'
require 'active_support/core_ext/module'
require 'active_support/ordered_hash'

# AS 3.0 has been removed it because is now available in Ruby 1.8.7 and 1.9.
require 'active_support/core_ext/symbol' if ActiveSupport::VERSION::MAJOR < 3

##
# Used to know if this file was required
#
module SupportLite; end

module Padrino
  ##
  # This method return the correct location of padrino bin or
  # exec it using Kernel#system with the given args
  #
  def self.bin(*args)
    @_padrino_bin ||= [self.ruby_command, File.expand_path("../../../bin/padrino", __FILE__)]
    args.empty? ? @_padrino_bin : system(args.unshift(@_padrino_bin).join(" "))
  end

  ##
  # Return the path to the ruby interpreter taking into account multiple
  # installations and windows extensions.
  #
  def self.ruby_command
    @ruby_command ||= begin
      ruby = File.join(Config::CONFIG['bindir'], Config::CONFIG['ruby_install_name'])
      ruby << Config::CONFIG['EXEEXT']

      # escape string in case path to ruby executable contain spaces.
      ruby.sub!(/.*\s.*/m, '"\&"')
      ruby
    end
  end
end

module ObjectSpace
  class << self
    # Returns all the classes in the object space.
    def classes
      klasses = []
      ObjectSpace.each_object(Class) {|o| klasses << o}
      klasses
    end
  end
end unless ObjectSpace.respond_to?(:classes)

class Object
  def full_const_get(name)
    list = name.split("::")
    list.shift if list.first.blank?
    obj = self
    list.each do |x|
      # This is required because const_get tries to look for constants in the
      # ancestor chain, but we only want constants that are HERE
      obj = obj.const_defined?(x) ? obj.const_get(x) : obj.const_missing(x)
    end
    obj
  end
end unless Object.method_defined?(:full_const_get)

##
# Loads our locales configuration files
#
I18n.load_path += Dir["#{File.dirname(__FILE__)}/locale/*.yml"] if defined?(I18n)
