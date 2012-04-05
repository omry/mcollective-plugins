module MCollective
	module Agent
		class Monit<RPC::Agent
			metadata    :name        => "Monit agent",
						:description => "Controls monit on a node", 
						:author      => "Omry Yadan <omry@yadan.net>",
						:license     => "BSD",
						:version     => "1.0",
						:url         => "https://github.com/omry/mcollective-plugins",
						:timeout     => 2

			action "start" do
				monit("start")
			end

			action "stop" do
				monit("stop")
			end

			action "restart" do
				monit("restart")
			end

			action "monitor" do
				monit("monitor")
			end

			action "unmonitor" do
				monit("unmonitor")
			end

			action "reload" do
				run("monit reload")
			end

			action "validate" do
				run("monit validate")
			end

			action "summary" do
				name = nil
				if request[:name]
					name = request[:name]
				end
				reply[:result]=summary(name)
			end

			action "status" do
				text=%x[monit status]
				type = nil
				only_name = nil
				if request[:name]
					only_name = request[:name]
				end
				name = nil
				res = {}
				text.each {|line|
					line.strip!
					if line.size > 0
						r = line.match("(.*) *'(.*)'")
						if r != nil
							type = r[1].strip.downcase.intern
							name = r[2]
						else
							if type == nil
								next
							end

							if only_name == nil or only_name == name
								key = line.slice(0,34).strip
								value = line.slice(34,line.size)
								if !res.has_key?(type)
									res[type] = {}
								end
								if !res[type].has_key?(name)
									res[type][name] = {}
								end

								if only_name == nil or only_name == name
									#print "|#{type}| |#{name}| :  |#{key}|=|#{value}|\n"
									res[type][name][key]=value
								end
							end

						end
					end
					reply[:result]=res
				}
			end

			def summary(name)
				text=%x[monit summary]
				res={}
				text.each {|line| 
					r=line.match("(.*) *'(.*)' *(.*)")
					if r != nil and r.size >= 4
						type = r[1].downcase.intern
						if name == nil or name == r[2]
							if !res.has_key?(type)
								res[type] = {}
							end
							res[type][r[2]] = r[3]
						end
					end
				} 
				res
			end

			def monit(cmd) 
				if request[:name]
					name = request[:name]
					if name != "all"
						s = summary(name)
						found = false
						s.each_pair do |k,v|
							if v.has_key?(name)
								found = true
								break
							end
						end
						if !found
							reply[:error] = "no such service : #{name}"
							return
						end
						
					end
					run("monit #{cmd} #{name}")
				else
					reply[:error] = "monit #{cmd} : service name not specified"
				end
			end
			def run(cmd)
				begin
					reply[:cmd] = cmd
					reply[:text] = %x[#{cmd}]
				rescue Exception => e
					reply[:error] = "#{e}"
					logger.error(e)
					logger.error(e.backtrace.join("\n\t"))
					raise
				end
			end
		end
	end
end
