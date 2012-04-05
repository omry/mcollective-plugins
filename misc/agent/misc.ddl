metadata    :name        => "Misc commands",
			:description => "Misc commands",
			:author      => "Omry Yadan <omry@yadan.net>",
			:license     => "https://github.com/omry/mcollective-plugins",
			:version     => "1.0",
			:url         => "BSD",
			:timeout     => 2


action "uptime", :description => "Node uptime" do
end

action "reboot", :description => "Reboot node" do
end

action "tcpdump", :description => "Start/Stop tcpdump" do
end

action "postqueue", :description => "Count/Empty postqueue" do
end
