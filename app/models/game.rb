class Game < ApplicationRecord
  has_many :games_questions, class_name: 'GameQuestion', dependent: :destroy
  has_many :questions, through: :games_questions

  scope :playing, -> { joins(:games_questions).where('games_questions.answer IS NULL').group('games_questions.game_id') }
  scope :finished, -> { joins(:games_questions).where('games_questions.answer IS NOT NULL').group('games_questions.game_id').having('COUNT(games.id) = 10') }

  def self.current(session_id)
    Game.where(user_session: session_id).playing.last
  end

  def next_game_question
    games_questions.where(answer: nil).first
  end
end