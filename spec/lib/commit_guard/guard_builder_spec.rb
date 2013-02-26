require 'spec_helper'

describe CommitGuard::GuardBuilder do
  class MyGuard; end
  let(:builder) { described_class.new(MyGuard) }
  describe 'initializing' do
    it 'takes a class as its argument' do
      builder.for_class.should == MyGuard
    end
  end

  describe '#property' do
    it 'builds a new property for the builder' do
      expect {
        builder.property(:thing)
      }.to change(builder.properties, :count).by(1)
    end

  end

  describe '#property_for' do
    it 'returns the property object for that name' do
      property = builder.property(:thing).first
      builder.property_for(:thing).should == property
    end

  end

  describe '#config' do
    it 'evaluates the block in the instance of self' do #wish I could think of a better description
      builder.config do
        property(:something)
      end
      builder.property_for(:something).should_not be_nil
    end
  end
end
