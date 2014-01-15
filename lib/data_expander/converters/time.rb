require 'time'

module DataExpander
  module Converters
    # Converts time-like strings into actual Time objects. With no arguments
    # this can parse any ISO8601-compliant timestamp, including fractional
    # seconds and zone offsets. A strptime(3)-compliant format string may be
    # provided to enable custom parsing, though be aware certain platforms may
    # not support all conversion specifications.
    class Time
      def initialize(format = nil)
        @format = format
      end

      def call(val)
        if @format
          ::Time.strptime(val, @format)
        else
          ::Time.xmlschema(val)
        end
      end
    end
  end
end
