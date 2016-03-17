class Api::V1::NavigationsController < Api::ApiController

  def drawer_menu
    response = {
      drawer_menu: {
        drawer: [
          {
            text: 'About Us',
            uri: 'cacapt://about_us'
          }
        ]
      }
    }
    render json: get_v1_formatted_response(response, true, ['success'])
  end

end