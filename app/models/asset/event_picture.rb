class Asset::EventPicture < Asset
    include Rails.application.routes.url_helpers

  # Configs ======================================================================

  VALID_CONTENT_TYPES = %i[
    png
    jpeg
  ].map{|type| Mime[type] }.compact.freeze

  has_attached_file :asset,
    styles: {
      thumb: "60x60#",
      detail: "150x150#",
      large: "1000x1000"
    },
    # Si stockage serveur dédié -----------------------
    url: "/uploads/event/:assetable_id/pictures/:id/:style/:custom_file_name.:extension",
    path: ":rails_root/public/uploads/event/:assetable_id/pictures/:id/:style/:custom_file_name.:extension"

    # Si stockage S3 ----------------------------------------
    # --- créer un config/s3.yml et ajouter la gem 'aws/sdk'
    #   storage: :s3,
    #   s3_credentials: "#{Rails.root}/config/s3.yml",
    #   path: "/project/posts/:assetable_id/pictures/:id/:style.:extension"

  # Validations ==================================================================

  validates_attachment :asset, presence: true,
                       content_type: { content_type: VALID_CONTENT_TYPES },
                       size:         { less_than: Rails.application.config.max_upload_size }

  # pour lever une erreur sans attendre l'upload
  before_post_process :check_file_size
  private def check_file_size
    valid?
    errors[:event_picture_file_size].blank?
  end

  def as_json(options={})
    {
      id: self.id,
      title: self.asset_file_name,
      created_at: self.created_at,
      url: self.asset.url,
      thumbnail_url: self.asset.url(:detail),
      delete_url: users_event_picture_path(self.assetable_id, self.id)
    }
  end

  private

end
