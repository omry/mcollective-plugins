require 'pp'

class MCollective::Application::Misc<MCollective::Application

	description "Misc commands"


	usage <<-EOF
mco misc [uptime|reboot|postqueue|tcpdump]
EOF

    def post_option_parser(configuration)
		if (ARGV.empty?)
			STDERR.puts("command not specified")
			exit 1
		end
		configuration[:cmd] = ARGV.shift.intern

		if (!ARGV.empty?)
			configuration[:action] = ARGV.shift.intern
		end
	end

    def validate_configuration(configuration)
		all_commands = [:uptime,:reboot,:postqueue,:tcpdump]
		protected_commands = [:reboot]

        cmd = configuration[:cmd]
        args = configuration[:args] ? configuration[:args] : []
		raise "Unsupported command #{cmd}, use one of #{all_commands.join(",")}" unless all_commands.include?(configuration[:cmd])
		if protected_commands.include?(configuration[:cmd])
			if MCollective::Util.empty_filter?(options[:filter])
				print "Do you really want to perform #{cmd} operation unfiltered? (Yes, I am sure and I will not come crying later|n): "
				STDOUT.flush
				exit! unless STDIN.gets.strip.match(/^(?:Yes, I am sure and I will not come crying later)$/i)
			end
		end
   end


	def main
   		mc = rpcclient("misc")
		mc.progress = false
		mc.send(configuration[:cmd], configuration).each do |resp|
			if resp[:statuscode] and resp[:data] != nil
				text = resp[:data][:text]
				if text and not text.size == 0
					lines = text.to_s.split("\n")
					if lines.count == 1
						# if only one line, print in the same line as the sender
						puts("#{resp[:sender].ljust(25)}: #{lines[0]}")
					else
						puts("#{resp[:sender]} : ")
						text.each do |d|
							puts(d)
						end
					end
				end
			else
				puts("#{resp[:sender]} : Invalid response (no data)")
			end
		end
		mc.disconnect
	end
end
