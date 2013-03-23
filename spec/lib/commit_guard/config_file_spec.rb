require 'spec_helper'
require 'tempfile'

describe CommitGuard::ConfigFile do
  let(:name) { 'Working Dir' }
  let(:file) { Tempfile.new('home_dir').tap {|x| x.puts({'stuff' => 1}.to_yaml); x.close } }
  let(:path) { Pathname.new(file.path) }
  let(:config_file) { described_class.new(name, path) }
  let(:changed_config) { {:some => :changes} }

  before do
    config_file.stub(:path => path)
  end

  describe '#config' do
    context 'when the file does not exist' do
      let(:path) { Pathname.new('asdads') }
      it 'does not raise an exception' do
        expect {
          config_file.config
        }.to_not raise_error(Exception)

      end
    end

    context 'when the file is empty' do
      let(:file) { Tempfile.new('home_dir').tap {|x| x.close } }
      it 'still acts like a hash' do
        config_file.config.should == {}
      end
    end

    context 'when the file contains nothing put white space' do
      let(:file) { Tempfile.new('home_dir').tap {|x| x.puts ""; x.close } }
      it 'still acts like a hash' do
        config_file.config.should == {}
      end
    end

  end

  describe '#save' do
    it 'persists the config to the yaml' do
      config_file.guards << changed_config
      config_file.save
      YAML.load_file(path) == changed_config
    end
  end

  describe '#requires' do
    context 'when the requires key is missing' do
      it 'returns an empty array' do
        config_file.requires.should be_empty
      end
    end

    context 'when the config has a require' do
      before do
        config_file.config['requires'] = ['awesome']
      end

      it 'returns an array of the requires' do
        config_file.requires.should have(1).item
      end

      it 'adds the dir to the file' do
        config_file.requires.first.should == config_file.dir.join('awesome').to_s
      end
    end
  end

end
