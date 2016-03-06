module Api::V1::NotificationsHelper

  def send_notification(test_gcm_ids = nil, test_payload_to_send = nil)
    gcm = GCM.new("AIzaSyCEnfpiC0W7ibOHU5zufEiVomQ0eatxggI")

    registration_ids = test_gcm_ids || get_receiver_gcm_ids
    final_data_to_send = test_payload_to_send || create_data_to_send

    options = {
      :data => final_data_to_send
    }

    gcm.send(registration_ids, options)
  end

  def get_receiver_gcm_ids
    # todo generate these ids

  end

  def create_data_to_send
    {
      quiz_id: 2,
      sequence_no:1,
      max_sequence_no:10,
      question_details: {
        question_id:12,
        description:'What Fragment in Android?',
        type: 'radio_button',
        correct_option_id: '122',
        options:[
          {id:'122',text:'A sharable UI component.'},
          {id:'381',text:'A cache component.'},
          {id:'129',text:'Dependency management system.'},
          {id:'368',text:'A standalone screen.'}
        ]
      },
      scores: {
        '599' => 28,
        '228' => 20
      }
    }
  end
end