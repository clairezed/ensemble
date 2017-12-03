module LeisureHelper

  def leisure_category_options(leisure_categorys = LeisureCategory.all)
    leisure_categorys.map do |leisure_category|
      [leisure_category.title, leisure_category.id]
    end
  end

end