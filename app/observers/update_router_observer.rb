class UpdateRouterObserver < Mongoid::Observer
  observe :artefact

  def after_save(artefact)
    RoutableArtefact.new(artefact).submit if artefact.live?
    RoutableArtefact.new(artefact).delete if artefact.archived?
  end
end
