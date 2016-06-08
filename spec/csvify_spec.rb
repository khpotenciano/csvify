require 'spec_helper'

describe Csvify do
  it 'has a version number' do
    expect(Csvify::VERSION).not_to be nil
  end

  it 'correctly produces the csv file without any options' do
    hash_collection = [
      {title: 'lfdjalsfd'},
      {title: 'lfdjalsd', book: {hello: "jdflajsfd"}},
    ]

    csv_string = Csvify::Hash.from_collection(hash_collection, {})
    expected_csv_string = "\"title\",\"book hello\",\n\"lfdjalsfd\",\n\"lfdjalsd\",\"jdflajsfd\",\n"
    expect(csv_string).to be_eql expected_csv_string
  end
end
