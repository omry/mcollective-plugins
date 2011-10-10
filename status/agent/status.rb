require "socket"
MCollective::Util.loadclass("MCollective::Util::JavaProps")

module MCollective
    module Agent
        class Status<RPC::Agent
            metadata    :name        => "Status agent",
                        :description => "Queries process status based on /var/status/*.status", 
                        :author      => "Omry Yadan <omry@yadan.net>",
                        :license     => "BSD",
                        :version     => "1.0",
                        :url         => "?",
                        :timeout     => 2

            action "query" do
				begin
					reply[:matches] = query()
				rescue Exception => e
					logger.error(e)
					logger.error(e.backtrace.join("\n\t"))
					raise
				end
            end

			action "kill" do
				sig = request[:sig] ? request[:sig].upcase : "KILL"
				reply[:matches] = query()
				reply[:matches].each do |p|
					logger.info("Sending #{sig} to " + p["pid"])
					::Process.kill(sig,p["pid"].to_i)
				end
			end

			def query()
				result = []
				files = Dir["/var/status/*.status"]
				logger.debug("Processing #{files.size} files from /var/status")
				files.each { |f|
					p = JavaProps.new(f)
					pid = p.properties["pid"]
					if pid
						proc_file = "/proc/#{pid}/exe"
						if File.exists?(proc_file) 
							actual = File.readlink(proc_file)
							if actual == p.properties["binary"]
								result.push(p.properties)
							else
								logger.debug("Skipping dead status file #{f}, process #{pid} binary does not match status file")
							end
						else
							logger.debug("Skipping dead status file #{f}, process #{pid} is not running")
						end
					else
						logger.warn("#{f} does not contain 'pid' field")
					end
				}

				if request[:elapsed] != nil
					m = /([1-9][0-9]*)/.match(request[:elapsed])
					t = m[1].to_i
					now = Time.now.to_i
					result.delete_if{|p| 
						started = p["time"].to_i
						elapsed = now - started < t
					}
				end
					
				if request[:args] != nil
					request[:args].each{ |a|
						logger.debug("arg : " + a)
						m = a.match(/^(.+?)=(.+)$/)
						key = m[1]
						value = m[2]
						result.delete_if{|p|
							not (p.include?(key) and p[key].match(Regexp.new(".*" + value + ".*")))
						}
					}
				end
				return result
			end
        end
    end
end
