require 'spec_helper'

describe CommitGuard::GuardPrompt do

  def answer_with(answer)
    input << "#{answer}\n"
    input.rewind
  end

  class StubGuard < CommitGuard::Guards::Base
    build do
      property :required_prop, :description => 'Required Property', :required => true
      property :paths, :description => 'Paths to search in', :required => true, :multiple => true
      property :exclude, :description => 'Paths or files to exclude', :required => false, :multiple => true
    end
  end

  let(:input) { StringIO.new }
  let(:output) { StringIO.new }
  let(:prompt) { described_class.new(input, output) }

  describe '#choose_guard' do
    it 'prompts the user to choose a guard' do
      answer_with(1)
      prompt.choose_guard([StubGuard])
      output.string.should include("1. StubGuard")
    end

    it 'stores the guard builder' do
      answer_with(1)
      prompt.choose_guard([StubGuard])
      prompt.builder.should == StubGuard.builder
    end
  end

  describe '#populate' do
    it 'prompts the user for each property' do
      prompt.builder = StubGuard.builder
      prompt.builder.properties.each do |prop|
        prompt.should_receive(:prompt_for_property).with(prop)
      end
      prompt.populate
    end
  end

  describe '#prompt_for_property' do
    let(:property) { prompt.builder.properties.first }

    before do
      prompt.builder = StubGuard.builder
      answer_with('some answer')
    end

    it 'prompts the user for the given property' do
      prompt.prompt_for_property(property)

      output.string.should include("#{property.name} (#{property.description}) :")
    end

    it 'stores the user input in the property' do
      prompt.prompt_for_property(property)

      property.value.should == 'some answer'
    end
  end
  # choose a guard
  # store the guard builder in the prompt object
  # Iterate over the guard builder's properties
  # prompt the user for input for each property
  # if a property is required do not let the user continue without input
  # if the property is multiple ask if they want to add more
  # when all properties are entered display a summary of the guard
  # ask if they want to save it
  # if yes then ask where to store it (home or current path)
end
