describe Linedump::StreamWrapper do

  with_fake_process(:proc, 'hello')

  let(:output) { [] }
  let!(:wrapper) do
    Linedump::StreamWrapper.new(proc_stdout, Proc.new { |l| output << l })
  end

  describe 'eof?' do
    it "should return true only after process_lines reaches end of file" do
      expect(wrapper.eof?).to be false
      wrapper.process_lines
      expect(wrapper.eof?).to be false
      proc_stdout.close
      wrapper.process_lines
      expect(wrapper.eof?).to be true
    end
  end

  describe 'process_lines' do
    it "should call the given block with every stream line" do
      sleep 0.5
      wrapper.process_lines
      expect(output.count).to be > 0
      expect(output).to include 'hello'
    end
  end

end
