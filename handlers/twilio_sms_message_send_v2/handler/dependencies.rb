  # Require the necessary standard libraries
require 'rexml/document'

# If the Kinetic Task version is under 4, load the openssl and json libraries
# because they are not included in the ruby version
if KineticTask::VERSION.split('.').first.to_i < 4
  # Load the JRuby Open SSL library unless it has already been loaded.  This
  # prevents multiple handlers using the same library from causing problems.
  if not defined?(Jopenssl)
    # Load the Bouncy Castle library unless it has already been loaded.  This
    # prevents multiple handlers using the same library from causing problems.
    # Calculate the location of this file
    handler_path = File.expand_path(File.dirname(__FILE__))
    # Calculate the location of our library and add it to the Ruby load path
    library_path = File.join(handler_path, 'vendor/bouncy-castle-java-1.5.0147/lib')
    $:.unshift library_path
    # Require the library
    require 'bouncy-castle-java'
    
    
    # Calculate the location of this file
    handler_path = File.expand_path(File.dirname(__FILE__))
    # Calculate the location of our library and add it to the Ruby load path
    library_path = File.join(handler_path, 'vendor/jruby-openssl-0.8.8/lib/shared')
    $:.unshift library_path
    # Require the library
    require 'openssl'
    # Require the version constant
    require 'jopenssl/version'
  end



  # Load the ruby JSON library (used by the Twitter library) unless 
  # it has already been loaded.  This prevents multiple handlers using the same 
  # library from causing problems.
  if not defined?(JSON)
    # Calculate the location of this file
    handler_path = File.expand_path(File.dirname(__FILE__))
    # Calculate the location of our library and add it to the Ruby load path
    library_path = File.join(handler_path, 'vendor/json-1.8.0/lib')
    $:.unshift library_path
    # Require the library
    require 'json'
  end

  # Validate the the loaded JSON library is the library that is expected for
  # this handler to execute properly.
  if not defined?(JSON::VERSION)
    raise "The JSON class does not define the expected VERSION constant."
  elsif JSON::VERSION.to_s != '1.8.0'
    raise "Incompatible library version #{JSON::VERSION} for JSON.  Expecting version 1.8.0."
  end
end



# Load the ruby Builder library unless it has already been loaded.  This prevents
# multiple handlers using the same library from causing problems.
if not defined?(Builder)
  # Calculate the location of this file
  handler_path = File.expand_path(File.dirname(__FILE__))
  # Calculate the location of our library and add it to the Ruby load path
  library_path = File.join(handler_path, 'vendor/builder-3.0.0/lib')
  $:.unshift library_path
  # Require the library
  require 'builder'
end

# Validate the the loaded Builder library is the library that is expected for
# this handler to execute properly.
if not defined?(Builder::VERSION)
  raise "The Builder class does not define the expected VERSION constant."
elsif Builder::VERSION != '3.0.0'
  raise "Incompatible library version #{Builder::VERSION} for Builder.  Expecting version 3.0.0."
end





# Load the ruby Multijson library unless it has already been loaded.  This 
# prevents multiple handlers using the same library from causing problems.
if not defined?(MultiJson)
  # Calculate the location of this file
  handler_path = File.expand_path(File.dirname(__FILE__))
  # Calculate the location of our library and add it to the Ruby load path
  library_path = File.join(handler_path, 'vendor/multi_json-1.7.5/lib')
  $:.unshift library_path
  # Require the library
  require 'multi_json'
end

# Validate the the loaded MultiJson library is the library that is expected for
# this handler to execute properly.
if not defined?(MultiJson::Version)
  raise "The MultiJson class does not define the expected VERSION constant."
elsif MultiJson::Version.to_s != '1.7.5'
  raise "Incompatible library version #{MultiJson::Version} for MultiJson.  Expecting version 1.7.5."
end





# Load the ruby JWT library unless it has already been loaded.  This prevents
# multiple handlers using the same library from causing problems.
if not defined?(JWT)
  # Calculate the location of this file
  handler_path = File.expand_path(File.dirname(__FILE__))
  # Calculate the location of our library and add it to the Ruby load path
  library_path = File.join(handler_path, 'vendor/jwt-0.1.4/lib')
  $:.unshift library_path
  # Require the library
  require 'jwt' 
end

# Validate the the loaded JWT library is the library that is expected for
# this handler to execute properly.
if not defined?(JWT::VERSION)
  raise "The JWT class does not define the expected VERSION constant."
elsif JWT::VERSION != '0.1.4'
  raise "Incompatible library version #{JWT::VERSION} for JWT.  Expecting version 0.1.4."
end






# Load the library only once.
if not defined?(Twilio)
  # Calculate the location of this file
  handler_path = File.expand_path(File.dirname(__FILE__))
  # Calculate the location of our library and add it to the Ruby load path
  library_path = File.join(handler_path, 'vendor/twilio-ruby-3.9.0/lib')
  $:.unshift library_path
  # Require the library
  require 'twilio-ruby'
  # Require the version constant
  require 'twilio-ruby/version'
end

# Validate the the loaded library is the right version
if not defined?(Twilio::VERSION)
  raise "The Twilio class does not define the expected VERSION constant."
elsif Twilio::VERSION != '3.9.0'
  raise "Twilio incompatible library version #{Twilio::VERSION}.  Expecting version 3.9.0."
end



