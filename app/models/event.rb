class Event < ActiveRecord::Base
  belongs_to :user
  
  validates :name, :image, :address, :event_date, presence: true

  #order events desc
  default_scope { order(event_date: :asc) }
  
  #geocode stuff
  geocoded_by :address
  after_validation :geocode, :if => :address_changed?

  #paperclip
  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "http://vignette1.wikia.nocookie.net/questworld/images/4/47/Comic_image_missing.png/revision/latest?cb=20100421133705"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  
  #import events spreadsheet
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      event = Event.new(name: row[0], image: row[1], address: row[2], event_date: row[3])
      event.save!
    end  
  end
  
end
