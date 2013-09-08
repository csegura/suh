class SubDomain
  def self.matches?(request)
    Rails::logger.info "SubDomain: #{request.subdomain}"
    case request.subdomain
      when 'www', '', nil
        false
      else
        true
    end
  end
end