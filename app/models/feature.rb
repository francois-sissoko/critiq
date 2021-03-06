class Feature < ActiveRecord::Base
	has_many :pictures, class_name: "ImageAsset", foreign_key: "attachable_id", as: :attachable, dependent: :destroy, autosave: true
	belongs_to :feature_group, foreign_key: "feature_group_id"
  has_many :likes, class_name: "Like", foreign_key: "likeable_id", as: :likeable, dependent: :destroy
  accepts_nested_attributes_for :pictures, allow_destroy: true

  attr_accessible :name, :description, :pictures, :pictures_attributes, :image_asset, pictures: [:attachment]
  after_update :save_pictures

  def percent_like
    if self.likes.empty?
      return 0
    else
      return self.likes.where(up: true).size.to_f / self.likes.size.to_f
    end
  end

  def is_single?
    self.feature_group.singles?
  end

  def profile_pic
    if !self.pictures.empty?
      return self.pictures.last
    else
      return nil  
    end
  end

  def profile_pic_url(size=:large)
    case self.profile_pic
    when nil
      '/images/missing-product.jpg'
    else
      self.profile_pic.attachment.url(size)
    end
  end

  def product 
    self.feature_group.product
  end

  def rating
    up_rating = self.likes.where(up: true).size
    down_rating = self.likes.where(up: false).size
    up_rating - down_rating
  end

  def upvotes 
    self.likes.where(:up => true)
  end

  def downvotes 
    self.likes.where(:up => false)
  end

  private

    def save_pictures
      self.pictures.each do |asset| 
        asset.feature_id = self.id
        asset.user_id = self.feature_group.product.user.id
        asset.product_id = self.feature_group.product.id
        asset.save!
      end 
    end 

end
