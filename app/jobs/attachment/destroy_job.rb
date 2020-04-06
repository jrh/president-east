# frozen_string_literal: true
class Attachment::DestroyJob < ApplicationJob
  include SuckerPunch::Job

  def perform(data)
    attacher = Shrine::Attacher.from_data(data)
    attacher.destroy
  end
end
