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
  let(:config_file) { double(:name => 'Home Dir')}
  let(:configuration) { double(:add_guard => nil, :config_files => [config_file], :config_names => [config_file.name]) }
  let(:prompt) { described_class.new(configuration, input, output) }

  describe '#choose_guard' do
    it 'prompts the user to choose a guard' do
      answer_with(1)
      prompt.choose_guard([StubGuard])
      output.string.should include("1. StubGuard")
    end

    it 'stores the guard builder' do
      answer_with(1)
      prompt.choose_guard([StubGuard])
      prompt.builder.name.should == StubGuard.name
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

    context 'given a valid answer' do
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

    context 'when given a multiple property' do
      let(:property) { prompt.builder.properties[1] }
      it 'reprompts the user until they enter a blank value' do
        prompt.builder = StubGuard.builder
        prompt.highline.should_receive(:ask).exactly(2).times.and_return('pizza', '')

        prompt.prompt_for_property(property)

        output.string.should include("#{property.name}: Add additional values (leave blank when finished)")
      end

      it 'does not prompt the user a second time if the first value is blank' do
        prompt.builder = StubGuard.builder
        property = prompt.builder.properties[2]
        prompt.highline.should_receive(:ask).exactly(1).times.and_return('')

        prompt.prompt_for_property(property)
      end
    end

    context 'when given an invalid value for a required property' do
      before do
        prompt.builder = StubGuard.builder
      end

      it 'tells the user that the property is required' do

        prompt.highline.stub(:ask).and_return('', 'correct')
        prompt.prompt_for_property(property)

        output.string.should include("#{property.name} is required")
      end

      it 'reprompts the user until they answer correctly' do
        prompt.highline.should_receive(:ask).exactly(4).times.and_return(nil, '', '  ', 'correct')

        prompt.prompt_for_property(property)

        output.string.should include("#{property.name} is required")
      end
    end
  end

  describe '#confirm' do
    before do
      prompt.builder = StubGuard.builder
    end

    it "asks the user if they would like to continue" do
      answer_with('n')
      prompt.confirm
      output.string.should include("Would you like to save this Guard? (Y/N)")
    end

    it "includes the preview of the guard" do
      answer_with('n')
      prompt.builder.stub(:preview => [['Name', 'Guard preview']])
      prompt.confirm
      output.string.should include("Guard preview")
    end

    context "the user does not want to continue" do
      it "does not call prompt_to_save" do
        answer_with('n')
        prompt.should_not_receive(:prompt_to_save)
        prompt.confirm
      end
    end

    context "the user wants to save" do
      it "calls prompt_to_save" do
        answer_with('y')
        prompt.should_receive(:prompt_to_save)
        prompt.confirm
      end
    end
  end

  describe '#prompt_to_save' do
    it 'asks the user which config to write to' do
      answer_with('1')
      prompt.prompt_to_save

      output.string.should include("Where would you like to save this guard to?")
      configuration.config_files.each_with_index do |config, index|
        output.string.should include("#{index + 1}. #{config.name}")
      end
    end

    it 'tells the configuration to save the prompt to the appropriate config' do
      answer_with('1')
      prompt.configuration.should_receive(:add_guard).with(config_file.name, prompt.builder)
      prompt.prompt_to_save
    end

  end

  describe '#perform' do
    it 'prompts the user to build up a guard' do
      prompt.should_receive(:choose_guard).ordered.with([CommitGuard::Guards::Grep])
      prompt.should_receive(:populate).ordered
      prompt.should_receive(:confirm).ordered
      prompt.perform
    end
  end
end
