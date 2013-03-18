require 'spec_helper'

describe CommitGuard::GuardBuilder do
  class MyGuard
    def self.title
      "Awesome"
    end

    def self.yaml_name
      "Awesome"
    end
  end

  let(:builder) { described_class.new(MyGuard) }

  before do
    builder.property(:thing)
  end

  describe 'initializing' do
    it 'takes a class as its argument' do
      builder.for_class.should == MyGuard
    end
  end

  describe '#name' do
    it 'returns the name of the class' do
      builder.name.should == 'MyGuard'
    end
  end

  describe '#title' do
    it 'returns the title of the class' do
      builder.title.should == MyGuard.title
    end
  end

  describe '#yaml_name' do
    it 'returns the yaml_name of the class' do
      builder.yaml_name.should == MyGuard.yaml_name
    end
  end

  describe '#property' do
    it 'builds a new property for the builder' do
      expect {
        builder.property(:another_prop)
      }.to change(builder.properties, :count).by(1)
    end

  end

  describe '#property_for' do
    it 'returns the property object for that name' do
      builder.property_for(:thing).should_not be_nil
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

  describe '#remove_property' do
    it 'remove_propertys the property' do
      builder.remove_property(:thing)
      builder.property_for(:something).should be_nil
    end
  end

  describe '#set' do
    it 'sets the value of the property' do
      builder.set(:thing, 1)
      builder.value(:thing).should == 1
    end
  end

  describe '#remove' do
    it 'removes the value of the property' do
      builder.property(:more_things, :multiple => true)

      builder.set(:more_things, 'a')
      builder.set(:more_things, 'b')
      builder.remove(:more_things, 1)
      builder.value(:more_things).should == ['a']
    end
  end


  describe '#preview' do
    it 'includes the name of the guard' do
      builder.preview[0].should == ['Name', builder.title]
    end

    it 'includes all properties' do
      builder.preview.length.should == builder.properties.length + 1
      property = builder.properties[0]
      builder.preview[1].should == ["Property (#{property.name})", property.value]
    end

    it 'includes all values for multiple properties' do
      builder.property(:more_things, :multiple => true)

      builder.set(:more_things, 'a')
      builder.set(:more_things, 'b')
      property = builder.properties.last
      builder.preview.last[1].should == ['a', 'b']
    end
  end

  describe '#to_hash' do
    it 'returns a hash of the properties and values' do
      builder.property(:more_things, :multiple => true)

      builder.set(:more_things, 'a')
      builder.set(:more_things, 'b')
      builder.set(:thing, 1)

      builder.to_hash.should include({'type' => builder.yaml_name})
      builder.properties.each do |prop|
        builder.to_hash.should include(prop.to_hash)
      end
    end
  end
end
