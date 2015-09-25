module Linedump::Macros

  def with_fake_process(_name, _output, _period=0.1)

    define_method("#{_name}_stdout") { instance_variable_get("@#{_name}_stdout") }

    define_method("kill_#{_name}") { Process.kill 9, instance_variable_get("@#{_name}_thr").pid }

    around(:each) do |example|
      stdin, stdout, wait_thr = Open3.popen2("ruby -e \"loop do puts '#{_output}'; STDOUT.flush rescue nil; sleep #{_period}; end\"")

      instance_variable_set("@#{_name}_stdout", stdout)
      instance_variable_set("@#{_name}_thr", wait_thr)

      begin
        example.run
      ensure
        Process.kill(9, wait_thr.pid) rescue nil
      end
    end
  end

end