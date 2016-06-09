ActiveRecord::Schema.define do
  self.verbose = false
  create_table :groups , :force => :cascade do |t|
    t.string      "name"
    t.string      "entertainment_agency"
    t.date        "debut_date"
  end
  create_table :members, :force => :cascade do |t|
    t.integer     "group_id"
    t.string      "name"
    t.string      "real_name"
    t.string      "position"
    t.string      "nationality"
    t.date        "birthday"
    t.string      "height"
  end

  create_table :albums, :force => :cascade do |t|
    t.integer     "group_id"
    t.string      "title"
    t.string      "kind"
    t.integer     "release_year"
  end

  create_table :songs, :force => :cascade do |t|
    t.integer    "album_id"
    t.string     "title"
    t.string     "length"
  end
end
