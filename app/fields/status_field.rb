require "administrate/field/base"

class StatusField < Administrate::Field::Base

  #on_status型を使用するカラムによってレスポンスする内容を決めるメソッド
  def on_status
    case @attribute
    when :work_status
      work_status
    when :on_work
      on_work
    end
  end

  #on_workカラムの場合のレスポンスを定義
  def on_work
    if @data
      "出勤中"
    else
      "退勤中"
    end
  end

  #work_statusカラムの場合のレスポンスを定義
  def work_status
    if @data == :break
      "休憩中"
    elsif @data == :work
      "作業中"
    end
  end
end
