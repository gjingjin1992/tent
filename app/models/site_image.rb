class SiteImage < ActiveRecord::Base
  has_attached_file :content, styles: {
    large: '1000x1000>',
  },
  default_url: "/images/:style/missing.png"
  
  validates_attachment_content_type :content, content_type: /\Aimage\/.*\Z/

  belongs_to :site
end
