require 'pp'

class MCollective::Application::Monit<MCollective::Application

  description "Monit agent"


  usage <<-EOF
mco monit CMD

where CMD is one of:
    start     name|all - Start the specified sercice (all for all services)
    stop      name|all - Stop the specified sercice (all for all services)
    restart   name|all - Reload the specified sercice (all for all services)
    monitor   name|all - Monitor the specified sercice (all for all services)
    unmonitor name|all - Unmonitor the specified sercice (all for all services)
    status    [name]   - Returns full services status, or if name specified - only for it
    summary   [name]   - Returns short services summary, or if name specified - only for it
    validate           - Check all services and start if not running
    reload             - Reinitialize monit
EOF

  def post_option_parser(configuration)
    if (ARGV.empty?)
      STDERR.puts("command not specified")
      exit 1
    end
    configuration[:cmd] = ARGV.shift.intern

    if ARGV.size > 0
      configuration[:name] = ARGV.shift
    end
  end

  def validate_configuration(configuration)
    all_commands = [:start,:stop,:restart,:monitor,:unmonitor,:status,:summary,:validate,:reload]
    requires_name = [:start,:stop,:restart,:monitor,:unmonitor]
        cmd = configuration[:cmd]
        args = configuration[:args] ? configuration[:args] : []
    raise "Unsupported command #{cmd}, use one of\n#{all_commands.join("\n")}\n" unless all_commands.include?(configuration[:cmd])
    raise "#{cmd} requires service name" unless (!requires_name.include?(configuration[:cmd]) or configuration.has_key?(:name))
  end

  def main
    mc = rpcclient("monit")
    mc.progress = false
    mc.send(configuration[:cmd], configuration).each do |resp|
      d = resp[:data]
      if resp[:statuscode]
        if d[:error]
          puts("#{resp[:sender]} : #{d[:error]}")
        else
          if d[:result]
            puts("#{resp[:sender]} : ")
            d[:result].each_pair do |type,v|
              puts("  #{type}:")
              d[:result][type].each_pair do |name,vv|
                if vv.kind_of?(String)
                  puts("    #{name}=#{vv}")
                elsif vv.kind_of?(Hash)
                  puts("    #{name}")
                  vv.each_pair do |kkk,vvv|
                    puts("      #{kkk}=#{vvv}")
                  end
                end
              end
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
