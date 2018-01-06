# ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
#   html_tag.html_safe
# end

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  
  html = %(<div class="field_with_errors">#{html_tag}</div>).html_safe

  form_fields = [
    'textarea',
    'input',
    'select', 
    'input-group'
  ]

  elements = Nokogiri::HTML::DocumentFragment.parse(html_tag).css "label, " + form_fields.join(', ')

  elements.each do |e|
    if e[:class].present? && e[:class].include?("hidden-error")
      html = html_tag
    # elsif e.node_name.eql? 'label'
    #   html = %(<div class="field_with_errors">#{e}</div>).html_safe
    # elsif form_fields.include? e.node_name
    #   if instance.error_message.kind_of?(Array)
    #     html = %(<div class="field_with_errors">#{html_tag}<span class="help-inline text-danger">&nbsp;#{instance.error_message.uniq.join(', ')}</span></div>).html_safe
    #   else
    #     html = %(<div class="field_with_errors">#{html_tag}<span class="help-inline text-danger">&nbsp;#{instance.error_message}</span></div>).html_safe
    #   end
    end
  end
  html
end

# ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|

#   # Remove all fields with error ------------------------------------
#   # html_tag

#   # Custom field with error -----------------------------------------
#   html = %(<div class="field_with_errors">#{html_tag}</div>).html_safe

#   form_fields = [
#     'input',
#     'select'
#   ]

#   elements = Nokogiri::HTML::DocumentFragment.parse(html_tag).css "label, " + form_fields.join(', ')


#   elements.each do |e|
#     if e[:class].present? && e[:class].include?("hidden-error")
#       html = html_tag
#     end
#   end
#   html

# end