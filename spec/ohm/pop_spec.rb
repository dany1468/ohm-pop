require 'spec_helper'

describe Ohm::Set do
  class Item < Ohm::Model
    attribute :name
    attribute :email
    attribute :priority

    index :name
    index :priority

    unique :email
    track :notes
  end

  describe '#pop' do
    subject { Item.all.pop(options) }

    describe 'with sort options' do
      before do
        Item.create(name: 'item_2', email: '2@example.com', priority: 2)
        Item.create(name: 'item_1', email: '1@example.com', priority: 1)
        Item.create(name: 'item_3', email: '3@example.com', priority: 3)
      end

      context 'use only :by option'  do
        let(:options) { {by: :priority} }

        it { expect(subject.name).to eq('item_1') }
        it { expect { subject }.to change { Item.all.size }.from(3).to(2) }
        it { expect { subject }.to change { Item.all.map(&:name) }.to(match_array(%w(item_2 item_3))) }
      end

      context 'use :by and :order options' do
        let(:options) { {by: :priority, order: 'DESC'} }

        it { expect(subject.name).to eq('item_3') }
        it { expect { subject }.to change { Item.all.size }.from(3).to(2) }
        it { expect { subject }.to change { Item.all.map(&:name) }.to(match_array(%w(item_1 item_2))) }
      end

      context 'use get option' do
        let(:options) { {get: :email} }

        it { expect { subject }.to raise_error(ArgumentError) }
      end

      context 'use store option' do
        let(:options) { {store: :temp} }

        it { expect { subject }.to raise_error(ArgumentError) }
      end

      context 'use limit option' do
        let(:options) { {limit: [0, 10]} }

        it { expect { subject }.to raise_error(ArgumentError) }
      end
    end

    describe 'no leftover keys after calling #pop' do
      let(:options) { {} }

      before do
        Item.create(name: 'item', email: 'item@example.com', priority: 1)
      end

      it { expect { subject }.to change { Ohm.redis.call("KEYS", "*") }.to(["Item:id"]) }
    end
  end
end
