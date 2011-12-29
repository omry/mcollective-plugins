module MCollective
	module Agent
		class Misc<RPC::Agent
			metadata    :name        => "Misc commands",
				:description => "Misc commands", 
				:author      => "Omry Yadan <omry@yadan.net>",
				:license     => "",
				:version     => "1.0",
				:url         => "?",
				:timeout     => 2

			action "reboot" do
				run("reboot")
			end

			action "uptime" do
				run("uptime")
			end

			action "tcpdump" do
				if request[:action] == "start"
					file = "/tmp/tcp.dump"
					if request[:file] 
						file = request[:file]
					end
					run("tcpdump -w #{file}&")
				elsif request[:action] == "stop"
					run("killall tcpdump")
				end
			end

			action "postqueue" do
				if request[:action] == "count"
					run("postqueue -p | tail -n 1 | cut -d' ' -f5")
				elsif request[:action] == "empty"
					run("sudo postsuper -d ALL")
				end
			end

			def run(cmd)
				begin
					reply[:cmd] = cmd
					reply[:text] = %x[#{cmd}]
				rescue Exception => e
					logger.error(e)
					logger.error(e.backtrace.join("\n\t"))
					raise
				end
			end
		end
	end
end
