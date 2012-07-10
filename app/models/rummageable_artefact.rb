class RummageableArtefact

  def initialize(artefact)
    @artefact = artefact
  end

  def logger
    Rails.logger
  end

  def submit
    # API requests, if they know about the single registration API, will be
    # providing the indexable_content field to update Rummager. UI requests
    # and requests from apps that don't know about single registration, will
    # not include this field
    if should_amend
      logger.info "Posting amendments to Rummager: #{artefact_link}"
      Rummageable.amend artefact_link, artefact_hash
    else
      logger.info "Posting document to Rummager: #{artefact_link}"
      Rummageable.index [artefact_hash]
    end
  end

  def should_amend
    @artefact.indexable_content.nil?
  end

  def artefact_hash
    # This won't cope with nested values, but we don't have any of those yet
    # When we want to include additional links, this will become an issue
    rummageable_keys = Rummageable::VALID_KEYS.map { |full_key| full_key[0] }.uniq

    # When amending an artefact, requests with the "link" parameter will be
    # refused, because we can't amend the link within Rummager
    rummageable_keys.delete "link" if should_amend

    rummageable_keys.inject({}) do |hash, rummageable_key|
      strip_nils = ["indexable_content", "description"].include? rummageable_key

      # Use the relevant extraction method from this class if it exists
      if respond_to? "artefact_#{rummageable_key}"
        value = __send__ "artefact_#{rummageable_key}"
      elsif @artefact.respond_to? rummageable_key
        value = @artefact.__send__ rummageable_key
      else
        return hash
      end

      unless (strip_nils && value.nil?)
        hash[rummageable_key] = value
      end
      hash
    end
  end

  def artefact_section
    @artefact.section.split(":")[0]
  end

  def artefact_subsection
    @artefact.section.split(":")[1]
  end

  def artefact_format
    @artefact.kind
  end

  def artefact_title
    @artefact.name
  end

  def artefact_link
    "/#{@artefact.slug}"
  end
end