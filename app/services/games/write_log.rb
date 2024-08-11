# frozen_string_literal: true

module Games
  class WriteLog
    def initialize(params)
      @params = params
    end

    attr_reader :params

    def call
      game.in_progress! if game.pick_roles?

      game.game_logs.create!(log_record: format_log) if format_log.present?
    end

    def game
      @game ||= Table.find_by_token(@params[:table_token]).games.where(state: %i[pick_roles in_progress]).last
    end

    def format_log
      case params['stage']
      when 'speaking'
        format_speaking_log
      when 'preVoting'
        format_pre_voting_log
      when 'voting'
        format_voting_log
      when 'nightKill'
        format_night_kill_log
      when 'sheriffCheck'
        format_sheriff_check_log
      when 'donCheck'
        format_don_check_log
      when 'excuse'
        format_excuse_log
      when 'preFinalVoting'
        format_pre_final_voting_log
      when 'lastWords'
        format_last_words_log
      when 'dropTableVoting'
        format_drop_table_voting_log
      when 'nightFirstKilled'
        format_night_first_killed_log
      else
        ''
      end
    end

    private

    def format_night_first_killed_log
      game.info.best_moves = params['bestMoves']
      game.info.first_killed_player = params['killed']
      game.save

      "ЛХ: #{params['bestMoves'].join(', ')}"
    end

    def format_drop_table_voting_log
      count = params['votes'].to_i
      "Голосование за подъем стола - #{count} голосов"
    end

    def format_last_words_log
      player = game.games_players.find_by_number(params['player']).player.nickname

      game.info.killed_players += [params['player']]
      game.info.killed_players.uniq!
      game.save

      "Последние слова игрока #{player}"
    end

    def format_pre_final_voting_log
      accused_players = params['accused_players'].map do |accused|
        game.games_players.find_by_number(accused).player.nickname
      end

      game.info.proposed_players = params['accused_players']
      game.save

      "Повторное голосование: #{accused_players.join(', ')}"
    end

    def format_excuse_log
      accused = game.games_players.find_by_number(params['accused']).player.nickname
      "Повторная речь игрока #{accused}"
    end

    def format_speaking_log
      speaker = game.games_players.find_by_number(params['speaker']).player.nickname
      if params['speaker_accusation'].present?
        accused = game.games_players.find_by_number(params['speaker_accusation']).player.nickname
      end

      if params['speaker_accusation'].present?
        game.info.proposed_players += [params['speaker_accusation']]
        game.info.proposed_players.uniq!
        game.save
      end

      result = "#{speaker} поговорил"
      result += ", выставил на голосование #{accused}" if params['speaker_accusation'].present?
      result
    end

    def format_pre_voting_log
      accused_players = params['accused_players'].map do |accused|
        game.games_players.find_by_number(accused).player.nickname
      end
      "Выставлены на голосование: #{accused_players.join(', ')}"
    end

    def format_voting_log
      accused = game.games_players.find_by_number(params['votes_for']).player.nickname
      "Проголосовали за: #{accused} - #{params['votes']} голосов"
    end

    def format_night_kill_log
      killed = begin
        game.games_players.find_by_number(params['killed']).player.nickname
      rescue StandardError
        nil
      end

      game.info.proposed_players = []
      game.save

      if killed.present?
        game.info.killed_players += [params['killed']]
        game.info.killed_players.uniq!
        game.save
      end

      killed.present? ? "Мафия убила #{killed}" : 'Несострел'
    end

    def format_sheriff_check_log
      checked = game.games_players.find_by_number(params['player'])

      game.info.sheriff_checks += [params['player']]
      game.info.sheriff_checks.uniq!
      game.save

      "Шериф проверил #{checked.player.nickname} - #{checked.is_mafia? ? 'Мафия' : 'Мирный житель'}"
    end

    def format_don_check_log
      checked = game.games_players.find_by_number(params['player'])

      game.info.don_checks += [params['player']]
      game.info.don_checks.uniq!
      game.save

      "Дон проверил #{checked.player.nickname} - #{checked.sheriff? ? 'Шериф' : 'Не шериф'}"
    end
  end
end
