require 'spec_helper'

describe CommitGuard::Guards::Firebug do
  let(:options) { { } }

  context 'given a valid directory' do
    let(:dir) { valid_project }
    it 'is valid' do
      described_class.new(dir, options).should be_valid
    end
  end

  context 'given an invalid directory' do
    let(:dir) { invalid_project }
    let(:guard) { described_class.new(dir, options) }

    it 'is invalid' do
      guard.should be_invalid
    end

    it 'returns the title of the guard' do
      guard.title.should == "Firebug Guard"
    end

    it 'returns the failure description' do
      guard.description.should include("Check failed")
    end

    it 'returns the matching files in the failure description' do
      guard.description.should include("features/login.feature")
    end


  end
end
