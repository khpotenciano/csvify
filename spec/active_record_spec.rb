require 'spec_helper'

describe "Csvify" do
  context "ActiveRecord" do
    let(:groups){
      [ Group.create(name: "EXO", entertainment_agency: "SM Entertainment", debut_date: Date.new(2012, 4, 8)),
        Group.create(name: "SNSD", entertainment_agency: "SM Entertainment", debut_date: Date.new(2007,8, 5))
      ]
    }
    let(:members){
      [
        Member.create(name: "Baekhyun", real_name: "Byun BaekHyun", position: "Main Vocalist", nationality: "Korean", birthday: Date.new(1992, 5, 6), height: "174cm", group: groups[0]),
        Member.create(name: "Lay", real_name: "Zhang Yixing", position: "Main Dancer", nationality: "Korean", birthday: Date.new(1991, 10, 7), height: "177cm", group: groups[0])
      ]
    }
    let(:albums){
      [
        Album.create(title: "EX'ACT", kind: "Studio Album", release_year: 2016, group: groups[0]),
        Album.create(title: "EXODUS", kind: "Studio Album", release_year: 2015, group: groups[0]),
        Album.create(title: "Overdose", kind: "Extended Play", release_year: 2014, group: groups[0]),
        Album.create(title: "Lion Heart", kind: "Studio Album", release_year: 2015, group: groups[1]),
        Album.create(title: "Mr. Mr.", kind: "Extended Play", release_year: 2014, group: groups[1])
      ]
    }
    let(:songs){
      Song.create(title: "Monster", length: "3:41mins", album: albums[0])
    }
    it 'correctly produce the csv string without any parameters' do
      csv_string = Csvify::ActiveRecord.from_collection(groups)
      expected_csv_string = "\"Id\",\"Name\",\"Entertainment agency\",\"Debut date\",\n\"#{groups[0].id}\",\"EXO\",\"SM Entertainment\",\"04/08/2012\",\n\"#{groups[1].id}\",\"SNSD\",\"SM Entertainment\",\"08/05/2007\",\n"
      expect(csv_string).to be_eql expected_csv_string
    end

    it 'correctly produce the csv string when include child resource parameters are included' do
      expect(true).to be false
    end

    it 'correctly produce the csv string when exclude parameters containing parent resource fields are included' do
      expect(true).to be false
    end

    it 'correctly produce the csv string when exclude parameters containing child resource fields are included' do
      expect(true).to be false
    end

    it 'correctly produce the csv string when exclude parameters containing both parent and child resource fields are included' do
      expect(true).to be false
    end

    it 'correctly produce the csv string when both include and exclude parameters are included' do
      expect(true).to be false
    end
  end
end
