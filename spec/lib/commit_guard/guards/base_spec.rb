require 'spec_helper'

describe CommitGuard::Guards::Base do
  describe '.children' do
    it 'keeps track of all classes that inherit from it' do
      described_class.children.should include(CommitGuard::Guards::Grep)
    end
  end
end
