class Api::V1::SubjectsController < Api::ApiController

  def get_subjects
  #   todo check is current user is there using the access token

    all_subjects = Subject.select(:id, :name).all
    render json: get_v1_formatted_response({all_subjects: all_subjects}, true, [])
  end
end