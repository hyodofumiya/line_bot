require "administrate/field/base"

class DateTimeField < Administrate::Field::Base
  #date型にして返すメソッド
  def date
    I18n.localize(
      data.in_time_zone(timezone).to_date,
      format: format,
    )
  end

  #datetime型にして返すメソッド
  def datetime
    if data.present?
      I18n.localize(
        data.in_time_zone(timezone),
        format: format,
        default: data,
      )
    else
      "-"
    end
  end

  private

  def format
    options.fetch(:format, :default)
  end

  def timezone
    options.fetch(:timezone, ::Time.zone.name || "UTC")
  end

end
