metadata    :name        => "Status agent",
			:description => "Queries process status based on /var/status/*.status",
			:author      => "Omry Yadan <omry@yadan.net>",
			:license     => "BSD",
			:version     => "1.0",
			:url         => "?",
			:timeout     => 5

action "query", :description => "queries for matching processes" do
	display :always

	input :elapsed,
	    :prompt      => "Filter by elapsed time",
	    :description => "seconds",
	    :type        => :string,
	    :validation  => '^([1-9][0-9]*)$',
	    :optional    => true
end

action "kill", :description => "kill matching processes" do
	display :always
	input :sig,
	    :prompt      => "signal to send to processes",
	    :description => "A unix signal to send to matching proceses",
	    :type        => :string,
	    :optional    => true,
		:validation	 => '^([1-9][0-9]*|(?i:KILL|TERM|STOP|CONT))$'
	
	
	input :elapsed,
	    :prompt      => "Filter by elapsed time",
	    :description => "seconds",
	    :type        => :string,
	    :validation  => '^([1-9][0-9]*)$',
	    :optional    => true
end
