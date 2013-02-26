require 'spec_helper'

describe CommitGuard::GuardProperty do
  let(:args) { [:thingy, {:required => true, :multiple => true}] }
  let(:property) { described_class.new(*args) }

  describe '#name' do
    it 'is set to the first argument' do
      property.name.should == :thingy
    end
  end

  describe '#multiple?' do
    it 'sets the multiple flag from the second argument' do
      property.should be_multiple
    end
  end

  describe '#required?' do
    it 'sets the required flag from the second argument' do
      property.should be_required
    end
  end

end
