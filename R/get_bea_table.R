#' Download NIPA table from BEA website
#'
#' @param TableName A string with table name (see https://apps.bea.gov/api/_pdf/bea_web_service_api_user_guide.pdf)
#' @param Frequency A string with frequency (e.g. 'A,Q') - no spaces
#' @param Year A string with year (e.g. '2002,2003'); no spaces - default 'ALL'
#' @param UserID A string with BEA API id
#'
#' @return A JSON list with data and metadata
#' @export
#'
#' @examples
#' \dontrun{my_id <- options()$BEA_API
#' #' get_bea_nipa("T10106", "Q", "2022,2023", my_id)}
get_bea_nipa <- function(TableName = NULL,
                         Frequency = 'Q',
                         Year = 'ALL',
                         UserID = NULL) {
  if (is.null(TableName))
    stop("Table Name cannot be NULL")
  if (is.null(UserID))
    stop("User ID is needed (BEA API)")


  URI <- 'https://apps.bea.gov/api/data'

  # NIPA
  # required: TableName, Frequency, Year (X=ALL)
  #

  # BLS API request
  req <- httr2::request(URI) |>
    httr2::req_url_path_append(
      glue::glue(
        '?&UserID={UserID}&method=GetData&datasetname=NIPA&TableName={TableName}&Frequency={Frequency}&Year={Year}&ResultFormat=JSON'
      )
    ) |>
    httr2::req_retry(max_tries = 10)

  resp <- req |> httr2::req_perform()

  json_data <- resp |> httr2::resp_body_string() |>
    jsonlite::fromJSON()

  return(json_data)
}



#' Download NIPA Underlying Detail tables from BEA website
#'
#' @param TableName A string with table name (see https://apps.bea.gov/api/_pdf/bea_web_service_api_user_guide.pdf)
#' @param Frequency  string with frequency (e.g. 'A,Q') - no spaces
#' @param Year A string with year (e.g. '2002,2003'); no spaces - default 'ALL'
#' @param UserID A string with BEA API id
#'
#' @return A JSON list with data and metadata
#' @export
#'
#'
get_bea_nipa_detail <- function(TableName = NULL,
                         Frequency = 'Q',
                         Year = 'ALL',
                         UserID = NULL) {
  if (is.null(TableName))
    stop("Table Name cannot be NULL")
  if (is.null(UserID))
    stop("User ID is needed (BEA API)")


  URI <- 'https://apps.bea.gov/api/data'

  # NIPA
  # required: TableName, Frequency, Year (X=ALL)
  #

  # BLS API request
  req <- httr2::request(URI) |>
    httr2::req_url_path_append(
      glue::glue(
        '?&UserID={UserID}&method=GetData&datasetname=NIUnderlyingDetail&TableName={TableName}&Frequency={Frequency}&Year={Year}&ResultFormat=JSON'
      )
    ) |>
    httr2::req_retry(max_tries = 10)

  resp <- req |> httr2::req_perform()

  json_data <- resp |> httr2::resp_body_string() |>
    jsonlite::fromJSON()

  return(json_data)
}

