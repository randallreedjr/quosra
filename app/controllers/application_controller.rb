class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def update_elasticsearch_document(question)
    # need to trigger index update
    question.__elasticsearch__.update_document
  end
end
