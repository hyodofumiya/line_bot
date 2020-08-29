require "administrate/field/base"

class StatusField < Administrate::Field::Base

  def on_status
    case @attribute
    when :on_break
      on_break
    when :on_work
      on_work
    end
  end

  def on_work
    if @data
      "出勤中"
    else
      "退勤中"
    end
  end

  def on_break
    if @data
      "休憩中"
    else
      "作業中"
    end
  end
end
