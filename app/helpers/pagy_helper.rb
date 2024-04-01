module PagyHelper
  include Pagy::Frontend

  def pagy_links(**args, &)
    tag.div(id: "pagy-links", **args, data: {controller: "toggle", toggle_visibility_class: "hidden", toggle_target: "element", "toggle-toggle-on-connect-value": true}, &)
  end
end
