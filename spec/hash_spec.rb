require 'spec_helper'

describe Csvify do
  context "Hash" do
    let(:hash_collection){ [
      {title: 'Mean Girls', director: 'Mark Waters'},
      {title: 'The Book Thief', director: 'Brian Percival', book: {title: "The Book Thief", author: 'Markus Zusak'}},
      {title: 'The Little Prince', director: 'Mark Osborne', book: {title: "Le Petit Prince", author: 'Antoine de Saint-Exupery'}},
    ]}
    let(:child_field_exclusion) {
      {exclude: [{book: [:title]}]}
    }
    let(:child_resource_exclusion){
      {exclude: [:book]}
    }
    let(:parent_field_exclusion){
      {exclude: [:director]}
    }
    let(:mixed_exclusion){
      {exclude: [:title, {book: [:author]}]}
    }

    it 'has a version number' do
      expect(Csvify::VERSION).not_to be nil
    end

    it 'correctly produces the csv string without any options' do
      csv_string = Csvify::Hash.from_collection(hash_collection)
      expected_csv_string = "\"title\",\"director\",\"book title\",\"book author\",\n\"Mean Girls\",\"Mark Waters\",\n\"The Book Thief\",\"Brian Percival\",\"The Book Thief\",\"Markus Zusak\",\n\"The Little Prince\",\"Mark Osborne\",\"Le Petit Prince\",\"Antoine de Saint-Exupery\",\n"
      expect(csv_string).to be_eql expected_csv_string
    end

    it 'correctly produces the csv string with exclude options(one field from child resource)' do
      csv_string = Csvify::Hash.from_collection(hash_collection, child_field_exclusion)
      expected_csv_string = "\"title\",\"director\",\"book author\",\n\"Mean Girls\",\"Mark Waters\",\n\"The Book Thief\",\"Brian Percival\",\"Markus Zusak\",\n\"The Little Prince\",\"Mark Osborne\",\"Antoine de Saint-Exupery\",\n"
      expect(csv_string).to be_eql expected_csv_string
    end

    it 'correctly produces the csv string with exclude options(a child resource)' do
      csv_string = Csvify::Hash.from_collection(hash_collection, child_resource_exclusion)
      expected_csv_string = "\"title\",\"director\",\n\"Mean Girls\",\"Mark Waters\",\n\"The Book Thief\",\"Brian Percival\",\n\"The Little Prince\",\"Mark Osborne\",\n"
      expect(csv_string).to be_eql expected_csv_string
    end

    it 'correctly produces the csv string with exclude options(field from parent resource)' do
      csv_string = Csvify::Hash.from_collection(hash_collection, parent_field_exclusion)
      expected_csv_string = "\"title\",\"book title\",\"book author\",\n\"Mean Girls\",\n\"The Book Thief\",\"The Book Thief\",\"Markus Zusak\",\n\"The Little Prince\",\"Le Petit Prince\",\"Antoine de Saint-Exupery\",\n"
      expect(csv_string).to be_eql expected_csv_string
    end

    it 'correctly produces the csv string with exlude options(mixed)' do
      csv_string = Csvify::Hash.from_collection(hash_collection, mixed_exclusion)
      expected_csv_string = "\"director\",\"book title\",\n\"Mark Waters\",\n\"Brian Percival\",\"The Book Thief\",\n\"Mark Osborne\",\"Le Petit Prince\",\n"
      expect(csv_string).to be_eql expected_csv_string
    end
  end
end
