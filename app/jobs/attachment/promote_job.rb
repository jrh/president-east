# frozen_string_literal: true
class Attachment::PromoteJob < ApplicationJob
  include SuckerPunch::Job

  def perform(record, name, file_data)
    attacher = Shrine::Attacher.retrieve(model: record, name: name, file: file_data)
    attacher.create_derivatives
    attacher.atomic_promote
  rescue Shrine::AttachmentChanged, ActiveRecord::RecordNotFound
    # attachment has changed or record has beeen deleted, nothing to do
  end
end
