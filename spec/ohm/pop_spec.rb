require 'spec_helper'

describe Ohm::Set do
  class Item < Ohm::Model
    attribute :name
    attribute :priority

    index :name
    index :priority
  end

  subject { Item.all.pop(by: :priority) }

  describe '#pop' do
    before do
      Item.create(name: 'item_2', priority: 2)
      Item.create(name: 'item_1', priority: 1)
      Item.create(name: 'item_3', priority: 3)
    end

    it { expect(subject.name).to eq('item_1') }
    it { expect { subject }.to change { Item.all.size }.from(3).to(2) }
    it { expect { subject }.to change { Item.all.map(&:name) }.to(match_array(%w(item_2 item_3))) }
  end
end
