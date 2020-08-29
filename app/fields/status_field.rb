require "administrate/field/base"

class StatusField < Administrate::Field::Base

  def on_status
    case @attribute
    when :work_status
      work_status
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

  def work_status
    if @data == :break
      "休憩中"
    elsif @data == :work
      "作業中"
    end
  end
end
