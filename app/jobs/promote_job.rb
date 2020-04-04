# frozen_string_literal: true
class PromoteJob
  include SuckerPunch::Job

  def perform(data)
    Shrine::Attacher.promote(data)
  end
end

