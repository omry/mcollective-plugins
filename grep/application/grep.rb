class MCollective::Application::Grep<MCollective::Application

	description "Grep, search and crop log files"

	option :search,
          :description    => "Search for this string in the file (first line will match this)",
          :arguments      => ["-s", "--search STRING"],
          :type           => String,
          :required       => false

	option :lines,
			:description    => "Maximum number of lines to return",
			:arguments      => ["-n", "--lines LINES"],
			:type           => Integer,
			:required       => false


	usage <<-EOF
mco grep [OPTIONS] [MC FILTERS] file filter [-n num_lines] [-s search]
EOF

	def post_option_parser(configuration)
		configuration[:file] =  ARGV.shift
		configuration[:filter] =  ARGV.shift
	end

	def main
   		mc = rpcclient("grep")
		mc.progress = false
		mc.grep(configuration).each do |resp|
			if resp[:statuscode] == 0
				text = resp[:data][:text]
				if text and not text.size == 0
					puts("#{resp[:sender]} : ")
					text.each do |d|
						puts(d)
					end
				end
			else
				puts("Invalid response (no data)")
			end
		end
		mc.disconnect
	end
end
