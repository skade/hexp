require 'spec_helper'

describe Hexp::Nokogiri::Equality do
  let(:doc) { Nokogiri::HTML::Document.new }

  context 'two empty documents' do
    it 'should be equal' do
      expect(described_class.new(Nokogiri::HTML::Document.new, Nokogiri::HTML::Document.new).call).to be true
    end
  end

  context 'two nodes with the same attributes' do
    it 'should be equal' do
      node1 = Nokogiri::XML::Node.new('div', doc)
      node1['class'] = 'hello'
      node2 = Nokogiri::XML::Node.new('div', doc)
      node2['class'] = 'hello'

      expect(described_class.new(node1, node2).call).to be true
    end
  end

  context 'one node has an attribute more' do
    it 'should be equal' do
      node1 = Nokogiri::XML::Node.new('div', doc)
      node1['class'] = 'hello'
      node2 = Nokogiri::XML::Node.new('div', doc)
      node2['class'] = 'hello'
      node2['id'] = 'zigzag'

      expect(described_class.new(node1, node2).call).to be true
    end
  end

  context 'two nodes with the same children' do
    it 'should be equal' do
      node1 = Nokogiri::XML::Node.new('div', doc)
      node1 << Nokogiri::XML::Node.new('p', doc)
      node2 = Nokogiri::XML::Node.new('div', doc)
      node2 << Nokogiri::XML::Node.new('p', doc)

      expect(described_class.new(node1, node2).call).to be true
    end
  end

  context 'two nodes with a child of a different name' do
    it 'should not be equal' do
      node1 = Nokogiri::XML::Node.new('div', doc)
      node1 << Nokogiri::XML::Node.new('p', doc)
      node2 = Nokogiri::XML::Node.new('div', doc)
      node2 << Nokogiri::XML::Node.new('em', doc)

      expect(described_class.new(node1, node2).call).to be false
    end
  end

  context 'one node has a child more than the other, otherwise identical' do
    it 'should not be equal' do
      node1 = Nokogiri::XML::Node.new('div', doc)
      node1 << Nokogiri::XML::Node.new('p', doc)
      node2 = Nokogiri::XML::Node.new('div', doc)
      node2 << Nokogiri::XML::Node.new('p', doc)
      node2 << Nokogiri::XML::Node.new('em', doc)

      expect(described_class.new(node1, node2).call).to be false
    end
  end

end
