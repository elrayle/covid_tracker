# frozen_string_literal: true

# Based on the Module#prepend pattern in ruby, overrides methods in Qa::TermsController
module PrependedControllers::TermsController
  # Override Qa::TermsController#check_query_param method
  def check_query_param
    # do not force query param
  end

  # converts wildcards into URL-encoded characters
  def url_search
    # allow for missing query
    params[:q].gsub("*", "%2A") if params.key? :q
  end

private

  def authority_class
    authority_name == "Covid" ? "CovidTracker::CovidApi" : "Qa::Authorities::" + authority_name
  end

  def authority_name
    params[:vocab].capitalize
  end
end
