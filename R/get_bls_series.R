# download US CPI from BLS using API --------------------------------------
# https://www.bls.gov/developers/api_faqs.htm

# Extract Catalog Data from BLS data --------------------------------------
#  returned from bls_download()
bls_catalog <- function(data) {
  tibble::as_tibble(data$Results$series$catalog)
}

# Extract Time Series Data from BLS data ----------------------------------
#  returned from bls_download()
bls_data <- function(data) {
  dt <- data$Results$series$data # list
  names(dt) <- data$Results$series$seriesID
  return(tibble::as_tibble(dplyr::bind_rows(dt, .id = 'series_id')))
}


# Core download - the one that access bls API
bls_download_1 <- function(seriesid, startyear = NULL, endyear = NULL, api_key = NULL) {

  if (is.null(api_key)) {
    stop('API key is needed. See https://www.bls.gov/developers/api_signature_v2.htm')
  }

  # BLS API request
  req <- httr2::request('https://api.bls.gov/publicAPI/v2/timeseries/data/') |>
    httr2::req_headers('Content-type' = 'application/json') |>
    httr2::req_body_json(
      list(seriesid        = seriesid,
           startyear       = startyear,
           endyear         = endyear,
           catalog         = TRUE,
           calculations    = FALSE,
           annualaverage   = FALSE,
           aspects         = FALSE,
           registrationkey = api_key)
    ) |> httr2::req_retry(max_tries = 20)

  resp <- req |> httr2::req_perform()

  # Check for error
  if (httr2::resp_is_error(resp)) {
    warning('Error in BLS API request')
    return()
  }

  json_data <- resp |> httr2::resp_body_string() |>
    jsonlite::fromJSON()

  return(json_data)
}

# Download when time is limited to 20y but ID LIST is large
bls_download_2 <- function(idlist, startyear = NULL, endyear=NULL, api_key = NULL) {


  # there is a limit of 50 series per request.
  nlim <- 50
  resp <- vector('list', trunc(length(idlist)/nlim) + 1)
  for (i in 1:length(resp)) {
    temp.id <- idlist[1:nlim + nlim * (i - 1)]
    temp.id <- temp.id[!sapply(temp.id, is.null)]
    resp[[i]] <- bls_download_1(temp.id, startyear, endyear, api_key)
  }
  resp.data <- dplyr::bind_rows(lapply(resp, bls_data))
  resp.catalog <- dplyr::bind_rows(lapply(resp, bls_catalog))
  return(list(data = resp.data, catalog = resp.catalog))
}

# User funciton: no restriction on # IDs and # years

#'Download BLS series
#'
#' @param idlist A list of series ID
#' @param startyear An integer indicating the start year (if NULL, use endyear - 4)
#' @param endyear An integer indicating the end year (if NULL, use current year)
#' @param api_key A character string of the API key obtained from the BLS website
#'
#' @return A list of two tibbles: data and catalog
#' @export
#'
#' @examples
#' \dontrun{my_id <- options()$blskey
#' #' get_bls_series(list("CES0000000001"), api_key = my_id)}
get_bls_series <- function(idlist, startyear=NULL, endyear=NULL, api_key = NULL) {

  if (is.null(api_key)) {
    stop('API key is needed. See https://www.bls.gov/developers/api_signature_v2.htm')
  }
  # there is a limit of 20 years
  if (!is.list(idlist)) stop("Series ID needs to be a list")
  if (is.null(idlist)) stop("Series ID need to be a list of character")
  if (is.null(endyear)) endyear = as.integer(format(Sys.Date(), "%Y"))
  if (is.null(startyear)) startyear = endyear - 4 # last 5 years of data

  nlim <- 20
  yearlist <- as.list(startyear:endyear)

  resp          <- vector('list', trunc((endyear - startyear)/nlim) + 1)
  resp.data     <- vector('list', trunc((endyear - startyear)/nlim) + 1)
  resp.catalog  <- vector('list', trunc((endyear - startyear)/nlim) + 1)

  for (i in length(resp):1) {
    year.range <- yearlist[1:nlim + nlim*(i - 1)]
    year.range <- year.range[!sapply(year.range, is.null)]
    resp[[i]]  <- bls_download_2(idlist, range(year.range)[1], range(year.range)[2], api_key)
    resp.data[[i]] <- resp[[i]]$data
    resp.catalog[[i]] <- resp[[i]]$catalog
  }

  return(list(
    data = dplyr::bind_rows(resp.data) |> dplyr::distinct(),
    catalog = dplyr::bind_rows(resp.catalog) |> dplyr::distinct()
  ))
}
