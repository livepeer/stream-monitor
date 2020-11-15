module Streamer
  class MonitorPlaylist
    attr_reader :logger

    def initialize(logger:)
      @logger = logger
    end

    def decorate(cycle)
      c = cycle

      c.after(:booted) do
        c.fire(:start_monitoring_playlist) do
          c.add_tick_action(:check_playlist) do
            c.fetch_playlist!
            if c.current_playlist_size != c.expected_playlist_size
              c.fire(:unexpected_playlist)
            else
              c.fire(:valid_playlist)
            end
          end
        end

        c.add_cleanup_step(:stop_monitoring_playlist) do
          c.remove_tick_action(:check_playlist)
        end
      end

      c.after(:start_monitoring_playlist) do
        logger.info("Started playlist monitor")
      end

      c.before(:stop_monitoring_playlist) do
        logger.info("Stopping playlist monitor")
      end

      c.after(:unexpected_playlist) do
        logger.info("Unexpected Playlist:\n#{c.current_playlist}")
      end
    end
  end
end