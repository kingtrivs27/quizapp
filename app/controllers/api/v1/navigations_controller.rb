class Api::V1::NavigationsController < Api::ApiController

  def drawer_menu
    response = {
        drawer: [
          {
            name: 'About Us',
            uri: 'cacpt://webview/?au=http://ec2-54-187-93-74.us-west-2.compute.amazonaws.com/v2/about_us'
          }
        ]
    }
    render json: get_v1_formatted_response(response, true, ['success'])
  end

end