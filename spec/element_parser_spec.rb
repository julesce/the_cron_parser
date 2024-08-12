require 'rspec'
require_relative '../element_parser'

RSpec.describe ElementParser do
  describe "#call" do
    let(:lower_bound) { 1 }
    let(:upper_bound) { 12 }
    let(:input) { nil }
    subject { ElementParser.new(input, upper_bound:, lower_bound:).call }

    context "the input is a '*'" do
      let(:input) { "*" }

      it "renders all values within the relevant range" do
        result = subject
        expect(result).to eq("1 2 3 4 5 6 7 8 9 10 11 12")
      end
    end

    context "the input is a comma-seperated list" do
      let(:input) { "4,5,6,7,8,9,10" }

      it "renders all values within the list" do
        result = subject
        expect(result).to eq("4 5 6 7 8 9 10")
      end
    end

    context "the input is a step value and contains a '/'" do
      let(:lower_bound) { 0 }
      let(:upper_bound) { 59 }
      let(:input) { "*/15" }
      subject { ElementParser.new(input, upper_bound:, lower_bound:).call }

      context "the first part of the step value is a '*'" do
        let(:input) { "*/15" }

        it "renders the correct step values" do
          result = subject
          expect(result).to eq("0 15 30 45")
        end
      end

      context "the first part of the step value is a range (example A)" do
        let(:input) { "5-15/3" }

        it "renders the correct step values based on the range" do
          result = subject
          expect(result).to eq("5 8 11 14")
        end
      end

      context "the first part of the step value is a range (example B)" do
        let(:input) { "1-20/3" }

        it "renders the correct step values based on the range" do
          result = subject
          expect(result).to eq("1 4 7 10 13 16 19")
        end
      end

      context "the first part of the step value is a range and starts at 0" do
        let(:input) { "0-15/3" }

        it "renders the correct step values based on the range" do
          result = subject
          expect(result).to eq("0 3 6 9 12 15")
        end
      end

      context "part of the step is an invalid character" do
        let(:input) { "a/10" }

        it "renders an error message" do
          result = subject
          expect(result.downcase).to include("invalid step value")
        end
      end
    end

    context "the input is a range" do
      let(:input) { "3-10" }

      it "renders all values within the range" do
        result = subject
        expect(result).to eq("3 4 5 6 7 8 9 10")
      end
    end

    context "the input is an integer" do
      let(:input) { "11" }

      it "renders the integer" do
        result = subject
        expect(result).to eq("11")
      end
    end

    context "the input contains an invalid character" do
      let(:input) { "a" }

      it "returns a string containing an error message" do
        result = subject
        expect(result.downcase).to include('unable to parse input')
      end
    end
  end
end
