module ApplicationHelper

  def is_active?(link_path)
    current_page?(link_path) ? "active" : ""
  end

  def foto(user)
    user.image? ? image_tag(user.image, class: 'img-circle img-thumbnail') : content_tag(:i, "", class: 'fa fa-user img-thumbnail img-circle ') 
  end
end
