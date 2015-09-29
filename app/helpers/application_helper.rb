module ApplicationHelper
  def hmr_script_tag(file)
    if Rails.env.development?
      javascript_include_tag "http://localhost:5000/static/#{file}"
    else
      javascript_include_tag "bundle/#{file}"
    end
  end
end
