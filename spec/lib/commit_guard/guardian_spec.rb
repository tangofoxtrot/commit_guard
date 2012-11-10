require 'spec_helper'

describe CommitGuard::Guardian do
  let(:configuration) { stub(:guards => [{'type' => 'grep'}]) }
  let(:guardian) { described_class.new(configuration) }

  describe 'initializing a new guardian' do
    it 'builds guard objects from the configration' do
      guardian.guards.should have(1).item
      guardian.guards.first.should be_a(CommitGuard::Guards::Grep)
    end
  end

  describe 'run' do
    it 'calls call on all guards' do
      guard = guardian.guards.first
      guard.should_receive(:call)
      guardian.run
    end
  end

  describe 'success?' do
    context 'when all the guards are valid' do
      before do
        guardian.guards.replace([stub(:valid? => true), stub(:valid? => true)])
      end

      it 'returns true' do
        guardian.should be_success
      end
    end
    
    context 'when all the guards are not valid' do
      before do
        guardian.guards.replace([stub(:valid? => false), stub(:valid? => true)])
      end

      it 'returns false' do
        guardian.should_not be_success
      end
    end
  end
end
