require 'rails_helper'

RSpec.describe ApplicationCable::Connection, type: :channel do
  it 'is a subclass of ActionCable::Connection::Base' do
    expect(ApplicationCable::Connection < ActionCable::Connection::Base).to be true
  end
end

RSpec.describe ApplicationCable::Channel, type: :channel do
    it 'is a subclass of ActionCable::Channel::Base' do
      expect(ApplicationCable::Channel < ActionCable::Channel::Base).to be true
    end
  end
