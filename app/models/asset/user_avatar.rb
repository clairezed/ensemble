class Asset::UserAvatar < Asset
  include Rails.application.routes.url_helpers

  # Configs ======================================================================

  VALID_CONTENT_TYPES = %i[
    png
    jpeg
  ].map{|type| Mime[type] }.compact.freeze

  has_attached_file :asset,
    styles: {
      thumb: "60x60#",
      detail: "150x150#"
    },
    default_url: ->(attach) { "defaults/:style/user_avatar.png"},

    # Si stockage serveur dédié -----------------------
    url: "/uploads/users/:assetable_id/avatars/:id/:style/:custom_file_name.:extension",
    path: ":rails_root/public/uploads/users/:assetable_id/avatars/:id/:style/:custom_file_name.:extension"

    # Si stockage S3 ----------------------------------------
    # --- créer un config/s3.yml et ajouter la gem 'aws/sdk'
    #   storage: :s3,
    #   s3_credentials: "#{Rails.root}/config/s3.yml",
    #   path: "/project/posts/:assetable_id/pictures/:id/:style.:extension"

  # Validations ==================================================================

  validates_attachment :asset, presence: true,
                       content_type: { content_type: VALID_CONTENT_TYPES },
                       size:         { less_than: Rails.application.config.max_upload_size }

  before_post_process :check_file_size
  private def check_file_size
    valid?
    errors[:user_avatar_file_size].blank?
  end


  def as_json(options={})
    {
      id: self.id,
      title: self.asset_file_name,
      created_at: self.created_at,
      url: self.asset.url,
      thumbnail_url: self.asset.url(:thumb),
      delete_url: users_avatar_path(id)
      # delete_url: users_avatar_path(self.id)
    }
  end

  private

end
