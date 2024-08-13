require 'rspec'
require_relative '../lib/cron_parser'

RSpec.describe CronParser do
  describe "#call" do
    let(:cron_string) { nil }
    subject { CronParser.new(cron_string).call }

    context "when no input is provided" do
      it "outputs an error message" do
        allow($stdout).to receive(:puts)

        subject

        expect($stdout).to have_received(:puts).with("Error: Please supply a cron string as the first argument")
      end
    end

    context "when invalid arguments are provided as input" do
      let(:cron_string) { "*/15 2" }

      it "outputs an error message" do
        allow($stdout).to receive(:puts)

        subject

        expect($stdout).to have_received(:puts).with("Error: Please supply a valid cron string with 6 arguments")
      end
    end

    context "when valid input is provided" do
      let(:cron_string) { "*/15 0 1,15 * 1-5 /usr/bin/find" }

      it "outputs the results" do
        allow($stdout).to receive(:puts)
        expected_output = "Minute        0 15 30 45\nHour          0\nDay of Month  1 15\nMonth         1 2 3 4 5 6 7 8 9 10 11 12\nDay of Week   1 2 3 4 5\nCommand       /usr/bin/find"

        subject

        expect($stdout).to have_received(:puts).with(expected_output)
      end
    end
  end
end
