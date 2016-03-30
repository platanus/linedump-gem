describe Linedump::Consumer do
  with_fake_process(:proc_a, 'hello')
  with_fake_process(:proc_b, 'world')

  let!(:consumer) { Linedump::Consumer.new }
  after(:example) { consumer.stop }

  describe 'is_registered?' do
    it "should return true if given stream has been registered" do
      consumer.register_stream(proc_a_stdout) { |l| }
      expect(consumer.is_registered? proc_a_stdout).to be true
      expect(consumer.is_registered? proc_b_stdout).to be false
    end
  end

  describe 'register_stream' do
    it "should begin consuming stream and passing it to given block" do
      output = []
      consumer.register_stream(proc_a_stdout) { |l| output << l }
      consumer.reload
      sleep 0.5
      expect(output).to include('hello')

      consumer.register_stream(proc_b_stdout) { |l| output << l }
      consumer.reload
      sleep 0.3
      expect(output).to include('world')
    end

    it "should automatically remove watched stream if eof is reached" do
      consumer.register_stream(proc_a_stdout) { |l| }
      consumer.reload

      expect(consumer.is_registered? proc_a_stdout).to be true
      kill_proc_a
      sleep 1.0
      expect(consumer.is_registered? proc_a_stdout).to be false
    end

    it "should automatically remove watched stream if stream is closed" do
      consumer.register_stream(proc_a_stdout) { |l| }
      consumer.reload
      sleep 1.0

      expect(consumer.is_registered? proc_a_stdout).to be true
      proc_a_stdout.close
      consumer.reload
      sleep 1.0
      expect(consumer.is_registered? proc_a_stdout).to be false
    end
  end
end
