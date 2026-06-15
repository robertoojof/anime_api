class HealthController < ApplicationController
  def health
    render json: { status: "ok" }, status: :ok
  end

  def ready
    checks = {
      database: check_database
    }

    if checks.values.all? { |c| c[:status] == "ok" }
      render json: { status: "ok", checks: checks }, status: :ok
    else
      render json: { status: "error", checks: checks }, status: :service_unavailable
    end
  end

  private

  def check_database
    start_time = Time.now

    ActiveRecord::Base.connection_pool.with_connection do |conn|
      conn.execute("SELECT 1")
    end

    duration = ((Time.now - start_time) * 1000).round(2)

    {
      status: "ok",
      response_time_ms: duration
    }

  rescue => e
    log_error("database", e)

    {
      status: "error",
      message: e.message
    }
  end

  def log_error(service, error)
    Rails.logger.error("[HEALTH CHECK] #{service.upcase} ERROR: #{error.message}")
  end
end
