# frozen_string_literal: true

class ScThreads::IndexViewModel
  def initialize(sc_threads)
    @sc_threads = sc_threads
  end

  def to_json(*_args)
    {
      sc_threads: fetch_sc_threads,
      meta: {
        total_count: @sc_threads.total_count,
        total_pages: @sc_threads.total_pages,
        current_page: @sc_threads.current_page
      }
    }
  end

  private
    def fetch_sc_threads
      @sc_threads.includes(:sc_board).map do |thread|
        {
          id: thread.id,
          board_id: thread.sc_board_id,
          board_name: thread.sc_board.title,
          board_thumbnail_url: thread.sc_board.thumbnail_url,
          title: thread.title,
          url: thread.url,
          thumbnail_url: thread.thumbnail_url,
          thread_created_at: thread.thread_created_at.strftime("%Y/%m/%d %H:%M:%S"),
          res: thread.res,
          momentum: thread.momentum,
          updated_at: thread.updated_at.strftime("%Y/%m/%d %H:%M:%S"),
          key_words: thread.sc_thread_keywords
        }
      end
    end
end
