metadata    :name        => "Monit control",
			:description => "Monit control agent",
			:author      => "Omry Yadan <omry@yadan.net>",
			:license     => "BSD",
			:version     => "1.0",
			:url         => "https://github.com/omry/mcollective-plugins",
			:timeout     => 2

action "status", :description => "Detailed services status" do
   	input :name,
	    :prompt      => "Optional service name",
	    :description => "Optional service name",
	    :type        => :string,
	    :validation  => '^.+$',
	    :optional    => true
 
end

action "summary", :description => "Summary of services status" do
   	input :name,
	    :prompt      => "Optional service name",
	    :description => "Optional service name",
	    :type        => :string,
	    :validation  => '^.+$',
	    :optional    => true
 
end

action "start", :description => "Start controlled services" do
	input :name,
	    :prompt      => "service name (or 'all' for all services)",
	    :description => "Service name (or 'all')",
	    :type        => :string,
	    :validation  => '^.+$',
	    :optional    => false
end

action "stop", :description => "Stop controlled services" do
	input :name,
	    :prompt      => "service name (or 'all' for all services)",
	    :description => "Service name (or 'all')",
	    :type        => :string,
	    :validation  => '^.+$',
	    :optional    => false
end

action "restart", :description => "Restart controlled services" do
	input :name,
	    :prompt      => "service name (or 'all' for all services)",
	    :description => "Service name (or 'all')",
	    :type        => :string,
	    :validation  => '^.+$',
	    :optional    => false
end

action "monitor", :description => "Monitor controlled services" do
	input :name,
	    :prompt      => "service name (or 'all' for all services)",
	    :description => "Service name (or 'all')",
	    :type        => :string,
	    :validation  => '^.+$',
	    :optional    => false
end

action "unmonitor", :description => "Unmonitor controlled services" do
	input :name,
	    :prompt      => "service name (or 'all' for all services)",
	    :description => "Service name (or 'all')",
	    :type        => :string,
	    :validation  => '^.+$',
	    :optional    => false
end


