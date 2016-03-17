class Api::V1::NavigationsController < Api::ApiController

  def about_us
    about_info = []
    about_info << {
      heading: 'About Agrawal Classes',
      text: 'Agrawal Classes commenced its journey of providing result oriented coaching to the students of professional courses from December 2002. The initiative taken by Prof. Ritesh Agrawal joined by a league of enthusiastic, dedicated and inspiring faculties has now grown wonderfully over a period, resulting in excellent performance of the students.'
    }

    about_info << {
      heading: 'Our Courses',
      text: 'A \n B'
    }

    about_info << {
      heading: 'Contact Us',
      text: 'Pune Press Owners Building,
        Opp. Bank of Maharashtra lane,Shastri Road,Navi Peth,
        Near Alka Talkies Theatre Tilak Road,Pune-30
        Telephone: 020-30223333 /9552551234
        Fax: +61 (2) 9542 3599
        Email: ragrawalclasses@gmail.com'
    }

    render json: get_v1_formatted_response({info: about_info}, true, ['success'])
  end

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