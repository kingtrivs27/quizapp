# == Schema Information
#
# Table name: quizzes
#
#  id                     :integer          not null, primary key
#  subject_id             :integer          not null
#  requester_id           :integer          not null
#  opponent_id            :integer
#  requester_score        :integer          default(0)
#  opponent_score         :integer          default(0)
#  requester_available    :boolean          default(TRUE)
#  opponent_available     :boolean          default(TRUE)
#  requester_waiting      :boolean          default(FALSE)
#  opponent_waiting       :boolean          default(FALSE)
#  last_question_answered :integer          default(0)
#  opponent_type          :integer          default(0)
#  status                 :integer          default(0)
#  info                   :text(65535)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class Quiz < ActiveRecord::Base
  belongs_to :subject
  enum status: {pending: 0, started: 1, finished: 2}
  enum opponent_type: {human: 0, bot: 1}


  POINTS_FOR_CORRECT_ANSWER = 10

  def handle_answer_submit(params)
    option_id = params[:option_id]
    question_id = params[:question_id]
    quiz_attrs_to_update = {}

    answer_option = AnswerOption.find_by(id: option_id)
    if answer_option.question_id == question_id && answer_option.is_correct?
      quiz_attrs_to_update.merge(new_user_score)
    end

    quiz_attrs_to_update.merge(new_bot_score(params))

    send_gcm = send_gcm_push_to_users?(params)

    if send_gcm
      quiz_attrs_to_update.merge(mark_users_as_not_waiting)
    else
      quiz_attrs_to_update.merge(mark_user_as_waiting)
    end

    # update quiz attributes in one shot
    update_attributes(quiz_attrs_to_update)

    send_gcm
  end

  def handle_answer_timeout(params)
    quiz_attrs_to_update = {}

    quiz_attrs_to_update.merge(new_bot_score(params))
    send_gcm = send_gcm_push_to_users?(params)

    if send_gcm
      quiz_attrs_to_update.merge(mark_users_as_not_waiting)
      quiz_attrs_to_update.merge(update_last_question_answered_by_users(params))
    else
      quiz_attrs_to_update.merge(mark_user_as_waiting)
    end

    # update quiz attributes in one shot
    update_attributes(quiz_attrs_to_update)

    send_gcm
  end

  def handle_user_quit(params)
    quiz_attrs_to_update = {}

    quiz_attrs_to_update.merge(mark_current_user_as_not_available)

    # update quiz attributes in one shot
    update_attributes(quiz_attrs_to_update)

    # send notification to other user
    false
  end

  def new_user_score

    # update requester score
    {requestor_score: requester_score + POINTS_FOR_CORRECT_ANSWER} if is_requester_call?
    # update opponent score
    {opponent_score: opponent_score + POINTS_FOR_CORRECT_ANSWER} if is_opponent_call?
  end

  def mark_current_user_as_not_available
    {requester_available: false} if is_requester_call?
    {opponent_available: false} if is_opponent_call?
  end

  def new_bot_score(params)
    # update opponent score in case of bot_mode
    # todo use enum
    {opponent_score: params[:bot_score]} if is_opponent_bot?
  end

  def update_last_question_answered_by_users(params)
    {last_question_answered: params[:question_id]}
  end

  def send_gcm_push_to_users?(params)
    waiting = false

    # check if another person is waiting
    waiting = true if is_opponent_call? && (requester_waiting || !requester_available)
    waiting = true if is_requester_call? && (is_opponent_bot? || opponent_waiting || !opponent_available)

    notification_already_sent = (params[:question_id] == last_question_answered)

    waiting && !notification_already_sent
  end

  def mark_user_as_waiting
    {requester_waiting: true} if is_requester_call?
    {opponent_waiting: true} if is_opponent_call?
  end

  def mark_users_as_not_waiting
    # opponent should always be waiting
    if is_opponent_bot?
      {requester_waiting: false, opponent_waiting: true}
    else
      {requester_waiting: false, opponent_waiting: false}
    end
  end

  def is_requester_call?
    requestor_id == @current_user.id
  end

  def is_opponent_call?
    opponent_id == @current_user.id
  end

  def is_opponent_bot?
    opponent_type == 'bot'
  end

  def get_available_user_ids
    available_user_ids = []
    available_user_ids << opponent_id if opponent_available
    available_user_ids << requester_id if requester_available

    available_user_ids
  end

  def get_next_question_gcm_payload
    {
      show_next: true,
      scores: {
        yours: is_requester_call? ? requester_score : opponent_score,
        opponent: is_opponent_call? ? opponent_score : requester_score
      }
    }
  end

end
