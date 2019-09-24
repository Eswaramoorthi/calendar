class RecurringEvent < ApplicationRecord

  has_many :events
  
  enum frequency: { weekly: 0, biweekly: 1, monthly: 2, annually: 3 }

  validates :anchor, presence: true
  validates :frequency, presence: true

  after_create :create_events

  def schedule
    @schedule ||= begin
      schedule = IceCube::Schedule.new(now = anchor)
      case frequency      
      when 'weekly'
        schedule.add_recurrence_rule IceCube::Rule.weekly(1)
      when 'biweekly'
        schedule.add_recurrence_rule IceCube::Rule.weekly(2)
      when 'monthly'
        schedule.add_recurrence_rule IceCube::Rule.monthly(1)
      when 'annually'
        schedule.add_recurrence_rule IceCube::Rule.yearly(1)
      end
      schedule
    end
  end

  def event_dates(start_date, end_date)
    start_frequency = start_date ? start_date.to_date : Date.today - 1.year
    end_frequency = end_date ? end_date.to_date : Date.today - 1.year
    schedule.occurrences_between(start_frequency, end_frequency)
  end

  def create_events
    event_dates = event_dates(anchor, end_date)
    event_dates.each do |date|
      date = date&.to_date
      events.create(start: date, color: color, title: title, end: date)
    end
  end

end
