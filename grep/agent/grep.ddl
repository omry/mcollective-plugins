metadata    :name        => "grep",	
            :description => "Grep, search and crop log files", 
            :author      => "Omry Yadan <omry@yadan.net>",
            :license     => "BSD",
            :version     => "1.1",
            :url         => "?",
            :timeout     => 5


action "grep", :description => "queries for matching processes" do
	display :always

	input :file,
	    :prompt      => "File to grep and search",
	    :description => "File to grep and search",
	    :type        => :string,
		:validation  => '^.+$',
	    :optional    => false,
      :maxlength   => 150

	input :filter,
	    :prompt      => "Filter pattern, return only lines that matches this",
	    :description => "Filter pattern",
	    :type        => :string,
		:validation  => '^.+$',
	    :optional    => true,
      :maxlength   => 150
	
	input :lines,
	    :prompt      => "Maximum number of lines to return, defualt 100",
	    :description => "Maximum number of lines to return, default 100",
	    :type        => :integer,
	    :optional    => true

	input :search,
	    :prompt      => "Search for this string, first returned line will match this",
	    :description => "Search for this string, first returned line will match this",
	    :type        => :string,
		:validation  => '^.+$',
	    :optional    => true,
      :maxlength   => 50

end

