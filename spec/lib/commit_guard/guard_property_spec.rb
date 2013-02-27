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

  describe '#value=' do
    context 'for a multiple property' do
      it 'appends the value of the property' do
        property.value = 'something'
        property.value = 'else'
        property.value.should == ['something', 'else']
      end
    end

    context 'for a non multiple property' do
      before { property.stub(:multiple? => false) }
      it 'sets the value of the property' do
        property.value = 'something'
        property.value.should == 'something'
      end
    end
  end

  describe '#remove' do
    context 'for a multiple property' do
      it 'removes the value at that index' do
        property.value = 'a'
        property.value = 'b'
        property.remove 1
        property.value.should == ['a']
      end
    end

    context 'for a non multiple property' do
      before { property.stub(:multiple? => false) }
      it 'sets the value to nil' do
        property.remove
        property.value.should be_nil
      end
    end

  end

  describe '#valid?' do
    context 'when the property not required' do
      context 'and the value is blank' do
        it 'is not valid' do
          property.should_not be_valid
        end
      end

      context 'and the value is not blank' do
        it 'is valid' do
          property.value = 'awesome'
          property.should be_valid
        end
      end

    end
    context 'when the property is not required' do
      before { property.stub(:required? => false) }

      it 'is always valid' do
        property.should be_valid
      end

    end
  end

end
