require 'spec_helper'

describe CommitGuard::Guardian do
  let(:output) { stub(:puts => nil) }
  let(:configuration) { stub(:output => output, :guards => [{'type' => 'grep'}], :silent? => false, :requires => [fixture_path('my_custom_guard')]) }
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
      guard.should_receive(:run)
      guardian.run
    end

    it 'calls display on all guards' do
      guard = guardian.guards.first
      guard.should_receive(:display)
      guardian.run
    end
  end

  describe 'results' do
    context 'when configuration is silent' do
      before { configuration.stub(:silent? => true) }

      it 'calls display on only invalid guards' do
        invalid_guard = stub(:invalid? => true)
        valid_guard = stub(:invalid? => false)
        guardian.stub(:guards => [invalid_guard, valid_guard])
        invalid_guard.should_receive(:display)
        valid_guard.should_not_receive(:display)
        guardian.results
      end
    end
    context 'when configuration is not silent' do
      it 'calls display on all guards' do
        guard = guardian.guards.first
        guard.should_receive(:display)
        guardian.results
      end
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
