get_bls_refweek <- function(startyear, endyear) {

  get_week_interval <- function(d) {
    y <- lubridate::epiyear(d)
    w <- lubridate::epiweek(d)
    wd <- lubridate::wday(d)
    yd <- lubridate::yday(d)

    start_interval <- d
    end_interval <- d
    lubridate::yday(start_interval) <- yd - wd + 1
    lubridate::yday(end_interval) <- yd - wd + 7
    return(lubridate::interval(
      start = start_interval,
      end = end_interval,
      tz = 'UTC'
    ))
  }

  within_dec <- function(d) {
    y <- lubridate::year(d)
    ss <- lubridate::ymd(paste0(y, '12', '01'))
    ee <- lubridate::ymd(paste0(y, '12', '31'))
    dec_int <- lubridate::interval(start = ss,
                                   end = ee,
                                   tz = 'UTC')
    return(lubridate::`%within%`(get_week_interval(d), dec_int))
  }

  ref_day <- seq(
    from = lubridate::as_date(paste0(startyear, '-01-12')),
    to = lubridate::as_date(paste0(endyear, '-12-12')),
                            by = '1 month')

    # Adjustments
    # For December, if the calendar week including the 5th is contained entirely
    #  within the month of December, the December reference week will be one week
    #   earlier than normal.
    dec5   <- seq(
      from = lubridate::as_date(paste0(startyear, '-12-05')),
      to = lubridate::as_date(paste0(endyear, '-12-05')),
      by = '1 year'
    )

    ref_dec <- ref_day[lubridate::month(ref_day) == 12]
    ref_dec <- ref_dec - purrr::map_lgl(dec5, within_dec) * 7

    # For November, the reference week will be moved one week earlier if
    #  Thanksgiving falls during the week that contains the 19th, or if
    #   the Census Bureau determines that there is not enough data processing
    #    time before the survey interview week for December.
    nov19   <- seq(
      from = lubridate::as_date(paste0(startyear, '-11-19')),
      to = lubridate::as_date(paste0(endyear, '-11-19')),
      by = '1 year'
    )

    thanksgiving_dates <- lubridate::ymd(
      c(
        '18631126',
        '18641124',
        '18651207',
        '18661129',
        '18671128',
        '18681126',
        '18691118',
        '18701124',
        '18711130',
        '18721128',
        '18731127',
        '18741126',
        '18751125',
        '18761130',
        '18771129',
        '18781128',
        '18791127',
        '18801125',
        '18811124',
        '18821130',
        '18831129',
        '18841127',
        '18851126',
        '18861125',
        '18871124',
        '18881129',
        '18891128',
        '18901127',
        '18911126',
        '18921124',
        '18931130',
        '18941129',
        '18951128',
        '18961126',
        '18971125',
        '18981124',
        '18991130',
        '19001129',
        '19011128',
        '19021127',
        '19031126',
        '19041124',
        '19051130',
        '19061129',
        '19071128',
        '19081126',
        '19091125',
        '19101124',
        '19111130',
        '19121128',
        '19131127',
        '19141126',
        '19151125',
        '19161130',
        '19171129',
        '19181128',
        '19191127',
        '19201125',
        '19211124',
        '19221130',
        '19231129',
        '19241127',
        '19251126',
        '19261125',
        '19271124',
        '19281129',
        '19291128',
        '19301127',
        '19311126',
        '19321124',
        '19331130',
        '19341129',
        '19351128',
        '19361126',
        '19371125',
        '19381124',
        '19391123',
        '19401121',
        '19411120',
        '19421126',
        '19431125',
        '19441123',
        '19451122',
        '19461128',
        '19471127',
        '19481125',
        '19491124',
        '19501123',
        '19511122',
        '19521127',
        '19531126',
        '19541125',
        '19551124',
        '19561122',
        '19571128',
        '19581127',
        '19591126',
        '19601124',
        '19611123',
        '19621122',
        '19631128',
        '19641126',
        '19651125',
        '19661124',
        '19671123',
        '19681128',
        '19691127',
        '19701126',
        '19711125',
        '19721123',
        '19731122',
        '19741128',
        '19751127',
        '19761125',
        '19771124',
        '19781123',
        '19791122',
        '19801127',
        '19811126',
        '19821125',
        '19831124',
        '19841122',
        '19851128',
        '19861127',
        '19871126',
        '19881124',
        '19891123',
        '19901122',
        '19911128',
        '19921126',
        '19931125',
        '19941124',
        '19951123',
        '19961128',
        '19971127',
        '19981126',
        '19991125',
        '20001123',
        '20011122',
        '20021128',
        '20031127',
        '20041125',
        '20051124',
        '20061123',
        '20071122',
        '20081127',
        '20091126',
        '20101125',
        '20111124',
        '20121122',
        '20131128',
        '20141127',
        '20151126',
        '20161124',
        '20171123',
        '20181122',
        '20191128',
        '20201126',
        '20211125',
        '20221124',
        '20231123',
        '20241128',
        '20251127',
        '20261126',
        '20271125',
        '20281123',
        '20291122',
        '20301128',
        '20311127',
        '20321125',
        '20331124',
        '20341123',
        '20351122',
        '20361127',
        '20371126',
        '20381125',
        '20391124',
        '20401122',
        '20411128',
        '20421127',
        '20431126',
        '20441124',
        '20451123',
        '20461122',
        '20471128',
        '20481126',
        '20491125',
        '20501124',
        '20511123',
        '20521128',
        '20531127',
        '20541126',
        '20551125',
        '20561123',
        '20571122',
        '20581128',
        '20591127',
        '20601125',
        '20611124',
        '20621123',
        '20631122',
        '20641127',
        '20651126',
        '20661125',
        '20671124',
        '20681122',
        '20691128',
        '20701127',
        '20711126',
        '20721124',
        '20731123',
        '20741122',
        '20751128',
        '20761126',
        '20771125',
        '20781124',
        '20791123',
        '20801128',
        '20811127',
        '20821126',
        '20831125',
        '20841123',
        '20851122',
        '20861128',
        '20871127',
        '20881125',
        '20891124',
        '20901123',
        '20911122',
        '20921127',
        '20931126',
        '20941125',
        '20951124',
        '20961122',
        '20971128',
        '20981127',
        '20991126'
      )
    )


    tgdate <-
      thanksgiving_dates[lubridate::`%within%`(thanksgiving_dates, lubridate::interval(min(ref_day), max(ref_day)))]

    ref_nov <- ref_day[lubridate::month(ref_day) == 11]
    ref_nov <- ref_nov - lubridate::`%within%`(tgdate, get_week_interval(nov19)) * 7

    # adjust reference dates
    ref_day[lubridate::month(ref_day) == 11] <- ref_nov
    ref_day[lubridate::month(ref_day) == 12] <- ref_dec

    return(get_week_interval(ref_day))
    }
