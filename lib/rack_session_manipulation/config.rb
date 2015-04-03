# Parent namespace for the Rack Session Manipulation middleware.
module RackSessionManipulation
  # A data storage structure for holding configuration related information.
  Config = Struct.new(:path, :encoder)
end
