class CurrentWeeklyRate < ApplicationRecord
end

private
def insert_current_weekly_rate(base_currency, date, weekly_rates)
  CurrentWeeklyRate.create!(
    base: base_currency,
    week: date,
    AUD: weekly_rates['rates']['AUD'],
    BGN: weekly_rates['rates']['BGN'],
    BRL: weekly_rates['rates']['BRL'],
    CAD: weekly_rates['rates']['CAD'],
    CHF: weekly_rates['rates']['CHF'],
    CNY: weekly_rates['rates']['CNY'],
    CZK: weekly_rates['rates']['CZK'],
    DKK: weekly_rates['rates']['DKK'],
    EUR: weekly_rates['rates']['EUR'],
    GBP: weekly_rates['rates']['GBP'],
    HKD: weekly_rates['rates']['HKD'],
    HRK: weekly_rates['rates']['HRK'],
    HUF: weekly_rates['rates']['HUF'],
    IDR: weekly_rates['rates']['IDR'],
    ILS: weekly_rates['rates']['ILS'],
    INR: weekly_rates['rates']['INR'],
    JPY: weekly_rates['rates']['JPY'],
    KRW: weekly_rates['rates']['KRW'],
    MXN: weekly_rates['rates']['MXN'],
    MYR: weekly_rates['rates']['MYR'],
    NOK: weekly_rates['rates']['NOK'],
    NZD: weekly_rates['rates']['NZD'],
    PHP: weekly_rates['rates']['PHP'],
    PLN: weekly_rates['rates']['PLN'],
    RON: weekly_rates['rates']['RON'],
    RUB: weekly_rates['rates']['RUB'],
    SEK: weekly_rates['rates']['SEK'],
    SGD: weekly_rates['rates']['SGD'],
    THB: weekly_rates['rates']['THB'],
    TRY: weekly_rates['rates']['TRY'],
    USD: weekly_rates['rates']['USD'],
    ZAR: weekly_rates['rates']['ZAR']
  )
end