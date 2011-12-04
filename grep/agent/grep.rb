module MCollective
    module Agent
        class Grep<RPC::Agent
            metadata    :name        => "Grep agent",
                        :description => "Grep, search and crop log files", 
                        :author      => "Omry Yadan <omry@yadan.net>",
                        :license     => "BSD",
                        :version     => "1.0",
                        :url         => "?",
                        :timeout     => 2

            action "grep" do
				begin
					validate :file, :shellsafe

					filter = request[:filter]
					search = request[:search]
					file = request[:file]
					lines = request[:lines]

					if (filter == nil) 
						filter = "."
					end

					if (search == nil) 
						search = "."
					end

					if (lines == nil) 
						lines = 100
					end

					cmd = "grep #{filter} #{file} | sed -n '/#{search}/,$p' | tail -#{lines}"
					reply[:cmd] = cmd
					reply[:text] = %x[#{cmd}].split("\n")
				rescue Exception => e
					logger.error(e)
					logger.error(e.backtrace.join("\n\t"))
					raise
				end
            end
        end
    end
end
