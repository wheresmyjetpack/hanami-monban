require 'spec_helper'

describe Hanami::Monban do
  it 'has a version number' do
    expect(Hanami::Monban::VERSION).not_to be nil
  end

  describe '.configure' do
    it 'yields the configuration object' do
      expect { |b| described_class.configure(&b) }.to yield_with_args(described_class.configuration)
    end
  end

  describe '.configuration' do
    subject { described_class.configuration }
    
    it { is_expected.to respond_to(:sign_in_route) }
    it { is_expected.to respond_to(:user_source) }
  end
end
