class MCollective::Application::Status<MCollective::Application

	description "Queries process status based on /var/status/*.status"

	usage <<-EOF
mco status [OPTIONS] [MC FILTERS] <query|kill> [STATUS FILTERS]

STATUS FILTERS: Those filters are key=value pairs, that can be used to filter the result, for example:
	binary=blah
will match only status files that contains binary=*blah* (regexp match)

Special status filters:
	elapsed=N[s|m|h|d] : seconds elapsed between now and the time attribute in the status file. this also supports (m)inutes, (h)ours and (d)ays

	EOF

	def post_option_parser(configuration)
		if (ARGV.empty? or not ARGV[0].match(/^[0-9a-zA-Z]+$/))
			configuration[:cmd] = :query
		else
			configuration[:cmd] = ARGV.shift.intern
		end

		ARGV.each do |v|
			e = /^elapsed=([1-9][0-9]*([smhd])?)$/
			if v.match(e)
				m = v.match(e)
				t = m[1].to_i
				if m[2] != nil
					case m[2]
						when "m"
							t = t * 60
						when "h"
							t = t * 60 * 60
						when "d"
							t = t * 24 * 60 * 60
						when "s"
							t = t
					end
				end
				configuration[:elapsed]=t.to_s
			elsif v =~ /^(.+?)=(.+)$/
				configuration[:args] = [] unless configuration.include?(:args)
				configuration[:args] << v
				print "adding arg #{v}"
			else
				STDERR.puts("Could not parse --arg #{v}")
			end
		end
	end

	# stop the application if we didnt receive a message
	def validate_configuration(configuration)
		commands = [:query,:kill]
		cmd = configuration[:cmd]
		args = configuration[:args] ? configuration[:args] : []
		raise "Unsupported command #{cmd}, use one of #{commands.to_s}" unless commands.include?(configuration[:cmd])
		if cmd == :kill and args.empty? and not configuration[:elapsed] 
			print("Do you really want to kill all processes wth /var/status/*.status unfiltered? (y/n): ")
			STDOUT.flush
			exit unless STDIN.gets.chomp =~ /^y$/
		end
   end

	def main
		verbose = configuration[:verbose] ? configuration[:verbose] : false

   		mc = rpcclient("status")
		mc.progress = false
		mc.send(configuration[:cmd], configuration).each do |resp|
			if resp[:data] != nil
				m = resp[:data][:matches]
				if m and not m.size == 0
					puts("#{resp[:sender]} : ")
					m.each do |d|
						puts("\t#{d["binary"]} #{d["pid"]}")
						if options[:verbose]
							d.each_pair do |k,v|
								if not ["binary","pid"].include?(k)
									puts("\t\t#{k}=#{v}")
								end
							end
						end
					end
				end
			else
				puts("Invalid response (no data)")
			end
		end
		mc.disconnect
	end
end
